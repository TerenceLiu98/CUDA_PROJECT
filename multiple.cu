/* 
This repo is focus on the Number Theory, 
so I would not introduct matrix multiplication
*/

#include <stdio.h>
#include <cuda_runtime.h>

__global__ void normal_multiplication(int *a, int *b, int *c){
    // for the small case, we only need thread, no block and grid
    int i = threadIdx.x;
    c[i] = a[i] * b[i];
    // printf is not allowed in kernel function
    // printf("%d", c[i])
}

int main(){
    int a[3] = {1, 2, 5};
    int b[3] = {2, 4, 6};
    int c[3]; // int array
    int c_check[3];
    int *A_gpu, *B_gpu, *C_gpu; // pointers
    int size = 5 * sizeof(int);

    // allocate memory for A, B, and C
    cudaMalloc((void **)&A_gpu, size);
    cudaMalloc((void **)&B_gpu, size);
    cudaMalloc((void **)&C_gpu, size);

    // copy the memory
    cudaMemcpy(A_gpu, a, size, cudaMemcpyHostToDevice);
    cudaMemcpy(B_gpu, b, size, cudaMemcpyHostToDevice);

    normal_multiplication<<<1, 3>>>(A_gpu, B_gpu, C_gpu);

    // copy memory from device to host 
    // since the result is stored in C_gpu
    // we just need this memory
    cudaMemcpy(c, C_gpu, size, cudaMemcpyDeviceToHost);



    int i;
    
    for (i = 0; i < 3; i++){
        c_check[i] = a[i] * b[i];
    }
    
    
    for (i = 0; i < 3; i++){
        printf("The Sum is %d\n", c[i] == c_check[i]);
    }

    cudaFree(A_gpu);
    cudaFree(B_gpu);
    cudaFree(C_gpu);

    return 0;
}

