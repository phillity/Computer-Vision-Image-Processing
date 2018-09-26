# Canny Edge Detection

**Matlab implementation of Canny Edge Detection as described in the paper:**

J. Canny, "A Computational Approach to Edge Detection," in IEEE Transactions on Pattern Analysis and Machine Intelligence, vol. PAMI-8, no. 6, pp. 679-698, Nov. 1986. (http://ieeexplore.ieee.org/document/4767851/)

Canny Edge Detection is a computer vision approach which works by:
1. Filtering image with x and y derivates of a Gaussian filter.
2. Find the magnitude and orentation of resulting gradient.
3. Non-maxima suppression using gradient direction, bilinear interpolation and gradient magnitude.
4. Thresholding using hysteresis (lower and upper) thresholding.
5. Edge linking to keep weak edges which are connected to strong edges and to dispose of weak edges which are not connected to strong edges.

The Matlab script takes four input arguments: canny(filepath, sigma, lower_threshold, upper_threshold), where filepath is a string containing the absolute path to the image on which you like to perform Canny Edge Detection, sigma is a double value used in Gaussian filtering (sqrt(2) by default) and lower_threshold and upper_threshold are double threshold values used in hysteresis thresolding (set dynamically by default).

Example usage: canny('fake\file\path\image.jpg')

**Example results using the Lenna standard test image (https://en.wikipedia.org/wiki/Lenna):**

![Sample](https://github.com/phillity/Computer-Vision-Image-Processing/blob/master/Canny-Edge-Detection/sample.png)