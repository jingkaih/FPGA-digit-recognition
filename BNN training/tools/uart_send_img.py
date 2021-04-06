import numpy as np
from keras.datasets import mnist
import matplotlib.pyplot as plt

# There always going to be some bytes get lost while sending through uart using Pyserial.
# I haven't figured it out what was the cause so I'm going to just use software and send the 784 pixels manually
# Any serial port tool would be OK (e.g. Serial Port Utility)
# This code is to generate the 784 bytes that represent the image

def bi_tanh_activation(x):
    if(x >= 0):
        return 1
    else:
        return -1

x_test, y_test = mnist.load_data()[1]
x_test = x_test.astype(int)


index = 9993 # which image you want to predict. Note that index : 0~9999 


plt.imshow(x_test[index] ,cmap=plt.get_cmap('gray'))
plt.title("MNIST test set["+str(index)+"] shows digit "+str(y_test[index]))
plt.show()

this_img_2828 = x_test[index]
this_img_784 = this_img_2828.reshape(784)


# def a2c(arr):
#     c = []
#     for s in arr:
#         c.append(chr(s))
#     return c
# print(a2c(this_img_784))
# def a2c(arr):
#     return ''.join(chr(b) for b in arr)
# print(a2c(this_img_784))
# this_img_784 = this_img_784.tolist()


this_img_784_hex = []
for i in this_img_784:
    this_img_784_hex.append(hex(i))


for i in range(len(this_img_784_hex)):
    if(this_img_784_hex[i] == "0x0"):
        this_img_784_hex[i] = "0x00"
    elif(this_img_784_hex[i] == "0x1"):
        this_img_784_hex[i] = "0x01"
    elif(this_img_784_hex[i] == "0x2"):
        this_img_784_hex[i] = "0x02"
    elif(this_img_784_hex[i] == "0x3"):
        this_img_784_hex[i] = "0x03"
    elif(this_img_784_hex[i] == "0x4"):
        this_img_784_hex[i] = "0x04"
    elif(this_img_784_hex[i] == "0x5"):
        this_img_784_hex[i] = "0x05"
    elif(this_img_784_hex[i] == "0x6"):
        this_img_784_hex[i] = "0x06"
    elif(this_img_784_hex[i] == "0x7"):
        this_img_784_hex[i] = "0x07"
    elif(this_img_784_hex[i] == "0x8"):
        this_img_784_hex[i] = "0x08"
    elif(this_img_784_hex[i] == "0x9"):
        this_img_784_hex[i] = "0x09"
    elif(this_img_784_hex[i] == "0xa"):
        this_img_784_hex[i] = "0x0a"
    elif(this_img_784_hex[i] == "0xb"):
        this_img_784_hex[i] = "0x0b"
    elif(this_img_784_hex[i] == "0xc"):
        this_img_784_hex[i] = "0x0c"
    elif(this_img_784_hex[i] == "0xd"):
        this_img_784_hex[i] = "0x0d"
    elif(this_img_784_hex[i] == "0xe"):
        this_img_784_hex[i] = "0x0e"
    elif(this_img_784_hex[i] == "0xf"):
        this_img_784_hex[i] = "0x0f"



def hex_string_gen(l):
    return "".join(i for i in l)


import re
string = re.sub("0x", " ", hex_string_gen(this_img_784_hex))
print(string)








## pyserial
## might have unexpected outcome


# import serial
# ser = serial.Serial(
#     port='COM3',
#     baudrate=9600
# )
# if ser.isOpen():
#     ser.close()
# ser.open()
# ser.isOpen()
# packet = bytes(this_img_784)
# ser.write(packet)
# ser.close()