; ==============================================================================
;                          Gate Flash Light 
; ==============================================================================
; This project is because warning flash light of my motorized gate was damaged. 
; New one is above 6000 HUF and need 1-2 week to deliver,
; but this board is only 10€ (4000 HUF today) and available immediately. 
; ==============================================================================
; Hardware: https://github.com/butyi/sci2can/
; Software: https://github.com/butyi/gateflashlight/ 
; ==============================================================================
#include "dz60.inc"
; ===================== CONFIG =================================================

; uC port definitions with line names in schematic
LED2            @pin    PTA,6
FET             @pin    PTD,2   ; Power LED control

; ===================== INCLUDE FILES ==========================================

#include "cop.sub"
#include "mcg.sub"
#include "rtc.sub"

; ====================  VARIABLES  =============================================
#RAM

freeruncnt      ds      1       ; Free running counter. Incremented at each main loop

; ====================  PROGRAM START  =========================================
#ROM

start:
        sei                     ; disable interrupts

        ldhx    #XRAM_END       ; H:X points to SP
        txs                     ; Init SP


        bsr     COP_Init
        bsr     PTX_Init        ; I/O ports initialization
        bsr     MCG_Init
        bsr     RTC_Init
        
        clr     freeruncnt
        bclr    FET.,FET        ; Switch Off FET
        bclr    LED2.,LED2      ; Switch Off status LED
        lda     #1              ; Init A for internal loop
        ldx     #1              ; Init X for external loop

main
        inc     freeruncnt
        ; Check LED2. If 1, put ~25% PWM to FET. If off, FET also off.
        psha
        lda     LED2
        and     #LED2_
        beq     ledoff
        lda     freeruncnt
        and     #$03            ; If masked bits are 
        bne     ledoff          ; not zero, Switch FET off
        bset    FET.,FET        ; If masked bits are zero, Switch FET on (25% On) 
        bra     ledend
ledoff
        bclr    FET.,FET        ; Switch Off FET
ledend
        pula
        
        ; Update watchdog
        bsr     KickCop
        
        ; Internal loop for delay
        dbnza   main
        lda     RTCCNT          ; Read fast free running counter is a random number 
        ora     #$80            ; Set MSB to force longer period

        ; External loop for delay
        dbnzx   main
        ldx     RTCCNT          ; Read fast free running counter is a random number
        
        @Toggle LED2
        
        bra     main
        
; ===================== SUB-ROUTINES ===========================================

; ------------------------------------------------------------------------------
; Parallel Input/Output Control
; To prevent extra current consumption caused by flying not connected input
; ports, all ports shall be configured as output. I have configured ports to
; low level output by default.
; There are only a few exceptions for the used ports, where different
; initialization is needed.
; Default init states are proper for OSCILL_SUPP pins, no exception needed.
PTX_Init
        ; All ports to be low level
        clr     PTA
        clr     PTB
        clr     PTC
        clr     PTE
        clr     PTF
        clr     PTG
        bset    LED2.,LED2      ; LED2 to be On

        ; All ports to be output
        lda     #$FF
        sta     DDRA
        sta     DDRB
        sta     DDRC
        sta     DDRD
        sta     DDRE
        sta     DDRF
        sta     DDRG

        rts


; ===================== IT VECTORS =============================================
#VECTORS
        
        org     Vreset
        dw      start

; ===================== END ====================================================



