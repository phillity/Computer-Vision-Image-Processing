# Harris-Stepehens Corner Detection

**Matlab implementation of Harris-Stepehens Corner Detection as described in the paper:**

C. Harris and M. Stephens, "A combined corner and edge detector," in Proceedings of the fourth Alvey Vision Conference, pp. 147–151, August 1988. (http://www.bmva.org/bmvc/1988/avc-88-023.pdf)

Harris-Stepehens Corner Detection is a computer vision approach which works by:
1. Computing the input image derivatives in horizontal (Ix) and vertical (Iy) directions.
2. Obtaining the squares of the image derivatives (Ixx, Ixy and Iyy).
3. Smoothing sqaures of derivatives using a Gaussian filter.
4. Computing "cornerness function" (R = (Ixx .* Iyy - Ixy .^2) - k * (Ixx + Iyy) .^ 2) in order to locate pixels of interest.
5. Performing non-maxima supression and thresholding in order to identify best corner candidate pixels.

The Matlab script takes three input arguments: harris_stephens(filepath, sigma, k), where filepath is a string containing the absolute path to the image on which you like to perform Harris-Stepehens Corner Detection, sigma is a double value used in Gaussian filtering (1 by default) and k is a double constant factor used in the conerness function (0.04 by default).

Example usage: harris_stephens('fake\file\path\image.jpg')

**Example corner detection results:**

![Sample](https://github.com/phillity/Computer-Vision-Image-Processing/blob/master/Harris-Stephens-Corner-Detection/sample.PNG)
