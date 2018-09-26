# Connected Components

**Matlab implementation of Otsu Thresholding and Connected Components as described in the papers:**

[1] N. Otsu, "A Threshold Selection Method from Gray-Level Histograms," in IEEE Transactions on Systems, Man, and Cybernetics, vol. 9, no. 1, pp. 62-66, Jan. 1979. (https://ieeexplore.ieee.org/document/4310076/)

[2] H. Samet and M. Tamminen, "Efficient component labeling of images of arbitrary dimension represented by linear bintrees," in IEEE Transactions on Pattern Analysis and Machine Intelligence, vol. 10, no. 4, pp. 579-586, Jul 1988. (https://ieeexplore.ieee.org/document/3918/)

Otsu's Thresholding method binarizes a grayscale image by:
1. Creating a histogram of grayscale image pixel values.
2. Smoothing the pixel value histogram.
3. Assuming a bimodal distribution of background and foreground pixels, Otsu’s method calculates the optimal threshold such that the two classes’ (foreground and background) intra-class variance is minimal and their inter-class variance is maximal.
4. A resulting binary image containing only values of 0 and 1 is returned.

(Recursive) Connected Components segments a binary image by:
1. Negating the binary image. All foreground pixels will be -1 and will need to a component labeled. All background pixels will remain 0 and will be considered one component.
2. Iterating over each pixel in the image and searching for unlabeled pixels to label. 
	* When an unlabeled -1 pixel is encountered, the pixel is assigned the current label value (starting from 1). Connected unlabeled pixels are recursively labeled until no unlabeled pixels are connected to the original found unlabeled pixel. Finally, the label counter is incremented.
3. A resulting image of the connected components is returned.

The Matlab script takes one input argument: connected_components(filepath), where filepath is a string containing the absolute path to the image on which you like to perform Otsu Thresholding and Connected Component.

Example usage: canny('fake\file\path\image.jpg')

**Example Input Image, Otsu Binary Image and Connected Components Image:**

![Sample](https://github.com/phillity/Computer-Vision-Image-Processing/blob/master/Connected-Components/sample.png)