#include <iostream>
#include <cuda_runtime.h>
#include <stdlib.h>
#include <time.h>
__global__ void neiji(int *d_a,int *d_b,int *d_c,int *d_data,int n, int m,int IJdx)
{
	int temp = 0;
	int INdx = threadIdx.x;
	d_data[IJdx * m + INdx] = d_a[IJdx + INdx] * d_b[INdx];
	__syncthreads();
	for(int i = 0; i < m; ++i)
	{
		temp += d_data[IJdx * m + i];
	}
	d_c[IJdx] = temp;
}
__global__ void juanji(int *d_a,int *d_b,int *d_c,int *d_data,int n, int m)
{
	int IJdx = threadIdx.x;
	neiji<<<1,m>>>(d_a,d_b,d_c,d_data,n,m,IJdx);
	__syncthreads();
}
int main()
{
	int blag = 1;
	int m = 0, n = 0;
	do{
		std::cout << "请输入一位向量的长度:"<< std::endl;
		std::cin >> n;
		std::cout << "请输入卷积因子长度:" <<std::endl;
		std::cin >> m;
		if(m > n)
		{
			std::cout << "你输入的数据不合法，请重新输入！"<< std::endl;
		}else{
			blag = 0;
		}
	}while(blag);
	/*****申请主机内存*******/
	int *h_a,*h_b,*h_c;
	h_a = (int*)malloc(sizeof(int) * n);
	h_b = (int*)malloc(sizeof(int) * m);
	h_c = (int*)malloc(sizeof(int) * (n - m + 1));
	/******生成随机数据*******/
	srand(time(NULL));
	for(int i = 0; i < n; ++i)
	{
		h_a[i] = rand() % 11;
		printf("h_a[%d] = %d\t",i,h_a[i]);
	}
	printf("\n");
	for(int i = 0; i < m; ++i)
	{
		h_b[i] = rand() % 11;
		printf("h_b[%d] = %d\t",i,h_b[i]);
	}
	printf("\n");

	/******申请设备内存*************/
	int *d_a,*d_b,*d_c,*d_data;
	cudaMalloc((void**)&d_a,sizeof(int) * n);
	cudaMalloc((void**)&d_b,sizeof(int) * m);
	cudaMalloc((void**)&d_c,sizeof(int) * (n - m + 1));
	cudaMalloc((void**)&d_data,sizeof(int) * m * (n - m + 1));
	/******主机内存数据复制到设备内存中********/
	cudaMemcpy(d_a,h_a,sizeof(int) * n,cudaMemcpyHostToDevice);
	cudaMemcpy(d_b,h_b,sizeof(int) * m,cudaMemcpyHostToDevice);

	/*******启动核函数*******/
	juanji<<<1,n - m + 1>>>(d_a,d_b,d_c,d_data,n,m);

	/*******设备内存数据复制到主机内存中********/
	cudaMemcpy(h_c,d_c,sizeof(int) * (n - m + 1),cudaMemcpyDeviceToHost);

	for(int i = 0; i < n - m + 1; ++i)
	{
		printf("h_c[%d] = %d\t",i,h_c[i]);
	}
	printf("\n");

	/********释放内存********/
	free(h_a);
	free(h_b);
	free(h_c);
	cudaFree(d_a);
	cudaFree(d_b);
	cudaFree(d_c);
	std::cout << "运行结束" << std::endl;
	return 0;
}
