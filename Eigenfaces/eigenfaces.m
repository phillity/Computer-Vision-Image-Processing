% Tyler Phillips
% phillity@umail.iu.edu
% February 5, 2018

%% Eigenfaces

% M. A. Turk and A. P. Pentland, 
% "Face recognition using eigenfaces," 
% Proceedings. 1991 IEEE 1991 IEEE Computer Society Conference on Computer Vision and Pattern Recognition, Maui, HI, 1991, pp. 586-591.

% http://ieeexplore.ieee.org/document/139758/

function eigenfaces(database_filepath, num_components)
    %% Get command line parameter(s)
    % Clear command line, make number formatting long
    clc
    format long

    % Argument num_components is optional
    if nargin < 2
        num_components = [];
    end

    % Check input arguments exist 
    database_filepath_arg = exist('database_filepath','var');

    % If input argument is missing, print error message
    % Request needed argument and give example usage
    if ~database_filepath_arg
        disp('Missing needed arguments:')
        disp('database_filepath (string) - absolute path to database text file file')
        disp('num_components (int) - number of components to use when building eigenfaces model')
        disp('Usage: eigenfaces(database_filepath, num_components)')
        return;
    end

    %% Load data using database file
    [testing_image, testing_label, training_data, training_labels, img_dims] = load_data(database_filepath);

    %% Build eigenfaces model using PCA
    model = pca(training_data, training_labels, num_components);
    
    % Write out some eigenfaces
    if num_components > 10
        n = 10;
    else
        n = num_components;
    end
    for i = 1:n
        eigenface = reshape(model.W(:,i), img_dims);
        eigenface = uint8(255 * mat2gray(eigenface));
        imwrite(eigenface, strcat('eigenface_', num2str(i), '.jpg'));
    end
    
    % Write out mean face
    meanface = reshape(model.mu, img_dims);
    meanface = uint8(meanface / max(meanface(:)) * 255);
    imwrite(meanface, 'meanface.jpg');
    
    %% Project test image into PCA subspace
    % Subtract mean face from test image
    testing_image = testing_image - model.mu;
    % Project test image into PCA subspace
    Q = model.W' * testing_image;
    
    %% Classification using KNN
    classification_label = knn(model.P, Q, model.training_labels, []);
    
    if classification_label == testing_label
        msg = ['Test image from class ', num2str(testing_label), ' correctly classified as class ', num2str(classification_label)];
        disp(msg);
    else
        msg = ['Test image from class ', num2str(testing_label), ' incorrectly classified as class ', num2str(classification_label)];
        disp(msg);
    end
end

