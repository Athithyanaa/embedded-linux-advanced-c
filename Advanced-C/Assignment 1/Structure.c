/*
C program that represents a calendar for a week. 
Each day has: 
1. dayName (e.g., "Monday")
2. tasks (array of strings with maximum 3 tasks per day) 
Note: 
1. Define appropriate structures. 
2. Allow the user to input tasks for any day. 
3. Display all tasks grouped by the day.
*/
#include <stdio.h>

#define MAX_DAY 10
#define MAX_TASK 3
#define MAX_LEN 20

typedef struct Days{
    char dayName[MAX_DAY];
    int taskCount;
    char task[MAX_TASK][MAX_LEN];
}Day;

int main() {
    Day week[7]={
        "Monday",0,{},
        "Tuesday",0,{},
        "Wednesday",0,{},
        "Thursday",0,{},
        "Friday",0,{},
        "Saturday",0,{},
        "Sunday",0,{}
    };
    int flag = 1;
    do{
    int n;
    printf("Enter the day no.(1-7): ");
    scanf("%d",&n);
    if(n<1 || n>7){
        printf("Not a valid day\n");
        return 0;
    }
    printf("Congrats! You choosed %s\n",week[n-1].dayName);
    Day *temp = &week[n-1];
    printf("Enter the no.of tasks(max 3): ");
    scanf("%d",&temp->taskCount);
    if(temp->taskCount > 3){
        printf("Max 3 tasks only allowed!\n");
        return 0;
    }
    getchar();
    for(int i=0;i<temp->taskCount;i++){
        printf("Task %d: ",i+1);
        scanf("%s",temp->task[i]);
    }
    printf("\n-----------Weekly Calender-----------\n\n");
    for(int i=0;i<7;i++){
        printf("%d. %s: ",i+1,week[i].dayName);
        if(week[i].taskCount==0) printf("No task scheduled!\n");
        else{
            printf("\n");
            for(int j=0;j<week[i].taskCount;j++){
                printf("%10d.%d. %s\n",i+1,j+1,week[i].task[j]);
            }
        }
    }
    printf("\n--------------------------------------\n");
    printf("\nWish to add more task?(1/0): ");
    scanf("%d",&flag);
    }while(flag);
    return 0;
}