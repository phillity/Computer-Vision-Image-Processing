# Eigenfaces

**Matlab implementation of Eigenfaces as described in the paper:**

M. A. Turk and A. P. Pentland, "Face recognition using eigenfaces," Proceedings. 1991 IEEE 1991 IEEE Computer Society Conference on Computer Vision and Pattern Recognition, Maui, HI, 1991, pp. 586-591. (http://ieeexplore.ieee.org/document/139758/)

Eigenfaces is a Principal Component Analysis (PCA) approach which works by:
1. Reshaping each training image into a vector and then organizing the resulting training vectors into a combined training matrix.
2. Performing PCA on the training matrix to obtain representative eigenfaces. 
3. Using eigenfaces to project training vectors into PCA subspace in order to obtain reduced dimensionality training feature vectors.
4. Using eigenfaces to project testing image vectors into PCA subspace in order to obtain reduced dimensionality testing feature vectors.
5. Performing classification using reduced dimensionality testing and training feature vectors (this implementation uses KNN).

In order to load an entire database of images, a database file is used. The database file should contain a line for each image to be used. The first line will always be considered as the testing image line, and the remaining lines will be training image lines. Each line in the database file should contain the absolute/relative filepath of the image to be used followed by a space and the class label which the image belongs to. For example:
```
attfaces\s1\1.jpg 1
attfaces\s1\2.jpg 1
attfaces\s1\3.jpg 1
attfaces\s1\4.jpg 1
attfaces\s1\5.jpg 1
...
```

The Matlab script takes two input arguments: eigenfaces(database_filepath, num_components), where database_filepath is a string containing the absolute path to the database file containing aforementioned image filepath/label information and num_components is an integer amount of principal components to reduce dimensionality to. 

Example usage: eigenfaces('fake\file\path\database.txt', 25)

**Example mean face image and first ten eigenfaces using the AT&T (also known as ORL) Face Database (http://www.cl.cam.ac.uk/research/dtg/attarchive/facedatabase.html):**

Mean face:

![Sample](https://github.com/phillity/Eigenfaces/blob/master/meanface.jpg)

First ten eigenfaces:

![Sample](https://github.com/phillity/Eigenfaces/blob/master/eigenfaces.jpg)