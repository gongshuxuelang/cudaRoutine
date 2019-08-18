#include <cuda_runtime.h>
#include <iostream>
#include <stdlib.h>
#include <time.h>

__global__ void zhuanzhi(int *d_A,int *d_B,int n)
{
	int ITdx = threadIdx.x;
	int IBdx = blockIdx.x;
	d_B[ITdx * n + IBdx] = d_A[IBdx * n + ITdx];
}
int main()
{
	int blag = 1;//设置标识位
	int n = 0;
	srand(time(NULL));
	/*******判断输入数据是否合法*****/
	do{
		std::cout << "请输入矩阵维度:" << std::endl;
		std::cin >> n;
		if(n <= 0)
		{
			std::cout << "你输入的矩阵维度有误,请重新输入!" << std::endl;
		}else{
			blag = 0;
		}
	}while(blag);

	/******申请主机内存*****/
	int *H_A,*H_B;
	H_A = (int*)malloc(sizeof(int) * n * n);
	H_B = (int*)malloc(sizeof(int) * n * n);

	/*******申请设备内存**************/
	int *d_A,*d_B;

	cudaMalloc((void**)&d_A,sizeof(int) * n * n);
	cudaMalloc((void**)&d_B,sizeof(int) * n * n);

	/****初始化二维数组的数值*******/
	for(int i = 0; i < n * n; ++i)
	{
		H_A[i] = rand() % 11;
		H_B[i] = 0;
	}


	/********主机内存数据复制到设备内存中***********/
	cudaMemcpy(d_A,H_A,sizeof(int) * n * n,cudaMemcpyHostToDevice);

	/*******启动核函数********/
	zhuanzhi<<<n,n>>>(d_A,d_B,n);
	cudaDeviceSynchronize();

	/*******设备内存数据复制到主机内存中*********/
	cudaMemcpy(H_B,d_B,sizeof(int) * n *n,cudaMemcpyDeviceToHost);

	/****打印矩阵和转置矩阵*******/
	std::cout << "CPU 输出" << std::endl;
	for(int i = 0; i < n; ++i)
	{
		for(int j = 0; j < n; ++j)
		{
			std::cout << "H_A[" << i << "][" << j << "] =" << H_A[n * i + j] <<"  ";
		}
		std::cout << std::endl;
	}

	std::cout << "转置结果:" << std::endl;
	for(int i = 0; i < n; ++i)
	{
		for(int j = 0; j < n; ++j)
		{
			std::cout << "H_B[" << i << "][" << j << "] =" << H_B[n * i + j] <<"  ";
		}
		std::cout << std::endl;
	}

	/********释放内存*********/
	free(H_A);
	free(H_B);
	cudaFree(d_A);
	cudaFree(d_B);
	std::cout << "运行结束" << std::endl;
	return 0;
}
