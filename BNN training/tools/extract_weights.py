import numpy as np
import h5py
# This is to generate .COE file that store our weights matrices.
# COE file will be used for initialization of Xilinx ROM IP core

datafile = "./mnist_nn_quantized_zeroone_FC.h5"
file = h5py.File(datafile,'r+')


# read weights of 1st layer 784 => 512
weights_L1 = file.get('/binary_dense_2/binary_dense_2/kernel:0')
weights_L1_darray = np.array(weights_L1)
# read weights of 2nd layer 512 => 512
weights_L2 = file.get('/binary_dense_4/binary_dense_4/kernel:0')
weights_L2_darray = np.array(weights_L2)
# read weights of last layer 512 => 10 
weights_L3 = file.get('/binary_dense_6/binary_dense_6/kernel:0')
weights_L3_darray = np.array(weights_L3)



# process W1 matrix, transpose and make all -1 0
weights_L1_darray_t = weights_L1_darray.transpose()
for i in range(len(weights_L1_darray_t)):
    for j in range(len(weights_L1_darray_t[0])):
        if(weights_L1_darray_t[i][j] == -1):
            weights_L1_darray_t[i][j] = 0
weights_L1_darray_t = weights_L1_darray_t.astype("int")


weights_L2_darray_t = weights_L2_darray.transpose()
for i in range(len(weights_L2_darray_t)):
    for j in range(len(weights_L2_darray_t[0])):
        if(weights_L2_darray_t[i][j] == -1):
            weights_L2_darray_t[i][j] = 0
weights_L2_darray_t = weights_L2_darray_t.astype("int")


weights_L3_darray_t = weights_L3_darray.transpose()
for i in range(len(weights_L3_darray_t)):
    for j in range(len(weights_L3_darray_t[0])):
        if(weights_L3_darray_t[i][j] == -1):
            weights_L3_darray_t[i][j] = 0
weights_L3_darray_t = weights_L3_darray_t.astype("int")

print(weights_L1_darray_t.shape)
print(weights_L2_darray_t.shape)
print(weights_L3_darray_t.shape)

def gen_COE_weights_transpose(path,data):
    with open(path, 'w') as f:
        f.write("memory_initialization_radix=2;\n")
        f.write("memory_initialization_vector=\n")
        for row in data:
            np.savetxt(f,row,fmt="%d",delimiter="",newline='')
            f.write(';\n')
        f.close()

gen_COE_weights_transpose('./w1.coe', weights_L1_darray_t)
gen_COE_weights_transpose('./w2.coe', weights_L2_darray_t)
gen_COE_weights_transpose('./w3.coe', weights_L3_darray_t)