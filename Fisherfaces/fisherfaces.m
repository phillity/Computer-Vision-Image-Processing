% Tyler Phillips
% phillity@umail.iu.edu
% March 20, 2018

%% Fisherfaces

% P. N. Belhumeur, J. P. Hespanha and D. J. Kriegman, 
% "Eigenfaces vs. Fisherfaces: recognition using class specific linear projection," 
% in IEEE Transactions on Pattern Analysis and Machine Intelligence, vol. 19, no. 7, pp. 711-720, Jul 1997. 

% http://ieeexplore.ieee.org/document/598228/

function fisherfaces(database_filepath, num_components)
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
        disp('Usage: fisherfaces(database_filepath, num_components)')
        return;
    end

    %% Load data using database file
    [testing_image, testing_label, training_data, training_labels, img_dims] = load_data(database_filepath);

    %% Build fisherfaces model using LDA
    model = lda(training_data, training_labels, num_components);
    
    % Write out some fisherfaces
    if num_components > 10
        n = 10;
    else
        n = num_components;
    end
    for i = 1:n
        fisherface = reshape(model.W(:,i), img_dims);
        fisherface = uint8(255 * mat2gray(fisherface));
        imwrite(fisherface, strcat('fisherface_', num2str(i), '.jpg'));
    end
    
    % Write out mean face
    meanface = reshape(model.mu, img_dims);
    meanface = uint8(meanface / max(meanface(:)) * 255);
    imwrite(meanface, 'meanface.jpg');
    
    %% Project test image into LDA subspace
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

