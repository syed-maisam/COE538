;*****************************************************************
;* This stationery serves as the framework for a                 *
;* user application (single file, absolute assembly application) *
;* For a more comprehensive program that                         *
;* demonstrates the more advanced functionality of this          *
;* processor, please see the demonstration applications          *
;* located in the examples subdirectory of the                   *
;* Freescale CodeWarrior for the HC12 Program directory          *
;*****************************************************************

; export symbols
            XDEF Entry, _Startup            ; export 'Entry' symbol
            ABSENTRY Entry        ; for absolute assembly: mark this as application entry point



; Include derivative-specific definitions 
		INCLUDE 'derivative.inc' 

ROMStart    EQU  $4000  ; absolute address to place my code/constant data

; variable/data section

 ; Insert here your data definition.

; code section


;************************************************************
;* 5 Second Delay *
;************************************************************
DT_DEMO     EQU 115 ; 5 second delay
            ORG $3850
TOF_COUNTER RMB 1
AT_DEMO     RMB 1

            ORG $4000
            

Entry:
_Startup:
            LDS #$4000
            JSR ENABLE_TOF ; Jump to TOF Subroutine 
            CLI
            LDAA TOF_COUNTER
            ADDA #DT_DEMO
            STAA AT_DEMO
CHK_DELAY   LDAA TOF_COUNTER
            CMPA AT_DEMO
            BEQ STOP_HERE
            NOP ; No operation
            BRA CHK_DELAY ;  check the alarm again
            
STOP_HERE   SWI
;************************************************************
ENABLE_TOF  LDAA #%10000000   ;val 80
            STAA TSCR1 ; Enable TCNT
            STAA TFLG2 ; Clear TOF
            LDAA #%10000100 ; Enable TOI and select factor equal to 16. Val = 84
            STAA TSCR2
            RTS
                     
;************************************************************
TOF_ISR     INC TOF_COUNTER
            LDAA #%10000000; Clear   val 80
            STAA TFLG2 ; TOF
            RTI
            
;************************************************************
DISABLE_TOF LDAA #%00000100 ; Disable TOI and leave  factor at 16. val 4
            STAA TSCR2
            RTS
           
;**************************************************************
;*                 Interrupt Vectors                          *
;**************************************************************
            ORG   $FFFE
            DC.W  Entry           ; Reset Vector
            ORG $FFDE
            DC.W TOF_ISR ; Timer Overflow Interrupt Vector
           
