#include <cuda_runtime.h>
#include <iostream>
#include <stdlib.h>
#include <time.h>

__global__ void zhuanshi(int *d_b,int *d_bt,int n)
{
	int ITdx = threadIdx.x;
	int IBdx = blockIdx.x;

	d_bt[ITdx * n + IBdx] = d_b[IBdx * n + ITdx];
}
__global__ void neiji(int *d_a,int *d_bt,int *d_c,int *d_data,int ICTdx,int ICBdx,int n)
{
	/*
	int INTdx = threadIdx.x;
	int i = 2, j = 1;

	d_data[INTdx] = d_a[ICTdx * n + INTdx] * d_bt[ICBdx * n + INTdx];

	__syncthreads();
	while(i <= n)
	{
		if(INTdx % 2 == 0)
		{
			d_data[INTdx] += d_data[INTdx + j];
		}
		i *= 2;
		j *= 2;
	}
	d_c[ICTdx * n + ICBdx] = d_data[0];
*/
}
__global__ void chengfa(int *d_a,int *d_bt,int *d_c,int *d_data,int n)
{
/*
	int ICTdx = threadIdx.x;
	int ICBdx = blockIdx.x;
	neiji<<<1,n>>>(d_a,d_bt,d_c,d_data,ICTdx,ICBdx,n);
	__syncthreads();
*/
}

int main()
{
	int blag = 1;//标志位
	int n = 0;
	/******判断输入数据是否合法************/
	do{
		std::cout << "请输入矩阵的维度:" << std::endl;
		std::cin >> n;
		if(n <= 0)
		{
			std::cout << "你输入的矩阵维度有误,请重新输入!" << std::endl;
		}else{
			blag = 0;
		}
	}while(blag);

	/*******申请主机内存*********/
	int *h_a = (int*)malloc(sizeof(int) * n * n);
	int *h_b = (int*)malloc(sizeof(int) * n * n);
	int *h_c = (int*)malloc(sizeof(int) * n * n);
	int *h_bt = (int*)malloc(sizeof(int) * n * n);
	/*******初始化主机内存数据********/
	srand(time(NULL));//设置随机数值
	for(int i = 0; i < n * n; ++i)
	{
		h_a[i] = rand() % 11;
		h_b[i] = rand() % 11;
		h_c[i] = 0;
		h_bt[i] = 0;
	}

	/*******申请设备内存*******/
	int *d_a,*d_b,*d_c,*d_bt,*d_data;
	cudaMalloc((void**)&d_a,sizeof(int) * n * n);
	cudaMalloc((void**)&d_b,sizeof(int) * n * n);
	cudaMalloc((void**)&d_c,sizeof(int) * n * n);
	cudaMalloc((void**)&d_bt,sizeof(int) * n * n);
	cudaMalloc((void**)&d_data,sizeof(int)*n);

	/******主机内存数据复制到设备内存中************/
	cudaMemcpy(d_a,h_a,sizeof(int) * n * n,cudaMemcpyHostToDevice);
	cudaMemcpy(d_b,h_b,sizeof(int) * n * n,cudaMemcpyHostToDevice);
	std::cout << "测试点" << std::endl;
	/*******执行核函数******/
	zhuanshi<<<n,n>>>(d_b,d_bt,n);
	chengfa<<<n,n>>>(d_a,d_bt,d_c,d_data,n);

	/*****设备内存数据复制到主机内存中*****/
	cudaMemcpy(h_bt,d_bt,sizeof(int) * n * n,cudaMemcpyDeviceToHost);
	cudaMemcpy(h_c,d_c,sizeof(int) * n * n,cudaMemcpyDeviceToHost);

	std::cout << "CPU内存数据h_a:" << std::endl;
	for(int i = 0; i < n; ++i)
	{
		for(int j = 0; j < n; ++j)
		{
			printf("h_a[%d][%d] = %d\t",i,j,h_a[n * i + j]);
		}
		printf("\n");
	}
	std::cout << "CPU内存数据h_b:" << std::endl;
	for(int i = 0; i < n; ++i)
	{
		for(int j = 0; j < n; ++j)
		{
			printf("h_b[%d][%d] = %d\t",i,j,h_b[n * i + j]);
		}
		printf("\n");
	}
	std::cout << "CPU内存数据h_bt:" << std::endl;
	for(int i = 0; i < n; ++i)
	{
		for(int j = 0; j < n; ++j)
		{
			printf("h_bt[%d][%d] = %d\t",i,j,h_bt[n * i + j]);
		}
		printf("\n");
	}
	std::cout << "GPU内存数据:" << std::endl;
	for(int i = 0; i < n; ++i)
	{
		for(int j = 0; j < n; ++j)
		{
			printf("h_c[%d][%d] = %d\t",i,j,h_c[n * i + j]);
		}
		printf("\n");
	}

	/*******释放内存*********/
	free(h_a);
	free(h_b);
	free(h_c);
	cudaFree(d_a);
	cudaFree(d_b);
	cudaFree(d_c);

	std::cout << "运行结束" << std::endl;
	return 0;
}
