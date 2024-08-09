
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;FinalProject.c,15 :: 		void interrupt() {
;FinalProject.c,16 :: 		if (INTCON.INTF) {
	BTFSS      INTCON+0, 1
	GOTO       L_interrupt0
;FinalProject.c,17 :: 		Delay_ms(30); // Debounce delay
	MOVLW      78
	MOVWF      R12+0
	MOVLW      235
	MOVWF      R13+0
L_interrupt1:
	DECFSZ     R13+0, 1
	GOTO       L_interrupt1
	DECFSZ     R12+0, 1
	GOTO       L_interrupt1
;FinalProject.c,18 :: 		INTCON.INTF = 0; // Clear the interrupt flag
	BCF        INTCON+0, 1
;FinalProject.c,19 :: 		current_mode = (current_mode == 0 ? 1 : 0); // Toggle mode
	MOVF       _current_mode+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt2
	MOVLW      1
	MOVWF      R1+0
	GOTO       L_interrupt3
L_interrupt2:
	CLRF       R1+0
L_interrupt3:
	MOVF       R1+0, 0
	MOVWF      _current_mode+0
;FinalProject.c,20 :: 		}
L_interrupt0:
;FinalProject.c,21 :: 		}
L_end_interrupt:
L__interrupt65:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_setCounter:

;FinalProject.c,23 :: 		void setCounter(char seconds) {
;FinalProject.c,24 :: 		char units = seconds % 10;
	MOVLW      10
	MOVWF      R4+0
	MOVF       FARG_setCounter_seconds+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      setCounter_units_L0+0
;FinalProject.c,25 :: 		char tens = seconds / 10;
	MOVLW      10
	MOVWF      R4+0
	MOVF       FARG_setCounter_seconds+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVF       R0+0, 0
	MOVWF      setCounter_tens_L0+0
;FinalProject.c,27 :: 		if (seconds == 0) {
	MOVF       FARG_setCounter_seconds+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_setCounter4
;FinalProject.c,28 :: 		enableUnits = 0;
	BCF        PORTB+0, 2
;FinalProject.c,29 :: 		enableTens = 0;
	BCF        PORTB+0, 3
;FinalProject.c,30 :: 		} else {
	GOTO       L_setCounter5
L_setCounter4:
;FinalProject.c,31 :: 		enableUnits = (seconds < 10) ? 1 : 1;
	MOVLW      10
	SUBWF      FARG_setCounter_seconds+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_setCounter6
	MOVLW      1
	MOVWF      ?FLOC___setCounterT14+0
	GOTO       L_setCounter7
L_setCounter6:
	MOVLW      1
	MOVWF      ?FLOC___setCounterT14+0
L_setCounter7:
	BTFSC      ?FLOC___setCounterT14+0, 0
	GOTO       L__setCounter67
	BCF        PORTB+0, 2
	GOTO       L__setCounter68
L__setCounter67:
	BSF        PORTB+0, 2
L__setCounter68:
;FinalProject.c,32 :: 		enableTens = (seconds >= 10) ? 1 : 0;
	MOVLW      10
	SUBWF      FARG_setCounter_seconds+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_setCounter8
	MOVLW      1
	MOVWF      ?FLOC___setCounterT18+0
	GOTO       L_setCounter9
L_setCounter8:
	CLRF       ?FLOC___setCounterT18+0
L_setCounter9:
	BTFSC      ?FLOC___setCounterT18+0, 0
	GOTO       L__setCounter69
	BCF        PORTB+0, 3
	GOTO       L__setCounter70
L__setCounter69:
	BSF        PORTB+0, 3
L__setCounter70:
;FinalProject.c,33 :: 		}
L_setCounter5:
;FinalProject.c,34 :: 		PORTC = (units & 0x0F) | ((tens & 0x0F) << 4);
	MOVLW      15
	ANDWF      setCounter_units_L0+0, 0
	MOVWF      R3+0
	MOVLW      15
	ANDWF      setCounter_tens_L0+0, 0
	MOVWF      R2+0
	MOVF       R2+0, 0
	MOVWF      R0+0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	IORWF      R3+0, 0
	MOVWF      PORTC+0
;FinalProject.c,35 :: 		}
L_end_setCounter:
	RETURN
; end of _setCounter

_main:

