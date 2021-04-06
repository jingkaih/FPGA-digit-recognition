import numpy as np
from keras.datasets import mnist
import matplotlib.pyplot as plt
import copy
# This is a easy calculator for network inference
# Given the weights matrix and the below equations:
# Z1 = W1 * X
# A1 = activation(Z1)
# Z2 = W2 * A1
# A2 = activation(Z2)
# Z3 = W2 * A2
# A3 = activation(Z3)
# Do simple matrix multiplication
# With no Keras.model involved


# Define activation
def bi_tanh_activation(x):
    if(x >= 0):
        return 1
    else:
        return -1

# Load MNIST test set
x_test, y_test = mnist.load_data()[1]


# Binarize test set
x_test = x_test.astype("float32")
x_test /= 255
for img_cnt in range(x_test.shape[0]):
    for i in range(28):
        for j in range(28):
            if(x_test[img_cnt][i][j] > 0.0):
                x_test[img_cnt][i][j] = 1.0
            else:
                x_test[img_cnt][i][j] = 0.0# Note that here we put 0, not -1.

# Plot
plt.subplot(331)
plt.imshow(x_test[1], cmap=plt.get_cmap('gray'))#x_test[1] = 2
plt.subplot(332)
plt.imshow(x_test[2], cmap=plt.get_cmap('gray'))#x_test[2] = 1
plt.subplot(333)
plt.imshow(x_test[3], cmap=plt.get_cmap('gray'))#0
plt.subplot(334)
plt.imshow(x_test[4], cmap=plt.get_cmap('gray'))#4
plt.subplot(335)
plt.imshow(x_test[5], cmap=plt.get_cmap('gray'))#1
plt.subplot(336)
plt.imshow(x_test[6], cmap=plt.get_cmap('gray'))#4
plt.subplot(337)
plt.imshow(x_test[7], cmap=plt.get_cmap('gray'))#9
plt.subplot(338)
plt.imshow(x_test[8], cmap=plt.get_cmap('gray'))#5
plt.subplot(339)
plt.imshow(x_test[9], cmap=plt.get_cmap('gray'))#9

plt.show()

x_test = x_test.reshape(10000,784)

# read .h5 file
import h5py
 

def manual_predict(this_img):
    datafile = "./mnist_nn_quantized_zeroone_FC.h5"
    file = h5py.File(datafile,'r+')

    # read weights of 1st layer 
    weights_L1 = file.get('/binary_dense_2/binary_dense_2/kernel:0')
    weights_L1_darray = np.array(weights_L1)
    # z1 = np.dot(weights_L1_darray.transpose(), x_test[this_img])
    z1 = np.dot(x_test[this_img], weights_L1_darray)
    print("input shape = ",x_test[this_img].shape)
    print("L1 weight shape = ",weights_L1_darray.shape)
    print("z1 shape = ",z1.shape)
    # activation of dense layer 1
    a1 = copy.deepcopy(z1)
    for i in range(len(a1)):
        a1[i] = bi_tanh_activation(a1[i])


    # read weights of 2nd layer 
    weights_L2 = file.get('/binary_dense_4/binary_dense_4/kernel:0')
    weights_L2_darray = np.array(weights_L2)
    # z2 = np.dot(weights_L2_darray.transpose(), a1)
    z2 = np.dot(a1, weights_L2_darray)
    print("a1 shape = ",a1.shape)
    print("L2 weight shape = ",weights_L2_darray.shape)
    print("z2 shape = ",z2.shape)
    # activation of dense layer 2
    a2 = copy.deepcopy(z2)
    for i in range(len(a2)):
        a2[i] = bi_tanh_activation(a2[i])


    # read weights of last layer 512 => 10 
    weights_L3 = file.get('/binary_dense_6/binary_dense_6/kernel:0')
    weights_L3_darray = np.array(weights_L3)
    # z3 = np.dot(weights_L3_darray.transpose(), a2)
    z3 = np.dot(a2, weights_L3_darray)
    print("a2 shape = ",a2.shape)
    print("L3 weight shape = ",weights_L3_darray.shape)
    print("z3 shape = ",z3.shape)
    a3 = copy.deepcopy(z3)
    for i in range(len(a3)):
        a3[i] = bi_tanh_activation(a3[i])
    return a3

print(manual_predict(2))