/*
You are given a 2D matrix of size n x n where each row and each column is sorted in increasing order. Write a C function to determine whether a given key exists in the matrix using the most efficient approach.
*/
#include <stdio.h>

int search_key(int arr[3][4],int r,int c,int k){
    int a=0,b=c-1;
    while(a<r && b>=0){
        if(arr[a][b]==k) return 1;
        else if(k<arr[a][b]) b--;
        else a++;
    }
    return 0;
}

int main() {
    int arr[3][4]={
        {10, 20, 30, 40},
        {15, 25, 35, 45},
        {27, 29, 37, 48},
    };
    int key,row,col;
    row = sizeof(arr)/sizeof(arr[0]);
    col = sizeof(arr[0])/sizeof(arr[0][0]);
    printf("Enter the key: ");
    scanf("%d",&key);
    if(search_key(arr,row,col,key)) printf("Key found");
    else printf("Key doesn't exist");
    
    return 0;
}