#include <cuda_runtime.h>
#include <iostream>

__global__ void add(int *d_a,int *d_b,int *d_c,int n)
{
	int idx = threadIdx.x;
	d_c[idx] = d_a[idx] + d_b[idx];
}
int main()
{
	int n = 0;
	int blag = 1;//标志位
	do{
		std::cout << "请输入数组的长度:" << std::endl;
		std::cin >> n;
		if(n <= 0)
		{
			std::cout << "你输入的数组长度为为正数,请重新输入:" << std::endl;
		}else
		{
			blag = 0;
		}
	}while(blag);

	/******申请主机内存******/
	int * h_a = (int*)malloc(sizeof(int) * n);
	int * h_b = (int*)malloc(sizeof(int) * n);
	int * h_c = (int*)malloc(sizeof(int) * n);
	/******主机内存赋值********/
	for(int i = 0; i < n; ++i)
	{
		h_a[i] = i + 1;
		h_b[i] = i + 3;
	}
	/******申请设备内存**********/
	int *d_a,*d_b,*d_c;
	cudaMalloc((void**)&d_a,sizeof(int) * n);
	cudaMalloc((void**)&d_b,sizeof(int) * n);
	cudaMalloc((void**)&d_c,sizeof(int) * n);

	/******主机内存数据复制到设备内存********/
	cudaMemcpy(d_a,h_a,sizeof(int) * n,cudaMemcpyHostToDevice);
	cudaMemcpy(d_b,h_b,sizeof(int) * n,cudaMemcpyHostToDevice);

	/*****启动核函数********/
	add<<<1,n>>>(d_a,d_b,d_c,n);

	/*****设备内存数据复制到主机内存*********/
	cudaMemcpy(h_c,d_c,sizeof(int) * n,cudaMemcpyDeviceToHost);

	for(int i = 0; i < n; ++i)
	{
		std::cout << "h_c[" << i << "] = " << h_c[i] << "  ";
	}
	std::cout << std::endl;
	/*******释放设备内存*****/
	cudaFree(d_a);
	cudaFree(d_b);
	cudaFree(d_c);

	/*****释放主机内存*****/
	free(h_a);
	free(h_b);
	free(h_c);

	std::cout << "运行结束!" << std::endl;
	return 0;
}
