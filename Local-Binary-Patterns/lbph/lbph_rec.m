% Tyler Phillips
% phillity@umail.iu.edu
% March 21, 2018

%% Local Binay Pattern Histograms (LBPH)

% T. Ahonen, A. Hadid and M. Pietikainen, 
% "Face Description with Local Binary Patterns: Application to Face Recognition," 
% in IEEE Transactions on Pattern Analysis and Machine Intelligence, vol. 28, no. 12, pp. 2037-2041, Dec. 2006.

% http://ieeexplore.ieee.org/document/1717463/

function lbph_rec(database_filepath, r, p, cells_x, cells_y)
    %% Get command line parameter(s)
    % Clear command line, make number formatting long
    clc
    format long

    % Check input arguments exist 
    database_filepath_arg = exist('database_filepath','var');
    r_arg = exist('r','var');
    p_arg = exist('p','var');
    cells_x_arg = exist('cells_x','var');
    cells_y_arg = exist('cells_y','var');

    % If input arguments are missing, print error message
    % Request needed arguments and give example usage
    if ~database_filepath_arg || ~r_arg || ~p_arg || ~cells_x_arg || ~cells_y_arg
        disp('Missing needed arguments:')
        disp('filepath (string) - absolute path to image file')
        disp('r (int) - pixel radius of circular LBP neighborhood')
        disp('p (int) - number of neighbors in LBP neighborhood')
        disp('cells_x (int) - number of cells in horizontal direction')
        disp('cells_y (int) - number of cells in vertical direction')
        disp('Usage: lbph_rec(filepath, r, p)')
        return;
    end

    %% Load data using database file
    [testing_image, testing_label, training_data, training_labels, img_dims] = load_data(database_filepath);

    %% Build LBPH model using ELBP and given r, p, cells_x and cells_y parameters
    model = [];
    model.P = zeros(cells_x * cells_y * (2 ^ p), size(training_data,2));
    for i = 1:size(training_data,2)
        model.P(:,i) = lbph(training_data(:,i), r, p, cells_x, cells_y, img_dims);
    end
    model.training_labels = training_labels;
    
    %% Get LBPH feature vector from test image
    Q = lbph(testing_image, r, p, cells_x, cells_y, img_dims);
    
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

