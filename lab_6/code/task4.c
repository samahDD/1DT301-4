/*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2016-09-15
; Author:
;    Anas Kwefati
;
; Lab number: 6
; Title: CyberTech Wall Display
;
; Hardware: STK600, CPU ATmega2560
;
; Function: Program that communicates with the terminal and the display.
; It is also possible to enter the address on the screen to display text.
;
; Input ports: Serial Port that is connected to the terminal (PuTTY) takes input from keyboard.
;
; Output ports: CyberTech Display.
;
; Subroutines:
; Included files: <avr/io.h> and <util/delay.h>
;
;Other information: Display is connected to the serial port (RS232) on the STK600.
; Communication speed is 2400bps.
; TASK 5 is the same as TASK 4 but with more address to choose (1-9)
;Changes in program: (Description and date)
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<*/
#include <avr/io.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

#define F_CPU 1000000// Clock Speed
#include <util/delay.h>
#define BAUD 2400 //Communication Speed Display rate 2400
#define MYUBBRR (F_CPU/16/BAUD-1) //UBBRR = 25 -> osc = 1MHz and UBRR = 47 -> osc = 1,843200MHz
#define MAX_LINES 3 // Possible lines TASK4
#define POSSIBLE_DIGIT_TO_CHOOSE_LINE "123" //TASK4

//#define POSSIBLE_DIGIT_TO_CHOOSE_LINE "123456789" //TASK 5
//#define MAX_LINES 9 //TASK 5 and comment the 2 other for TASK 4

void uart_int(void);
void toPutty(unsigned char data);
char getChar();

void improvedtoDisplayOnLCD(char address, char* specialCommand, char* stringChar);
void endToDisplayOnLCD();
void setUpToDisplayOnLCD();

void changeLine (int targetLine);
char possibleCharacter(char* possibleLine, char c);

//SOME GLOBAL VARIABLES
int currentLine = 0;
bool selectionOfLine = false;
char lines[8][24] = { "", "", "", "", "", "", "", "" };//8ROWS 24COLUMNS


int main(void)
{
    uart_int();
    setUpToDisplayOnLCD();
    
    while (1) {
        char character = getChar(); // We get the input from terminal

        //IF SELECT A LINE WE WAIT FOR A VALID DIGIT that is >= 1
        if (selectionOfLine == true) {
            if (character < '1') {
                continue; // If character <1 do nothing
            }
            // We check if the digit that the user has put is in what is possible
            if (possibleCharacter(POSSIBLE_DIGIT_TO_CHOOSE_LINE, character)) {
                int convertCharToInt = character - '1'; //convert char to int
                /*LOGIC behind the conversion :
                 char c = '2';
                 int i = c - '0';
                 it will take the ASCII value of charactter 2 (50) and 0 (48)
                 Then it will substract them -> int i = 50 - 48 which gives us 2
                 */
                changeLine(convertCharToInt); //call the method to choose the possible line. Change currentLine by the targetLine (here "convertCharToInt")
                
                selectionOfLine = false; //False
            }
        }
        else {
            
            if (character == '>'){
                
                selectionOfLine = true; //Make selectionOfLine true
                
            } else if (character == 13 ){
                //Else if character == 'enter'
                changeLine(-1); // We increment currentLine and we go to the next line
                
            } else {
                // Add character to the end of the selected line
                char* line = lines[currentLine];
                
                sprintf(line, "%s%c", line, character);
            }
        }
        setUpToDisplayOnLCD(); // Update the screen
    }

    return 0;
}



//METHOD TO DISPLAY ON THE SCREEN
void improvedtoDisplayOnLCD(char addressLine, char* specialCommand, char* stringChar){
    
    //we get the length of special command which is "O0001"
    //and we get the length of the specific message in stringChar
    int specialCommandLen = strlen(specialCommand);
    int stringCharLen = strlen(stringChar);
    
    char* toDisplay = malloc(1 + specialCommandLen + stringCharLen + 3);//give a length of specialCommand and stringCharLen and allocate a bit more memory with malloc for the end case. We allocate memory for toDisplay

    // ADD EVERYTHING TOGETHER in toDiplsay
    //So we get \rADDRESSLINE_SPECIALCOMMAND_STRINGCHAR
    //For example \rAO0001a"
    sprintf(toDisplay, "\r%c%s%s", addressLine, specialCommand, stringChar);

    
    int checksum = 0;
    // We calculate checksum to make sure that everything is in it
    for (int i = 0; (toDisplay[i] != 0); i++){
        checksum += toDisplay[i];
    }
    
    checksum %= 256;

    sprintf(toDisplay, "%s%02X\n", toDisplay, checksum);//%02x means print at least 2 digits, prepends it with 0's if there's less.
    //%02x is used to convert one character to a hexadecimal string

    for (int i = 0; (toDisplay[i] != 0); i++){
        toPutty(toDisplay[i]);
    }
    

    free(toDisplay); // free toDisplay deallocate the space used by malloc()
}

