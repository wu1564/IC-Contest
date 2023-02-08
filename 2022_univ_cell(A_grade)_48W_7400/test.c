#include <stdio.h>
#define swap(a,b) {int temp=a;a=b;b=temp;} //交換a，b值
void sort(int arr[],int start,int end)//冒泡排序，從start到end的排序，使用時注意是數組的下標，如數組下標0-3排序，sort（arr,0,3）
{
	int i,j;
	for(i=0;i<=end-start;i++)
	{
		for(j=start;j<=end-i-1;j++)
		{
			if(arr[j]>arr[j+1])
				swap(arr[j],arr[j+1]);
		}
	}
}

void permutation(int arr[],int n) //字典排序
{
	int num=1,i=0,j=0,j1=0,k=0,a,b;
	for(i=1;i<=n;i++)//算出需要執行的次數，即全排列的次數，共n！種排法
	{
		num=num*i;
	}
    num = 10;
	sort(arr,0,n-1);//先對數組進行一次按從小到大排列排序
	for(k=num;k>0;k--) //進行num次循環
	{
		for(i=0;i<n;i++) //輸出排好的數組，第一次直接按最小的輸出
		{
			printf("%d",arr[i]);
		}
		printf("\n");
		for(j=n-1;j>0;j--)
		{
			if(arr[j-1]<arr[j]) //這是字典排序的第一步，自己定義的四步法，獲取arr[a]值
			{
				a=j-1;
				break;
			}
		}
		for(j1=n-1;j1>=0;j1--)
		{
			if(arr[j1]>arr[a]) //這是字典排序第二步，獲取arr[b]的值
			{
				b=j1;
				break;
			}
		}
		swap(arr[a],arr[b]); //這是第三步
		sort(arr,a+1,n-1); //這是第四步
	}
}

int main()
{
	int arr[]={0,1,2,3,4,5,6,7};
	permutation(arr,8);
	return 0;
}
