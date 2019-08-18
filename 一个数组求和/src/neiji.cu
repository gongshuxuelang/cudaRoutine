#include <cuda_runtime.h>
#include <iostream>
#include <stdlib.h>
#include <time.h>

__global__ void add(int * d_a,int *d_b,int n)
{
	int idx = threadIdx.x;
	int i = 2,j = 1;

	do{
		if(idx % i == 0)
		d_a[idx] += d_a[idx + j];
		i *= 2;
		j *= 2;
	}while(n/=2);
	d_b[0] = d_a[0];

}
int main()
{
	int blag = 1;
	int n = 0;
	do{
		std::cout << "请输入数据长度:" << std::endl;
		std::cin >> n;
		if(n <= 0)
		{
			std::cout << "你输入的数据长度不合法,请重新输入!" << std::endl;
		}else{
			blag = 0;
		}
	}while(blag);

	srand(time(NULL));

	int *h_a = (int*)malloc(sizeof(int) * n);
	int *h_b = (int*)malloc(sizeof(int));
	for(int i = 0; i < n; ++i)
	{
		h_a[i] = rand() % 11;
		printf("h_a[%d] = %d\t",i,h_a[i]);
	}
	printf("\n");

	int *d_a = NULL;
	int *d_b = NULL;
	cudaMalloc((void**)&d_a,sizeof(int) * n);
	cudaMalloc((void**)&d_b,sizeof(int));

	cudaMemcpy(d_a,h_a,sizeof(int) * n,cudaMemcpyHostToDevice);

	add<<<1,n>>>(d_a,d_b,n);
	cudaMemcpy(h_b,d_b,sizeof(int),cudaMemcpyDeviceToHost);

	printf("h_b = %d\n",*h_b);

	free(h_a);
	free(h_b);
	cudaFree(d_a);
	cudaFree(d_b);

	printf("运行结束!\n");
	return 0;
}
