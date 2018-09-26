function [model] = pca(training_data, training_labels, num_components)
    %% PCA eigenfaces calculation
    % Use maximum number of components by default
    if isempty(num_components)
        num_components = size(training_data,2) - 1;
    end

    % Initialize model
    model = [];

    % Calculate mean face
    mu = mean(training_data, 2);

    % Subtract mean face, center training data around mean
    training_data = training_data - repmat(mu, 1, size(training_data, 2));

    % Compute principal components by using SVD on centered training data
    [U,S,V] = svd(training_data, 'econ');
    clear V;
    
    %% Build model with results
    % Mean face
    model.mu = mu;
    % Eigenfaces
    model.W = U(:, 1:num_components);
    % PCA projected training data features
    model.P = model.W' * training_data;
    % Eigenvalues
    model.D = diag(S) .^ 2;
    model.D = model.D(1:num_components);
    % Labels of training data
    model.training_labels = training_labels;
    % Dimensionality of PCA subspace
    model.dimension = num_components;
end

