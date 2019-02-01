// source https://www.computer-graphics.se/hello-world-for-cuda.html
// This is the REAL "hello world" for CUDA!
// It takes the string "Hello ", prints it, then passes it to CUDA
// with an array of offsets. Then the offsets are added in parallel
// to produce the string "World!"
// By Ingemar Ragnemalm 2010

// nvcc hello-world.cu -L /usr/local/cuda/lib -lcudart -o hello-world
#include <cuda.h>
#include <cuda_runtime.h>

#include <stdio.h>
#include <unistd.h>

const int N = 16; 
const int blocksize = 16; 

__global__ 
void hello(char *a, int *b) 
{
	int idx = threadIdx.x; // + 6;
	if (idx < N)
		a[idx] = a[threadIdx.x] + b[threadIdx.x];
}

void exitWithFailure(cudaError err, int line) 
{
	printf("Error %d at line %d\n", err, line);
	exit(1);
}

int main()
{
	char a[N] = "Hello \0\0\0\0\0\0";
	int b[N] = {15, 10, 6, 0, -11, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};

	char *ad;
	int *bd;
	const int csize = N*sizeof(char);
	const int isize = N*sizeof(int);

	printf("%s", a);
	cudaError err;

	err = cudaMalloc( (void**)&ad, csize ); 
	if (err != cudaSuccess) exitWithFailure(err, __LINE__);
	err = cudaMalloc( (void**)&bd, isize ); 
	if (err != cudaSuccess) exitWithFailure(err, __LINE__);
	err = cudaMemcpy( ad, a, csize, cudaMemcpyHostToDevice ); 
	if (err != cudaSuccess) exitWithFailure(err, __LINE__);
	err = cudaMemcpy( bd, b, isize, cudaMemcpyHostToDevice ); 
	
	dim3 dimBlock( blocksize, 1 );
	dim3 dimGrid( 1, 1 );
	hello<<<dimGrid, dimBlock>>>(ad, bd);
	if (err != cudaSuccess) exitWithFailure(err, __LINE__);
	err = cudaMemcpy( a, ad, csize, cudaMemcpyDeviceToHost ); 
	if (err != cudaSuccess) exitWithFailure(err, __LINE__);
	err = cudaFree( ad );
	if (err != cudaSuccess) exitWithFailure(err, __LINE__);
	err = cudaFree( bd );
	
	printf("%s\n", a);
	return EXIT_SUCCESS;
}
