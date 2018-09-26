# Local Binary Patterns

**Matlab implementation of Local Binary Patterns as described in the papers:**

[1] T. Ojala, M. Pietikainen and D. Harwood, "Performance evaluation of texture measures with classification based on Kullback discrimination of distributions," Proceedings of 12th International Conference on Pattern Recognition, Jerusalem, 1994, pp. 582-585 vol.1. (http://ieeexplore.ieee.org/document/576366/)

[2] T. Ojala, M. Pietikainen and T. Maenpaa, "Multiresolution gray-scale and rotation invariant texture classification with local binary patterns," in IEEE Transactions on Pattern Analysis and Machine Intelligence, vol. 24, no. 7, pp. 971-987, Jul 2002. (http://ieeexplore.ieee.org/document/1017623/)

[3] T. Ahonen, A. Hadid and M. Pietikainen, "Face Description with Local Binary Patterns: Application to Face Recognition," in IEEE Transactions on Pattern Analysis and Machine Intelligence, vol. 28, no. 12, pp. 2037-2041, Dec. 2006. (http://ieeexplore.ieee.org/document/1717463/)

### (Original) Local Binary Patterns [1]
(Original) Local Binary Patterns works by:
1. Forming a 3x3 pixel neighborhood around each pixel in the input image.
2. Comparing the inner pixel to each of the neighbor pixels.
	* If the inner pixel is greater than or equal to the neighbor pixel, a 1 is added to the binary number output.
	* If the inner pixel is less than the neighbor pixel, a 0 is added to the binary number output.
3. The binary number output (eight bits long) is converted to a decimal number (0-255), and the corresponding pixel in the output image is assigned this value.

The Matlab script takes one input argument: olbp(filepath), where filepath is a string containing the absolute path to the image on which you like to perform (Original) Local Binary Patterns.

Example usage: olbp('fake\file\path\image.jpg')

**Example results using the Lenna standard test image (https://en.wikipedia.org/wiki/Lenna):**

![Sample](https://github.com/phillity/Computer-Vision-Image-Processing/blob/master/Local-Binary-Patterns/olbp/olbp_sample.png)

### (Extended) Local Binary Patterns [2]
(Extended) Local Binary Patterns works by:
1. Forming a circular pixel neighborhood around each pixel in the input image with radius r and pixel neighbor count p.
2. Comparing the inner pixel to each of the neighbor pixels.
	* If the inner pixel is greater than or equal to the neighbor pixel, a 1 is added to the binary number output.
	* If the inner pixel is less than the neighbor pixel, a 0 is added to the binary number output.
3. The binary number output (p bits long) is converted to a decimal number, and the corresponding pixel in the output image is assigned this value.
3. The output image is normalized to 0-255 pixel values.

The Matlab script takes three input arguments: elbp(filepath, r, p), where filepath is a string containing the absolute path to the image on which you like to perform (Extended) Local Binary Patterns, r is the integer pixel radius of the circular neighborhood and p is the integer amount of neighbors in the circular neighborhood.

Example usage: elbp('fake\file\path\image.jpg', 1, 8)

**Example results using the Lenna standard test image (https://en.wikipedia.org/wiki/Lenna):**

![Sample](https://github.com/phillity/Computer-Vision-Image-Processing/blob/master/Local-Binary-Patterns/elbp/elbp_sample.png)

### Local Binary Patterns Histograms [3]
Local Binary Patterns Histograms works by:
1. Retrieving LBPH feature vectors for each training image. This involves: 
	* Applying ELBP to each training image.
	* Splitting each ELBP training image into some number of spatial cells.
	* Forming a histogram of intensity occurrences for each cell.
	* Combining each resulting histogram from an ELBP image into a corresponding LBPH feature vector.
2. Retrieving a LBPH feature vector for the testing image.
3. Performing classification using LBPH testing and training feature vectors (this implementation uses KNN).

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

The Matlab script takes five input arguments: lbph_rec(database_filepath, r, p, cells_x, cells_y), where database_filepath is a string containing the absolute path to the database file containing aforementioned image filepath/label information, r is the integer pixel radius of the circular neighborhood, p is the integer amount of neighbors in the circular neighborhood and cells_x and cell_y are the integer numbers of cells in the horizontal and vertical directions respectively.

Example usage: lbph('fake\file\path\database.txt', 1, 8, 8, 8)
