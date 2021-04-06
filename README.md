# FPGA-digit-recognition
## "Disclaimer"
I'm new in this field and this is my first FPGA project. Please forgive me for my stupid code.
## Version info
Keras: 2.3.1
Tensorflow: 2.1.0
Python: 3.6
## Introduction
Binary Neural Network is a kind of neural network that all weights and activations are set to 1 or -1. It might look unrealiable at the first glance because massive floating number computation and pricy GPU usage is kinda like the landmark architecture of deep learning, but for networks with only 1 and -1? NO WAY!!

However, the loss is actually amazingly low according to the [scientific research](https://www.semanticscholar.org/paper/Binarized-Neural-Networks%3A-Training-Deep-Neural-and-Courbariaux-Hubara/6eecc808d4c74e7d0d7ef6b8a4112c985ced104d?p2df).
Thus Binary Neural Network is suitable for implementing on edge device especially on FPGA due to the trade-off between its limited capacity and the capability of speedy gate-level computation.

I'm giving a simple demo on how we can use relatively cheaper FPGA (i.e. with no embedded ARM processor) to do forward propagation and predict the test set of MNIST handwritten digits.
## Quick start
The basic implementation of this project is:
1. use Keras to train the Binary Neural Network
2. extract the weights matrix
3. program the weights into ROM
4. use UART to send one of the test image into FPGA
5. compute and display the predict on the led nixie tube
## BNN
This part credits to [Haosam](https://github.com/Haosam/Binary-Neural-Network-Keras)

Forward propagation has activation function involved, whereas in backward propagation there's no activation function and its derivatives involved. That simply because the activation function that serves as binarization is non-differentiable. Note that ReLU is also generally non-differentiable, but from the computers perspective it can still compute its derivatives even in the vicinity of 0. That is because the probability that we land exactly in the 0.000000 is very low when doing floating computation.

## Verilog implementation
* To store image, I used a simple dual port BRAM, which has width 28 and depth 32
* To store w1, I used a single port BROM, which has width 784 and depth 512
* To store w2, I used a single port BROM, which has width 512 and depth 512
* To store w3, I used a single port BROM, which has width 512 and depth 10
All of them have read latency 2 clk cycles
![diagram](https://github.com/jingkaih/FPGA-digit-recognition/blob/master/img/diagram.png)
* Also, Pyserial has some unexpected flaws so I was using a uart tool to send the bytes, it should also works for other tools such as Serial Port Utility

## Result
![1](https://github.com/jingkaih/FPGA-digit-recognition/blob/master/img/1.jpg)
![2](https://github.com/jingkaih/FPGA-digit-recognition/blob/master/img/2.jpg)
![3](https://github.com/jingkaih/FPGA-digit-recognition/blob/master/img/3.jpg)
![4](https://github.com/jingkaih/FPGA-digit-recognition/blob/master/img/4.jpg)

## Future works
* optimize the logic and get rid of the big registers such as x[783:0], there's no need of them
* introduce a camera so that it can differentiate and process real time image
