function Y = convolution(X, F)
    % Initialize output 
    Y = zeros(size(X));

    %% Flip filter for convolution (we don not want correlation!)
    F = flip(F);

    %% Pad input image by replicating the border values
    % Amount of row/column pads depend on filter size
    X_pad = padarray(X, [floor(size(F,1)/2) floor(size(F,2)/2)], 'replicate', 'both');
    
    %% Perform convolution
    for r = 1:size(X,1)
        for c = 1:size(X,2)
            Y(r,c) = sum(sum(F .* X_pad(r:r+size(F,1)-1,c:c+size(F,2)-1)));
        end
    end
end