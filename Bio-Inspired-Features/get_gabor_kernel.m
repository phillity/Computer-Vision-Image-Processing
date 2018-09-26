% Tyler Phillips
% phillity@umail.iu.edu
% February 18, 2018

%% OpenCV cv::getGaborKernel to Matlab get_gabor_kernel Conversion
% https://github.com/opencv/opencv/blob/master/modules/imgproc/src/gabor.cpp

% height, width - size of the filter returned
% sigma - standard deviation of the gaussian envelope
% theta - orientation of the normal to the parallel stripes of a Gabor function (radians)
% lambda - wavelength of the sinusoidal factor
% gamma - ppatial aspect ratio
% psi - phase offset

function gabor_kernel = get_gabor_kernel(height, width, sigma, theta, lambda, gamma, psi)
    % default value for psi
    if size(psi) == 0
        psi = pi * 0.5;
    end

    sigma_x = sigma;
    sigma_y = sigma / gamma;
    nstds = 3;

    c = cos(theta);
    s = sin(theta);

    if width > 0
        x_max = floor(width / 2);
    else
        x_max = round(max(abs(nstds * sigma_x * c), abs(nstds * sigma_y * s)));
    end

    if height > 0
        y_max = floor(height / 2);
    else
        y_max = round(max(abs(nstds * sigma_x * s), abs(nstds * sigma_y * c)));
    end

    x_min = -x_max;
    y_min = -y_max;

    gabor_kernel = zeros(y_max - y_min + 1, x_max - x_min + 1);
    scale = 1;
    e_x = -0.5 / (sigma_x * sigma_x);
    e_y = -0.5 / (sigma_y * sigma_y);
    cscale = pi * 2 / lambda;

    for y = y_min:y_max
        for x = x_min:x_max
            x_r = x * c + y * s;
            y_r = -x * s + y * c;

            gabor_kernel(y_max - y + 1, x_max - x + 1) = scale * exp(e_x * x_r * x_r + e_y * y_r * y_r) * cos(cscale * x_r + psi);
        end
    end
end

