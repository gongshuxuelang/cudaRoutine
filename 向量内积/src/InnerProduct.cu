#include <cuda_runtime.h>
#include <iostream>

__global__ void InnerProduct(int *d_a,int *d_b,int *d_c,int n)
{
	int Idx = threadIdx.x;
	int IdxMax = blockDim.x;
	do{
		d_c[Idx] = d_a[Idx] * d_b[Idx];
		IdxMax += n;
	}while(IdxMax < n);
	d_c[Idx] = d_a[Idx] * d_b[Idx];
	__syncthreads();

	int i = 2, j = 1;
	while(i <= n)
	{
		if(Idx % 2 == 0)
		{
			d_c[Idx] += d_c[Idx + j];
		}
		i *= 2;
		j *= 2;
	}
}
int main()
{
	int blag = 1; //标志位
	int n = 0; //数据大小

	do{
		std::cout << "请输入数据大小:" << std::endl;
		std::cin >> n;
		if(n < 0)
		{
			std::cout << "你输入的数据是错误的,请重新输入!" << std::endl;
		}else
		{
			blag = 0;
		}
	}while(blag);

	/*********申请主机内存*************/
	int *h_a,*h_b,*h_c;
	int nByte = sizeof(int) * n;
	h_a = (int*)malloc(nByte);
	h_b = (int*)malloc(nByte);
	h_c = (int*)malloc(nByte);

	/********申请设备内存 *************/
	int *d_a,*d_b,*d_c;
	cudaMalloc((void**)&d_a,nByte);
	cudaMalloc((void**)&d_b,nByte);
	cudaMalloc((void**)&d_c,nByte);

	/******给主机内存赋值**************/
	for(int i = 0; i < n; ++i)
	{
		h_a[i] = i + 1;
		h_b[i] = i + 3;
	}

	/******主机内存数据复制到设备内存中***/
	cudaMemcpy(d_a,h_a,nByte,cudaMemcpyHostToDevice);
	cudaMemcpy(d_b,h_b,nByte,cudaMemcpyHostToDevice);

	/*****执行核函数*****/
	InnerProduct<<<1,n>>>(d_a,d_b,d_c,n);

	/*******设备数据复制到主机内存**************/
	cudaMemcpy(h_c,d_c,nByte,cudaMemcpyDeviceToHost);

	/**********输出结果***********/

	std::cout << "h_c = " << h_c[0] << std::endl;

	/******释放内存*****/
	free(h_a);
	free(h_b);
	free(h_c);
	cudaFree(d_a);
	cudaFree(d_b);
	cudaFree(d_c);
	std::cout << "运行完毕!" << std::endl;
	return 0;
}
