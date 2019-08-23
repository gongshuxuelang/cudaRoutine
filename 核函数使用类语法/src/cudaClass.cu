#include <cuda_runtime.h>
#include <iostream>

class CUDAdem
{
public:
	__device__ void add(int igdx)
	{
		printf("hello GPU = %d\n",igdx);
	}
};
__global__ void add()
{
	int igdx = threadIdx.x;
	CUDAdem cdmo;
	cdmo.add(igdx);
}
int main()
{

	add<<<1,4>>>();
	cudaDeviceReset();
	printf("hello world!\n");
	return 0;
}
