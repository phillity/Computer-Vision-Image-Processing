# Bio-Inspired-Features

**Matlab implementation of Bio-Inspired Features (BIF) as described in the papers:**

[1] G. Guo, Guowang Mu, Y. Fu and T. S. Huang, "Human age estimation using bio-inspired features," 2009 IEEE Conference on Computer Vision and Pattern Recognition, Miami, FL, 2009, pp. 112-119. (http://ieeexplore.ieee.org/document/5206681/)

[2] Spizhevoi, A. S., and A. V. Bovyrin. "Estimating human age using bio-inspired features and the ranking method." Pattern Recognition and Image Analysis 25.3 (2015): 547-552. (https://dl.acm.org/citation.cfm?id=2822064)

Bio-Inspired Feature extraction works by:
1. (S-Layer) Applying bands (pairs of Gabor kernels) at several orientations to obtain texture information.
2. (C-Layer) Each band is used to obtain a single feature (results of the pair of Gabor kernels are combined using a MAX operation). For each combined feature, sum and squared integral images are obtained. Using the integral images, the mean and standard deviation are obtained for several regions (the size of which depends on a pooling grid parameter) of each band feature. Each of these regions overlap in fixed amounts (depending on the band). Finally, all the obtained standard deviations are recorded into a single BIF feature vector.

S-Layer and C-Layer parameters given by [1]:

![Sample](https://github.com/phillity/Bio-Inspired-Features/blob/master/parameters.PNG)

The Matlab script takes three input arguments: bif(filepath, bands, rotations), where filepath is a string containing the absolute path to the image in which you would like to extract Bio-Inspired Features, bands is an integer amount of Gabor kernel pairs that will be applied to the input image using the author's given parameters (8 maximum) and rotations is an integer amount of angles in which each band is applied.

Example usage: bif('fake\file\path\image.jpg', 8, 12)

This project also includes (and makes use of) Matlab conversions of two OpenCV functions: cv::getGaborKernel (get_gabor_kernel.m) and cv::filter2D (filter_2D.m). The first script, get_gabor_kernel.m, allows the user to create Gabor kernels with custom height, width, sigma, theta, lambda, gamma and psi parameters. The second script, filter_2D.m, allows the user to apply 2D filters to grayscale images using OpenCV BORDER_DEFAULT, OpenCV BORDER_REPLICATE or zero padding.