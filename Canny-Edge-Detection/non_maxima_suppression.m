function G_supp = non_maxima_suppression(G_mag, Gx, Gy)
    %% Perform non-maxima suppression perpendicular to direction of gradient
    % Initailize output 
    G_supp = zeros(size(G_mag));
    
    % Pad gradient magnitude with top/bottom row and left/right col of -1
    G_mag = padarray(G_mag, [1 1], -1, 'both');
        
    % Perform non-maxima suppression
    for r = 2:size(G_mag,1)-1
        for c = 2:size(G_mag,2)-1
            % Based on gradient orientation choose which of four bilinear interpolation cases and set sampling weights
            % Sample between right/top right and left/bottom left neighbor pixels
            if (Gx(r-1,c-1) > -Gy(r-1,c-1) && Gy(r-1,c-1) <= 0) || (Gx(r-1,c-1) < -Gy(r-1,c-1) && Gy(r-1,c-1) >= 0)
                w = abs(Gy(r-1,c-1) / Gx(r-1,c-1));
                s_1 = w * G_mag(r-1, c+1) + (1-w) * G_mag(r, c+1);
                s_2 = w * G_mag(r+1, c-1) + (1-w) * G_mag(r, c-1);
            % Sample between top right/top and bottom left/bottom neighbor pixels
            elseif (Gx(r-1,c-1) > 0 && -Gy(r-1,c-1) >= Gx(r-1,c-1)) || (Gx(r-1,c-1) < 0 && -Gy(r-1,c-1) <= Gx(r-1,c-1))
                w = abs(Gx(r-1,c-1) / Gy(r-1,c-1));
                s_1 = w * G_mag(r-1, c) + (1-w) * G_mag(r-1, c+1);
                s_2 = w * G_mag(r+1, c) + (1-w) * G_mag(r+1, c-1);
            % Sample between top/top left and bottom/bottom right neighbor pixels
            elseif (Gx(r-1,c-1) <= 0 && Gx(r-1,c-1) > Gy(r-1,c-1)) || (Gx(r-1,c-1) >= 0 && Gx(r-1,c-1) < Gy(r-1,c-1))
                w = abs(Gx(r-1,c-1) / Gy(r-1,c-1));
                s_1 = w * G_mag(r-1, c-1) + (1-w) * G_mag(r-1, c);
                s_2 = w * G_mag(r+1, c+1) + (1-w) * G_mag(r+1, c);
            % Sample between top left/eft and bottom right/right neighbor pixels
            else
                w = abs(Gy(r-1,c-1) / Gx(r-1,c-1));
                s_1 = w * G_mag(r, c-1) + (1-w) * G_mag(r-1, c-1);
                s_2 = w * G_mag(r, c+1) + (1-w) * G_mag(r+1, c+1);
            end
            % If gradient magnitude is less than sampled magnitudes, suppress it
            if max([s_2;G_mag(r,c);s_1]) == G_mag(r,c)
                G_supp(r-1,c-1) = G_mag(r,c);
            end
        end
    end
end