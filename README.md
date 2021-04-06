# FPGA-digit-recognition
## "Disclaimer"
I'm new in this field and this is my first FPGA project. Please forgive me for my stupid code.
## Version info
Keras: 2.3.1
Tensorflow: 2.1.0
Python: 3.6
## Introduction
Binary Neural Network is a kind of neural network that all weights and activations are set to 1 or -1. It might look unrealiable at the first glance because massive floating number computation and pricy GPU usage is kinda like the landmark architecture of deep learning.
The loss is actually amazingly low according to the scientific research.
Binary Neural Network is suitable for implementing on edge device especially on FPGA due to the trade-off between its limited capacity and the capability of speedy gate-level computation.
I'm giving a simple demo on how we can use relatively cheaper FPGA (i.e. with no embedded ARM processor) to do forward propagation and predict the test set of MNIST handwritten digits.
## Quick start
The basic implementation of this project is:
1. use Keras to train the Binary Neural Network
2. extract the weights matrix
3. program the weights into ROM
4. use UART to send one of the test image into FPGA
5. compute and display the predict on the led nixie tube
## BNN part credits to [Haosam](https://github.com/Haosam/Binary-Neural-Network-Keras)
