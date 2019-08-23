#include <iostream>
#include <cuda_runtime.h>
#include <ctime>
#include <cstdlib>

template<typename T>
__global__ void add(T *d_a,T *d_b,T *d_c,int n)
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
	double * h_a = (double*)malloc(sizeof(double) * n);
	double * h_b = (double*)malloc(sizeof(double) * n);
	double * h_c = (double*)malloc(sizeof(double) * n);
	/******主机内存赋值********/
	srand(time(NULL));
	for(int i = 0; i < n; ++i)
	{
		h_a[i] = rand() % 101 / 10.0;
		h_b[i] = rand() % 101 / 10.0;
	}
	/******申请设备内存**********/
	double *d_a,*d_b,*d_c;
	cudaMalloc((void**)&d_a,sizeof(double) * n);
	cudaMalloc((void**)&d_b,sizeof(double) * n);
	cudaMalloc((void**)&d_c,sizeof(double) * n);

	/******主机内存数据复制到设备内存********/
	cudaMemcpy(d_a,h_a,sizeof(double) * n,cudaMemcpyHostToDevice);
	cudaMemcpy(d_b,h_b,sizeof(double) * n,cudaMemcpyHostToDevice);

	/*****启动核函数********/
	add<double><<<1,n>>>(d_a,d_b,d_c,n);

	/*****设备内存数据复制到主机内存*********/
	cudaMemcpy(h_c,d_c,sizeof(double) * n,cudaMemcpyDeviceToHost);
	for(int i = 0; i < n; ++i)
	{
		std::cout << "h_a[" << i << "] = " << h_a[i] << "  ";
	}
	std::cout << std::endl;	for(int i = 0; i < n; ++i)
	{
		std::cout << "h_b[" << i << "] = " << h_b[i] << "  ";
	}
	std::cout << std::endl;
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
