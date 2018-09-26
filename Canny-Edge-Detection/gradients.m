function [Gx, Gy] = gradients(X, sigma)
    %% Setup 1D Gaussian filter and get its derivative
    f_size = ceil(5 * sigma);
    if mod(f_size,2) == 0
        f_size = f_size + 1;
    end
    x = -floor(f_size/2):floor(f_size/2);
    % Get 1D Gaussian filter values
    G = (1 / (sqrt(2 * pi) * sigma)) * exp(-(x .^ 2) / (2 * sigma ^ 2));
    % Normalize filter so its values sum to 1
    G = G / sum(G);
    % Get derivate of resulting Gaussian filter
    G_der = gradient(G);
    % Normailze derivative so its values sum to 0
    pos_vals = G_der > 0;
    neg_vals = G_der < 0;
    G_der(pos_vals) = G_der(pos_vals) / sum(G_der(pos_vals));
    G_der(neg_vals) = G_der(neg_vals) / abs(sum(G_der(neg_vals)));
    
    %% Apply 1D Gaussian filter and its derivate in x and y directions
    % Compute dG/dy
    Gy = convolution(X, G);
    Gy = convolution(Gy, G_der');
    % Compute dG/dx
    Gx = convolution(X, G');
    Gx = convolution(Gx, G_der);
end