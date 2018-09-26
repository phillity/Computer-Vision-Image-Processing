function [lda_model] = lda(training_data, training_labels, num_components)
    %% LDA fisherfaces calculation
    % Get number of training vectors and class labels
    N = size(training_data,2);
    c = max(training_labels);
    
    % Use c-1 number of components by default
    if isempty(num_components)
        num_components = c - 1;
    end
    num_components = min(num_components, c - 1);
    
    % Initialize model
    lda_model = [];
    
    % Compute PCA model
    pca_model = pca(training_data, training_labels, (N - c));
    
    % Calculate PCA training mean
    mu = mean(pca_model.P, 2);
    
    % Calculate between-class scatter matrix (Sb) and within-class scatter matrix (Sw)
    Sb = zeros(size(pca_model.P,1), size(pca_model.P,1));
    Sw = zeros(size(pca_model.P,1), size(pca_model.P,1));
    for i = 1:c
        % Get matrix of class label i PCA vectors 
        Xi = pca_model.P(:, find(i == training_labels));
        % Get class i mean
        class_mu = mean(Xi,2);
        % Center class i data around class mean
        Xi = Xi - repmat(class_mu, 1, size(Xi,2));
        % Calculate Sb
        Sb = Sb + size(Xi,2) * (class_mu - mu) * (class_mu - mu)';
        % Calculate Sw
        Sw = Sw + Xi * Xi';
    end
    
    % Find eigenvectors and eigenvalues using Sb and Sw
    [V,S] = eig(Sb,Sw);
    
    % Sort eigenvectors and eigenvalues in descending order
    [S,idx] = sort(diag(S), 1, 'descend');
    V = V(:,idx);
    
    %% Build model with results
    % Mean face
    lda_model.mu = pca_model.mu;
    % Fisherfaces
    lda_model.W = V(:,1:num_components);
    lda_model.W = pca_model.W * lda_model.W;
    % LDA projected training data features
    lda_model.P = lda_model.W' * training_data;
    % Eigenvalues
    lda_model.D = S(1:num_components);
    % Labels of training data
    lda_model.training_labels = training_labels;
    % Dimensionality of LDA subspace
    lda_model.dimension = num_components;
end

