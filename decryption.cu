#include <stdio.h>
#include <math.h>
#include <cuda_runtime.h>
//TODO: BIG INT is needed
__global__ void decyrption(int *M, int *C, int *d, int *N){
    
    int i = threadIdx.x;
    M[i] = pow(M[i], d[i]);
    M[i] = M[i] % N[i];

}

int main(){
    int C[4] = {541, 795, 1479, 2753};
    int M[4];
    int d[4] = {1019, 1019, 1019, 1019};
    int N[4] = {3337, 3337, 3337, 3337};

    int *C_GPU, *M_GPU, *d_GPU, *N_GPU;
    int size = 4 * sizeof(int);

    cudaMalloc((void **)&C_GPU, size);
    cudaMalloc((void **)&M_GPU, size);
    cudaMalloc((void **)&d_GPU, size);
    cudaMalloc((void **)&N_GPU, size);

    cudaMemcpy(C_GPU, C, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_GPU, d, size, cudaMemcpyHostToDevice);
    cudaMemcpy(N_GPU, N, size, cudaMemcpyHostToDevice);

    decyrption<<<1, 4>>>(M_GPU, C_GPU, d_GPU, N_GPU);

    cudaMemcpy(M, M_GPU, size, cudaMemcpyDeviceToHost);
    cudaFree(M_GPU);
    cudaFree(C_GPU);
    cudaFree(d_GPU);
    cudaFree(N_GPU);

    int i;
    for (i = 0; i < 4; i++){
        printf("The result is %d, %d\n", M[i], C[i]);
    }
}