function label = knn(P, Q, training_labels, k)
    %% Classify test data using training data and training labels
    % Set k equal to 1 by default
    if isempty(k)
        k = 1;
    end
    
    % Get amount of training vectors in training matrix
    n = size(P, 2);
    
    % Remap test vector to be size of training matrix
    Q = repmat(Q, 1, n);
    
    % Get distance between tresting vector and each training vector
    distances = sqrt(sum(power((P - Q),2),1));
    [distances, idx] = sort(distances);
    clear distances;
    
    % Sort training labels based on distance from testing vector
    training_labels = training_labels(idx);
    training_labels = training_labels(1:k);
    
    % For k closest training vectors, see which labels they belong to
    h = histcounts(training_labels,(1:max(training_labels)));
    % Of k closest training vectors, the most frequent label is the label we use to classify the testing vector
    [count,label] = max(h);
    clear count;
end

