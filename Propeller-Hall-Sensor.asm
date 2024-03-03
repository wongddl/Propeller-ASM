;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Author : 🌟Jan Tan, Jay Villalon, Dante Wong de Lumen, Hugh Segovia, John Ombi-on
; Date : 03/03/2024
; Version: ??
; Difficulty: 4/5
; Title: Propeller Hall Sensor
; 
; Description: Project includes a Propeller with Hall Effect Sensor to project 
; pre-programmed text "GAGANA" once the sensor detects a magnet every rotation.
; Teh gagana?
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#include "p16f84a.inc"

 __CONFIG _FOSC_XT & _WDTE_OFF & _PWRTE_ON & _CP_OFF

    org     0x00    

STATUS	       equ       03h
TRISA          equ       85h
TRISB          equ       86h
PORTA          equ       05h
PORTB          equ       06h
INTCON         equ       0x0B   ;Interrupt Control Register
COUNT1         equ       0x0C   
COUNT2         equ       0x0D
OPTION_REG     equ	     81h

    goto   Main

;********* INTERRUPT ROUTINE **********;
    org     0x04        ;This is where PC points on an interrupt
    bcf     STATUS,5    ;Moving to left bank
    btfss   PORTB,7
    goto    Blue
    goto    Red
    
Red
    call    RED_LEDS
    bcf     INTCON,1    ;Clear interrupt flag to enable more interrupts
    retfie              ;Come out of interrupt routine
    
Blue
    call    BLUE_LEDS
    bcf	    INTCON,1
    retfie

MAIN_PROG CODE

Main
    bsf     INTCON,7    ;GIE- Global Interrupt Enable (1 = enable)
    bsf     INTCON,4    ;INTE- RB0 Interrupt Enable (1 = enable)
    bcf     INTCON,1    ;INTF- Clear Flag Bit


;********** Set Up The Ports *********;
    bsf     STATUS,5	;Bank 1
    movlw   0x81
    movwf   TRISB       ;Sets RB0 and RB7 as Input
    movlw   0x00
    movwf   TRISA       ;All output @ port A
    bcf	    OPTION_REG,7
    bcf     STATUS,5	;Bank 0
    bsf	    PORTB,0

loop
    movlw   0x00
    movwf   PORTB      ;OFF LED infinite loop
    movwf   PORTA
    goto    loop
    
RED_LEDS
    call letterG ;each letter@ has inbetween pixel delays and kerning
    call letterA
    call letterG
    call letterA
    call letterN
    call letterA
    return

BLUE_LEDS
    call letterG_1
    call letterA_1
    call letterG_1
    call letterA_1
    call letterN_1
    call letterA_1
    return

DELAY ;pixel delay
    movlw 0x64
    movwf COUNT1
Loop1   decfsz  COUNT1,1                         ;This second loop keeps the LED
        goto    Loop1                           ;turned off long enough for us to
    return

KERNING 					;Kerning = space between letters, the "<space>" G<space>A<space>G..
    call DELAY
    call DELAY
    return

OFF_LED						;subroutine off
    movlw 0x00
    movwf PORTA
    movwf PORTB
    return

letterG
    movlw 0x7C
    movwf PORTB
    call DELAY
    movlw 0x44
    movwf PORTB
    call DELAY
    movlw 0x54
    movwf PORTB
    call DELAY
    movlw 0x54
    movwf PORTB
    call DELAY
    movlw 0x74
    movwf PORTB
    call DELAY
    call OFF_LED
    call KERNING
    return
    
letterA
    movlw 0x7C
    movwf PORTB
    call DELAY
    movlw 0x14
    movwf PORTB
    call DELAY
    movlw 0x14
    movwf PORTB
    call DELAY
    movlw 0x14
    movwf PORTB
    call DELAY
    movlw 0x7C
    movwf PORTB
    call DELAY
    call OFF_LED
    call KERNING
    return
    
letterN
    movlw 0x7C
    movwf PORTB
    call DELAY
    movlw 0x08
    movwf PORTB
    call DELAY
    movlw 0x10
    movwf PORTB
    call DELAY
    movlw 0x20
    movwf PORTB
    call DELAY
    movlw 0x7C
    movwf PORTB
    call DELAY
    call OFF_LED
    call KERNING
    return
    
letterG_1
    movlw 0x0F
    movwf PORTA
    movlw 0x02
    movwf PORTB
    call DELAY
    movlw 0x08
    movwf PORTA
    call DELAY
    movlw 0x0A
    movwf PORTA
    call DELAY
    movlw 0x0A
    movwf PORTA
    call DELAY
    movlw 0x0E
    movwf PORTA
    call DELAY
    call OFF_LED
    call KERNING
    return
    
letterA_1
    movlw 0x0F
    movwf PORTA
    movlw 0x02
    movwf PORTB
    call DELAY
    movlw 0x02
    movwf PORTA
    call DELAY
    movlw 0x02
    movwf PORTA
    call DELAY
    movlw 0x02
    movwf PORTA
    call DELAY
    movlw 0x0F
    movwf PORTA
    call DELAY
    call OFF_LED
    call KERNING
    return
    
letterN_1
    movlw 0x0F
    movwf PORTA
    movlw 0x02
    movwf PORTB
    call DELAY
    movlw 0x01
    movwf PORTA
    movlw 0x00
    movwf PORTB
    call DELAY
    movlw 0x02
    movwf PORTA
    call DELAY
    movlw 0x04
    movwf PORTA
    call DELAY
    movlw 0x0F
    movwf PORTA
    movlw 0x02
    movwf PORTB
    call DELAY
    call OFF_LED
    call KERNING
    return
    
    END