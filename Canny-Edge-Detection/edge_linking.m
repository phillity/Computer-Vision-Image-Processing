function E = edge_linking(G_supp, lower_threshold, upper_threshold)
    %% Connected components starting from strong edge pixels  
    % Find strong edge locations and label them 1
    E_s = G_supp > upper_threshold;
    
    % Find weak edge locations and label them 0.5
    E_w = G_supp > lower_threshold;
    E_w = (E_w - E_s) * 0.5;
    
    % Strong and weak edge map
    E = E_s + E_w;
    
    % Pad edge map with top/bottom row and left/right col of 0
    E = padarray(E, [1 1], 0, 'both');
    
    % Perform edge linking
    for r = 2:size(E,1)-1
        for c = 2:size(E,2)-1
            if E(r-1,c-1) == 1
               E = search(E, r-1, c-1); 
            end    
        end
    end
    
    % Remove any unconnected weak edges
    E(E == 0.5) = 0;
    
    % Remove edge map padding
    E(1,:) = [];
    E(:,1) = [];
    E(end,:) = [];
    E(:,end) = [];
end


%% Connected components recursive function
function E = search(E, r, c)
    neighbors = [r-1,c-1 ; r-1,c ; r-1,c+1 ; r,c+1 ; r+1,c+1 ; r+1,c ; r+1,c-1 ; r,c-1];
    
    for i = 1:size(neighbors,1)
        if E(neighbors(i,1),neighbors(i,2)) == 0.5
            E(neighbors(i,1),neighbors(i,2)) = 1;
            E = search(E,neighbors(i,1),neighbors(i,2));
        end
    end
end

