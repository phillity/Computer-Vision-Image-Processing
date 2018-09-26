# Tan-Triggs-Illumination-Equalization

**Matlab implementation of Tan-Triggs Illumination Equalization as described in their paper:**

Tan, X., and Triggs, B. "Enhanced local texture feature sets for face recognition under difficult lighting conditions.". IEEE Transactions on Image Processing 19 (2010), 1635–650. (http://ieeexplore.ieee.org/document/5411802/)

Tan-Triggs Illumination Equalization works using three steps: 
1. Gamma Correction
2. Difference of Gaussians (DoG)
3. Contrast Equalization

The Matlab script takes one input argument: tan_triggs(filepath), where filepath is a string containing the absolute path to the image on which you like to perform Tan-Triggs Illumination Equalization.

Example usage: tan_triggs('fake\file\path\image.jpg')

The output image of the Tan-Triggs Illumination Equalization will be written out to the directory which the input image comes from.

**Example results using images from the BioID Face Database (https://www.bioid.com/facedb/):**

![Sample Input Images](https://github.com/phillity/Computer-Vision-Image-Processing/blob/master/Tan-Triggs-Illumination-Equalization/sample_input.png)

![Sample Output Images](https://github.com/phillity/Computer-Vision-Image-Processing/blob/master/Tan-Triggs-Illumination-Equalization/sample_output.png)
