/*
Write a function in C that takes a pointer to an integer array and its size, and then rearranges the array in-place such that all even numbers appear before odd numbers, preserving the original relative order using only pointer arithmetic (no indexing with []).
*/
#include <stdio.h>

void print(int *arr, int size){
    for(int* i=arr;i<arr+size;i++) printf("%d ",*i);
    printf("\n");
}

void rearrange(int *arr,int size){
    int *ptr = arr;
    int *even_ptr = arr;
    for(int i=0;i<size;i++){
        if(*ptr%2==0){
            if(ptr != even_ptr){
                int temp = *ptr;
                *ptr = *even_ptr;
                *even_ptr = temp;
            }
            even_ptr++;
        }
        ptr++;
    }
}

int main() {
    int arr[]={1,9,43,9,22,6,0,1,43,6};
    int size= sizeof(arr)/sizeof(arr[0]);
    printf("Actual Array: ");
    print(arr,size);
    rearrange(arr,size);
    printf("\nRearranged Array: ");
    print(arr,size);
    return 0;
}