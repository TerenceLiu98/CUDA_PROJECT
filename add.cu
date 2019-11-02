#include <stdio.h>
#include "cuda_runtime.h"

// CUDA Kernel Function 

__global__ void add(int *a, int *b, int *c){
    int i = threadIdx.x;
    c[i] = b[i] + a[i];
}

// main Function

int main(){
    // define A, B, and C
    // These are three array and we will do A + B = C
    int A[5] = {1, 2, 3, 4, 5};
    int B[5] = {7, 8, 10, 18, 20};
    int C[5];
    int C_check[5];

    // define arrays for A, B, and C 
    // and copy these memory from host memory to device memory
    int *A_gpu;
    int *B_gpu;
    int *C_gpu;

    int size = 5 * sizeof(int); 

    // allocate memory for A, B, and C
    cudaMalloc((void **)&A_gpu, size);
    cudaMalloc((void **)&B_gpu, size);
    cudaMalloc((void **)&C_gpu, size);

    // copy the memory
    cudaMemcpy(A_gpu, A, size, cudaMemcpyHostToDevice);
    cudaMemcpy(B_gpu, B, size, cudaMemcpyHostToDevice);

    add<<<1, 5>>>(A_gpu, B_gpu, C_gpu);

    // copy memory from device to host 
    // since the result is stored in C_gpu
    // we just need this memory
    cudaMemcpy(C, C_gpu, size, cudaMemcpyDeviceToHost);



    int i;
    
    for (i = 0; i < 5; i++){
        C_check[i] = A[i] + B[i];
    }
    
    
    for (i = 0; i < 5; i++){
        printf("The Sum is %d\n", C[i] == C_check[i]);
    }

    cudaFree(A_gpu);
    cudaFree(B_gpu);
    cudaFree(C_gpu);

    return 0;
}

// compile with: nvcc -o add add.cu

/* The three important steps of coding in CUDA C:

First, we need to allocate gpu memory and let it ready to get the value;
Then, we copy the variable from cpu into gpu;
After that, we use the kernel function to do the computing;
Lastly, we copy the value(s) we got from gpu to cpu and use this/these value(s).

Basically, not that difficult... (for now)
*/
