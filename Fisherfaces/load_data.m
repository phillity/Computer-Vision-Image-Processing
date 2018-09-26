function [testing_data, testing_label, training_data, training_labels, img_dims] = load_data(database_filepath)
    %% Open file and read in classes and image paths
    fid = fopen(database_filepath);
    files = textscan(fid, '%s', 'Delimiter', {newline, ' '});

    % First image will be the test image
    I_test = imread(files{1}{1});
    I_test = rgb2gray(I_test);
    img_dims = size(I_test);
    testing_data = I_test(:);
    % First label will be the test image's label
    testing_label = str2double(files{1}{2});

    % Get amount of image/class pairs in the database file
    image_count = size(files{1}, 1);

    % Assign the remainder of the database to training data
    training_data = [];
    training_labels = [];
    for i = 3:2:image_count
        I_trainging = imread(files{1}{i});
        I_trainging = rgb2gray(I_trainging);
        if size(I_trainging) ~= img_dims
            I_trainging = imresize(I_trainging, img_dims);
        end
        training_data = [training_data, I_trainging(:)];

        label = str2double(files{1}{i+1});
        training_labels = [training_labels, label];
    end

    % Convert test and training data datatype to double
    testing_data = double(testing_data);
    training_data = double(training_data);
end