;FinalProject.c,37 :: 		void main() {
;FinalProject.c,39 :: 		TRISB = 0x03; // RB0, RB1 as inputs (switches), others as outputs
	MOVLW      3
	MOVWF      TRISB+0
;FinalProject.c,40 :: 		TRISC = 0x00; // PORTC as output (7-segment display)
	CLRF       TRISC+0
;FinalProject.c,41 :: 		TRISD = 0x00; // PORTD as output (LEDs)
	CLRF       TRISD+0
;FinalProject.c,42 :: 		PORTC = 0x00; // Clear PORTC
	CLRF       PORTC+0
;FinalProject.c,43 :: 		PORTD = 0x00; // Clear PORTD
	CLRF       PORTD+0
;FinalProject.c,44 :: 		enableUnits = 1;
	BSF        PORTB+0, 2
;FinalProject.c,45 :: 		enableTens = 1;
	BSF        PORTB+0, 3
;FinalProject.c,48 :: 		INTCON.GIE = 1; // Enable global interrupts
	BSF        INTCON+0, 7
;FinalProject.c,49 :: 		INTCON.INTE = 1; // Enable INT external interrupt
	BSF        INTCON+0, 4
;FinalProject.c,50 :: 		INTCON.INTF = 0; // Clear the interrupt flag
	BCF        INTCON+0, 1
;FinalProject.c,51 :: 		OPTION_REG.INTEDG = 1; // Interrupt on rising edge
	BSF        OPTION_REG+0, 6
;FinalProject.c,53 :: 		while (1) {
L_main10:
;FinalProject.c,54 :: 		if (!current_mode) { // Automatic mode
	MOVF       _current_mode+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_main12
;FinalProject.c,56 :: 		southGreenLed = 0;
	BCF        PORTD+0, 5
;FinalProject.c,57 :: 		southRedLed = 0;
	BCF        PORTD+0, 3
;FinalProject.c,58 :: 		southYellowLed = 0;
	BCF        PORTD+0, 4
;FinalProject.c,59 :: 		westGreenLed = 0;
	BCF        PORTD+0, 2
;FinalProject.c,60 :: 		westYellowLed = 0;
	BCF        PORTD+0, 1
;FinalProject.c,61 :: 		westRedLed = 1; // West street red light
	BSF        PORTD+0, 0
;FinalProject.c,64 :: 		for (i = 15; i > 0 && !current_mode; i--) {
	MOVLW      15
	MOVWF      _i+0
L_main13:
	MOVF       _i+0, 0
	SUBLW      0
	BTFSC      STATUS+0, 0
	GOTO       L_main14
	MOVF       _current_mode+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_main14
L__main63:
;FinalProject.c,65 :: 		southGreenLed = (i > 3 ? 1 : 0);
	MOVF       _i+0, 0
	SUBLW      3
	BTFSC      STATUS+0, 0
	GOTO       L_main18
	MOVLW      1
	MOVWF      ?FLOC___mainT55+0
	GOTO       L_main19
L_main18:
	CLRF       ?FLOC___mainT55+0
L_main19:
	BTFSC      ?FLOC___mainT55+0, 0
	GOTO       L__main72
	BCF        PORTD+0, 5
	GOTO       L__main73
L__main72:
	BSF        PORTD+0, 5
L__main73:
;FinalProject.c,66 :: 		southYellowLed = (i <= 3 ? 1 : 0);
	MOVF       _i+0, 0
	SUBLW      3
	BTFSS      STATUS+0, 0
	GOTO       L_main20
	MOVLW      1
	MOVWF      ?FLOC___mainT59+0
	GOTO       L_main21
L_main20:
	CLRF       ?FLOC___mainT59+0
L_main21:
	BTFSC      ?FLOC___mainT59+0, 0
	GOTO       L__main74
	BCF        PORTD+0, 4
	GOTO       L__main75
L__main74:
	BSF        PORTD+0, 4
L__main75:
;FinalProject.c,67 :: 		setCounter(i);
	MOVF       _i+0, 0
	MOVWF      FARG_setCounter_seconds+0
	CALL       _setCounter+0
;FinalProject.c,68 :: 		Delay_ms(1000); // Wait 1 second
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_main22:
	DECFSZ     R13+0, 1
	GOTO       L_main22
	DECFSZ     R12+0, 1
	GOTO       L_main22
	DECFSZ     R11+0, 1
	GOTO       L_main22
	NOP
	NOP
;FinalProject.c,64 :: 		for (i = 15; i > 0 && !current_mode; i--) {
	DECF       _i+0, 1
;FinalProject.c,69 :: 		}
	GOTO       L_main13
L_main14:
;FinalProject.c,71 :: 		westRedLed = 0;
	BCF        PORTD+0, 0
;FinalProject.c,72 :: 		southYellowLed = 0;
	BCF        PORTD+0, 4
;FinalProject.c,73 :: 		southRedLed = 1; // South street red light
	BSF        PORTD+0, 3
;FinalProject.c,76 :: 		for (i = 23; i > 0 && !current_mode; i--) {
	MOVLW      23
	MOVWF      _i+0
L_main23:
	MOVF       _i+0, 0
	SUBLW      0
	BTFSC      STATUS+0, 0
	GOTO       L_main24
	MOVF       _current_mode+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_main24
L__main62:
;FinalProject.c,77 :: 		westGreenLed = (i > 3 ? 1 : 0);
	MOVF       _i+0, 0
	SUBLW      3
	BTFSC      STATUS+0, 0
	GOTO       L_main28
	MOVLW      1
	MOVWF      ?FLOC___mainT73+0
	GOTO       L_main29
L_main28:
	CLRF       ?FLOC___mainT73+0
L_main29:
	BTFSC      ?FLOC___mainT73+0, 0
	GOTO       L__main76
	BCF        PORTD+0, 2
	GOTO       L__main77
L__main76:
	BSF        PORTD+0, 2
L__main77:
;FinalProject.c,78 :: 		westYellowLed = (i <= 3 ? 1 : 0);
	MOVF       _i+0, 0
	SUBLW      3
	BTFSS      STATUS+0, 0
	GOTO       L_main30
	MOVLW      1
	MOVWF      ?FLOC___mainT77+0
	GOTO       L_main31
L_main30:
	CLRF       ?FLOC___mainT77+0
L_main31:
	BTFSC      ?FLOC___mainT77+0, 0
	GOTO       L__main78
	BCF        PORTD+0, 1
	GOTO       L__main79
L__main78:
	BSF        PORTD+0, 1
L__main79:
;FinalProject.c,79 :: 		setCounter(i);
	MOVF       _i+0, 0
	MOVWF      FARG_setCounter_seconds+0
	CALL       _setCounter+0
;FinalProject.c,80 :: 		Delay_ms(1000); // Wait 1 second
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_main32:
	DECFSZ     R13+0, 1
	GOTO       L_main32
	DECFSZ     R12+0, 1
	GOTO       L_main32
	DECFSZ     R11+0, 1
	GOTO       L_main32
	NOP
	NOP
;FinalProject.c,76 :: 		for (i = 23; i > 0 && !current_mode; i--) {
	DECF       _i+0, 1
;FinalProject.c,81 :: 		}
	GOTO       L_main23
L_main24:
;FinalProject.c,82 :: 		southRedLed = 0;
	BCF        PORTD+0, 3
;FinalProject.c,83 :: 		westYellowLed = 0;
	BCF        PORTD+0, 1
;FinalProject.c,84 :: 		} else { // Manual mode
	GOTO       L_main33
L_main12:
;FinalProject.c,85 :: 		if (westRedLed) { // If West street is in red light
	BTFSS      PORTD+0, 0
	GOTO       L_main34
;FinalProject.c,86 :: 		for (i = 3; i > 0 && current_mode; i--) {
	MOVLW      3
	MOVWF      _i+0
L_main35:
	MOVF       _i+0, 0
	SUBLW      0
	BTFSC      STATUS+0, 0
	GOTO       L_main36
	MOVF       _current_mode+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main36
L__main61:
;FinalProject.c,87 :: 		southYellowLed = 1;
	BSF        PORTD+0, 4
;FinalProject.c,88 :: 		southGreenLed = 0;
	BCF        PORTD+0, 5
;FinalProject.c,89 :: 		setCounter(i);
	MOVF       _i+0, 0
	MOVWF      FARG_setCounter_seconds+0
	CALL       _setCounter+0
;FinalProject.c,90 :: 		Delay_ms(1000); // Wait 1 second
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_main40:
	DECFSZ     R13+0, 1
	GOTO       L_main40
	DECFSZ     R12+0, 1
	GOTO       L_main40
	DECFSZ     R11+0, 1
	GOTO       L_main40
	NOP
	NOP
;FinalProject.c,86 :: 		for (i = 3; i > 0 && current_mode; i--) {
	DECF       _i+0, 1
;FinalProject.c,91 :: 		}
	GOTO       L_main35
L_main36:
;FinalProject.c,92 :: 		while (current_mode && manualSwitch == 1) {
L_main41:
	MOVF       _current_mode+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main42
	BTFSS      PORTB+0, 1
	GOTO       L_main42
L__main60:
;FinalProject.c,93 :: 		westRedLed = 0;
	BCF        PORTD+0, 0
;FinalProject.c,94 :: 		westYellowLed = 0;
	BCF        PORTD+0, 1
;FinalProject.c,95 :: 		westGreenLed = 1;
	BSF        PORTD+0, 2
;FinalProject.c,96 :: 		southRedLed = 1;
	BSF        PORTD+0, 3
;FinalProject.c,97 :: 		southYellowLed = 0;
	BCF        PORTD+0, 4
;FinalProject.c,98 :: 		southGreenLed = 0;
	BCF        PORTD+0, 5
;FinalProject.c,99 :: 		setCounter(0);
	CLRF       FARG_setCounter_seconds+0
	CALL       _setCounter+0
;FinalProject.c,100 :: 		Delay_ms(50); // Short delay to reflect manual switch state
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_main45:
	DECFSZ     R13+0, 1
	GOTO       L_main45
	DECFSZ     R12+0, 1
	GOTO       L_main45
	NOP
	NOP
;FinalProject.c,101 :: 		}
	GOTO       L_main41
L_main42:
;FinalProject.c,102 :: 		} else { // If West street is in yellow light
	GOTO       L_main46
L_main34:
;FinalProject.c,103 :: 		for (i = 3; i > 0 && current_mode; i--) {
	MOVLW      3
	MOVWF      _i+0
L_main47:
	MOVF       _i+0, 0
	SUBLW      0
	BTFSC      STATUS+0, 0
	GOTO       L_main48
	MOVF       _current_mode+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main48
L__main59:
;FinalProject.c,104 :: 		westYellowLed = 1;
	BSF        PORTD+0, 1
;FinalProject.c,105 :: 		westGreenLed = 0;
	BCF        PORTD+0, 2
;FinalProject.c,106 :: 		setCounter(i);
	MOVF       _i+0, 0
	MOVWF      FARG_setCounter_seconds+0
	CALL       _setCounter+0
;FinalProject.c,107 :: 		Delay_ms(1000); // Wait 1 second
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_main52:
	DECFSZ     R13+0, 1
	GOTO       L_main52
	DECFSZ     R12+0, 1
	GOTO       L_main52
	DECFSZ     R11+0, 1
	GOTO       L_main52
	NOP
	NOP
;FinalProject.c,103 :: 		for (i = 3; i > 0 && current_mode; i--) {
	DECF       _i+0, 1
;FinalProject.c,108 :: 		}
	GOTO       L_main47
L_main48:
;FinalProject.c,109 :: 		while (current_mode && manualSwitch == 1) {
L_main53:
	MOVF       _current_mode+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main54
	BTFSS      PORTB+0, 1
	GOTO       L_main54
L__main58:
;FinalProject.c,110 :: 		westRedLed = 1;
	BSF        PORTD+0, 0
;FinalProject.c,111 :: 		westYellowLed = 0;
	BCF        PORTD+0, 1
;FinalProject.c,112 :: 		westGreenLed = 0;
	BCF        PORTD+0, 2
;FinalProject.c,113 :: 		southRedLed = 0;
	BCF        PORTD+0, 3
;FinalProject.c,114 :: 		southYellowLed = 0;
	BCF        PORTD+0, 4
;FinalProject.c,115 :: 		southGreenLed = 1;
	BSF        PORTD+0, 5
;FinalProject.c,116 :: 		setCounter(0);
	CLRF       FARG_setCounter_seconds+0
	CALL       _setCounter+0
;FinalProject.c,117 :: 		Delay_ms(50); // Short delay to reflect manual switch state
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_main57:
	DECFSZ     R13+0, 1
	GOTO       L_main57
	DECFSZ     R12+0, 1
	GOTO       L_main57
	NOP
	NOP
;FinalProject.c,118 :: 		}
	GOTO       L_main53
L_main54:
;FinalProject.c,119 :: 		}
L_main46:
;FinalProject.c,120 :: 		}
L_main33:
;FinalProject.c,121 :: 		}
	GOTO       L_main10
;FinalProject.c,122 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