void endToDisplayOnLCD(){
    char* txt = "\rZD0013C\n";
    for(int i = 0; i<strlen(txt);i++){
        toPutty(txt[i]);
    }
}



//METHOD TO SETUP CHARACTERS FOR EACH LINE
void setUpToDisplayOnLCD(){
    
    //Take currentLine and see if it is <1 if yes then increment lineToDisplay
    int lineToDisplay = currentLine;
    
    if (lineToDisplay < 1){
        lineToDisplay++;
    }
    
    
    //Set up for first and second rows
    char memory_space_A[48] = "";
    
    
    //If selectionOfLine is True then add '_' to choosenLine otherwise the currentLine

    char choosenLine;
    if(selectionOfLine == true){
        choosenLine = '_';
    } else {
        choosenLine = currentLine + '1';
    }

    //Add everything in the array of char.
    sprintf(memory_space_A, "'>' to choose a line:%c  %s", choosenLine, lines[lineToDisplay-1]);

    // Set up for third row
    char memory_space_B[48] = " ";
    if (lines[lineToDisplay][0] == true){
        //check if the selected like is '\0', if yes then do nothing
       
    }
    
    for (int i = 0; i < 48; i++){
        //Send data from third row to the memory
        //memory_space_B[i] = lines[1][i]
        memory_space_B[i] = lines[lineToDisplay][i];
    }
    
    // Send everything to improvedtoDisplayOnLCD to do the calculation with checksum then it will send it to the screen
    improvedtoDisplayOnLCD('A', "O0001", memory_space_A);
    improvedtoDisplayOnLCD('B', "O0001", memory_space_B);
    endToDisplayOnLCD();
}




//METHOD TO CHECK IF THE USER INPUT IS ALLOWED TO CHOOSE LINE
char possibleCharacter(char* possibleLine, char c){
    char tempChar;
    
    //While will continue until the character is \0
    while (*possibleLine){
        tempChar = *possibleLine; //We take char by char from possibleLine and we add it to the char t
        
        if (tempChar == c) {
            //In this condidition, we check if tempChar is equal to the user input c
            return 1; //return 1 if yes
        }
        possibleLine++; //increment possibleLine to go to the next possible char defined by us at the beginning
    }

    return 0; //0 if not
}



// METHOD TO CHOOSE LINE BY INCREMENTS OR NOT
void changeLine (int targetLine){
    
    //if targetLine == -1 then we increase currentLine by 1
    //By default currentLine == 0
    //So if we press 'enter' it will increase currentLine by 1
    //Hence currentLine == 1. And it does this as long as we don't reach the maximum of line possible
    if (targetLine == -1) {
        currentLine++;
        if (currentLine >= MAX_LINES){
            currentLine = 0; //We reset the currentLine to 0 when it exceeds the maximum possible lines.
        }
        
    }
    else {
        // change to selection
        currentLine = targetLine;
    }
}

//INITALIZATION OF THE DISPLAY

void toPutty(unsigned char data){
    //WAIT FOR DATA TO BE RECEIVED and SHOW IT
    while(!(UCSR1A & (1<<UDRE1)));
    UDR1 = data;
}

void uart_int(void) {
    UBRR1L = MYUBBRR; //25 because we are setting the board at 1MHz
    /*Enable receiver and transmitter*/
    UCSR1B = (1<<RXEN1|1<<TXEN1); // Receive Enable (RXEN) bit // Transmit Enable (TXEN) bit
}

char getChar(){
    //WAIT FOR THE CHARACTER TO BE RECEIVED THEN RETURN IT
    while(!(UCSR1A & (1<<RXC1)));
    return UDR1;
}


