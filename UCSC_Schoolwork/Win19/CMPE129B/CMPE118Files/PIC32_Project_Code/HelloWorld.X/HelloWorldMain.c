/*
 * File:   HelloWorldMain.c
 * Author: secomd
 *
 * Created on January 23, 2019, 2:17 PM
 */


#include "xc.h"
#include <BOARD.h>
#include <stdio.h>
#include <string.h>

void delay();

int main(void) {
    BOARD_Init();
    char message[20] = "helloworld!\n";
    
    while (strcmp("hello board", message) != 0)
    {
        fgets(message, 20, stdin);  //read message from USB stdin
        printf("%s\n", message);    //print message back to stdout
        delay();                    //wait 

    }
    while(1)
    {
        printf("Hello World!\n");
        delay();
        printf("\n");
        delay();
        printf("Goodbye!\n");
    }
    
    return 0;
}
        

// delay function is tuned to allow the PIC32 sufficient time to send
// all characters in a message. If multiple printf()s are sent too close
// together, characters end up not being sent.
void delay()
{
    int i;
    for(i = 0; i<=(2000000); i++)
    {
        ;
        //printf("\n%i \n", i);
    }
}

