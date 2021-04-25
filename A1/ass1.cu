#include<iostream>
#include<math.h>

#define n 8

using namespace std;

__global__ void minimum(int *input){
  
  int tid = threadIdx.x;
  int step_size = 1;
  int number_of_threads = blockDim.x;

  cout<<"Number of threads needed are "<<number_of_threads;

  while(number_of_threads > 0){
    if(tid < number_of_threads){
      int first = tid * step_size * 2;
      int second = first + step_size;
      if(input[second] < input[first]){
        input[first] = input[second];
      }
    }
    step_size <<= 1;
    number_of_threads >>= 1;
  }
}

void randintgen(int *arr, int size){
  for(int i=0;i<size;i++){
    arr[i] = rand()%100;
    cout<<arr[i]<<" ";
  }
  cout<<endl;
}

int main(){

  int sizearr = n * sizeof(int);

  int *arr, *arr_d, result;

  arr = (int *)malloc(sizearr);

  randintgen(arr,n);

  cudaMalloc((void **)&arr_d,sizearr);

  cudaMemcpy(arr_d,arr,sizearr,cudaMemcpyHostToDevice);

  minimum<<1,n/2>>(arr_d);

  cudaMemcpy(&result,arr_d,sizeof(int),cudaMemcpyDeviceToHost);

  cout<<"Minimum is "<<result<<endl;
  return 0;
}
