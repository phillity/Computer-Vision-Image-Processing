# Fisherfaces

**Matlab implementation of Fisherfaces as described in the paper:**

P. N. Belhumeur, J. P. Hespanha and D. J. Kriegman, "Eigenfaces vs. Fisherfaces: recognition using class specific linear projection," in IEEE Transactions on Pattern Analysis and Machine Intelligence, vol. 19, no. 7, pp. 711-720, Jul 1997. (http://ieeexplore.ieee.org/document/598228/)

Fisherfaces is a Linear Discriminant Analysis (LDA) approach which works by:
1. Reshaping each training image into a vector and then organizing the resulting training vectors into a combined training matrix.
2. Performing PCA on the training matrix to obtain representative eigenfaces. 
3. Using eigenfaces to project training vectors into PCA subspace in order to obtain reduced dimensionality training feature vectors.
4. Performing LDA on reduced dimensionality training vectors to obtain class-representative fisherfaces. This involves:
	* Finding within-class scatter Sw and between-class scatter Sb for each class. 
	* Using Sw and Sb to solve eigenvector/eigenvalue problem. 
	* Using resulting eigenvectors and eigenfaces to calculate fisherfaces.
5. Using fisherfaces to project training vectors into LDA subspace in order to obtain reduced dimensionality training feature vectors.
6. Using fisherfaces to project testing image vectors into LDA subspace in order to obtain reduced dimensionality testing feature vectors.
7. Performing classification using reduced dimensionality testing and training feature vectors (this implementation uses KNN).

In order to load an entire database of images, a database file is used. The database file should contain a line for each image to be used. The first line will always be considered as the testing image line, and the remaining lines will be training image lines. Each line in the database file should contain the absolute/relative filepath of the image to be used followed by a space and the class label which the image belongs to. For example:
```
yalefaces\s1\1.jpg 1
yalefaces\s1\10.jpg 1
yalefaces\s1\2.jpg 1
yalefaces\s1\3.jpg 1
yalefaces\s1\4.jpg 1
yalefaces\s1\5.jpg 1
...
```

The Matlab script takes two input arguments: fisherfaces(database_filepath, num_components), where database_filepath is a string containing the absolute path to the database file containing aforementioned image filepath/label information and num_components is an integer amount of principal components to reduce dimensionality to. 

Example usage: fisherfaces('fake\file\path\database.txt', 25)

**Example mean face image and first ten fisherfaces using the Yale Face Database (http://web.mit.edu/emeyers/www/face_databases.html):**

Mean face:

![Sample](https://github.com/phillity/Fisherfaces/blob/master/meanface.jpg)

First ten fisherfaces:

![Sample](https://github.com/phillity/Fisherfaces/blob/master/fisherfaces.jpg)