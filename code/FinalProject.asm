
_configureINT0:

;FinalProject.c,62 :: 		void configureINT0(){
;FinalProject.c,66 :: 		INTCON.GIE = 1;
	BSF        INTCON+0, 7
;FinalProject.c,70 :: 		INTCON.INTE = 1;
	BSF        INTCON+0, 4
;FinalProject.c,74 :: 		INTCON.INTF = 0;
	BCF        INTCON+0, 1
;FinalProject.c,78 :: 		OPTION_REG.INTEDG = 1;
	BSF        OPTION_REG+0, 6
;FinalProject.c,80 :: 		}
L_end_configureINT0:
	RETURN
; end of _configureINT0

_initialize:

;FinalProject.c,84 :: 		void initialize() {
;FinalProject.c,88 :: 		TRISB = 0x03;
	MOVLW      3
	MOVWF      TRISB+0
;FinalProject.c,92 :: 		TRISC = 0x00;
	CLRF       TRISC+0
;FinalProject.c,96 :: 		TRISD = 0x00;
	CLRF       TRISD+0
;FinalProject.c,100 :: 		PORTC = 0x00;
	CLRF       PORTC+0
;FinalProject.c,104 :: 		PORTD = 0x00;
	CLRF       PORTD+0
;FinalProject.c,107 :: 		UNITS_ENABLE = 1;
	BSF        PORTB+0, 2
;FinalProject.c,108 :: 		TENS_ENABLE = 1;
	BSF        PORTB+0, 3
;FinalProject.c,109 :: 		}
L_end_initialize:
	RETURN
; end of _initialize

_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;FinalProject.c,113 :: 		void interrupt() {
;FinalProject.c,117 :: 		if (INTCON.INTF) {
	BTFSS      INTCON+0, 1
	GOTO       L_interrupt0
;FinalProject.c,118 :: 		Delay_ms(30)  ;
	MOVLW      78
	MOVWF      R12+0
	MOVLW      235
	MOVWF      R13+0
L_interrupt1:
	DECFSZ     R13+0, 1
	GOTO       L_interrupt1
	DECFSZ     R12+0, 1
	GOTO       L_interrupt1
;FinalProject.c,121 :: 		INTCON.INTF = 0;
	BCF        INTCON+0, 1
;FinalProject.c,125 :: 		current_mode = (current_mode == 0?1 :0);
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
;FinalProject.c,127 :: 		}
L_interrupt0:
;FinalProject.c,129 :: 		}
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

_display:

;FinalProject.c,131 :: 		void display(unsigned char seconds) {
;FinalProject.c,133 :: 		unsigned char tens = seconds / 10;
	MOVLW      10
	MOVWF      R4+0
	MOVF       FARG_display_seconds+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVF       R0+0, 0
	MOVWF      display_tens_L0+0
;FinalProject.c,135 :: 		unsigned char units = seconds % 10;
	MOVLW      10
	MOVWF      R4+0
	MOVF       FARG_display_seconds+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      display_units_L0+0
;FinalProject.c,138 :: 		if (seconds == 0 ){
	MOVF       FARG_display_seconds+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_display4
;FinalProject.c,139 :: 		UNITS_ENABLE = 0;
	BCF        PORTB+0, 2
;FinalProject.c,140 :: 		TENS_ENABLE = 0;
	BCF        PORTB+0, 3
;FinalProject.c,141 :: 		} else {
	GOTO       L_display5
L_display4:
;FinalProject.c,142 :: 		if (seconds < 10){
	MOVLW      10
	SUBWF      FARG_display_seconds+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_display6
;FinalProject.c,143 :: 		UNITS_ENABLE = 1;
	BSF        PORTB+0, 2
;FinalProject.c,144 :: 		TENS_ENABLE = 0;
	BCF        PORTB+0, 3
;FinalProject.c,145 :: 		} else {
	GOTO       L_display7
L_display6:
;FinalProject.c,146 :: 		UNITS_ENABLE = 1;
	BSF        PORTB+0, 2
;FinalProject.c,147 :: 		TENS_ENABLE = 1;
	BSF        PORTB+0, 3
;FinalProject.c,148 :: 		}
L_display7:
;FinalProject.c,149 :: 		}
L_display5:
;FinalProject.c,150 :: 		PORTC = (units & 0x0F) | ((tens & 0x0F) << 4);
	MOVLW      15
	ANDWF      display_units_L0+0, 0
	MOVWF      R3+0
	MOVLW      15
	ANDWF      display_tens_L0+0, 0
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
;FinalProject.c,152 :: 		}
L_end_display:
	RETURN
; end of _display

_main:

;FinalProject.c,154 :: 		int main() {
;FinalProject.c,156 :: 		initialize();
	CALL       _initialize+0
;FinalProject.c,158 :: 		configureINT0();
	CALL       _configureINT0+0
;FinalProject.c,160 :: 		while (1) {
L_main8:
;FinalProject.c,164 :: 		if(!current_mode){
	MOVF       _current_mode+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_main10
;FinalProject.c,166 :: 		WEST_RED_LIGHT = 1;
	BSF        PORTD+0, 0
;FinalProject.c,168 :: 		for (i = WEST_RED_TIME; i > 0 && !current_mode; i--) {
	MOVLW      15
	MOVWF      _i+0
L_main11:
	MOVF       _i+0, 0
	SUBLW      0
	BTFSC      STATUS+0, 0
	GOTO       L_main12
	MOVF       _current_mode+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_main12
L__main61:
;FinalProject.c,170 :: 		SOUTH_GREEN_LIGHT = (i > 3 ? 1 : 0);
	MOVF       _i+0, 0
	SUBLW      3
	BTFSC      STATUS+0, 0
	GOTO       L_main16
	MOVLW      1
	MOVWF      ?FLOC___mainT46+0
	GOTO       L_main17
L_main16:
	CLRF       ?FLOC___mainT46+0
L_main17:
	BTFSC      ?FLOC___mainT46+0, 0
	GOTO       L__main68
	BCF        PORTD+0, 5
	GOTO       L__main69
L__main68:
	BSF        PORTD+0, 5
L__main69:
;FinalProject.c,172 :: 		SOUTH_YELLOW_LIGHT = (i <= 3 ? 1 : 0);
	MOVF       _i+0, 0
	SUBLW      3
	BTFSS      STATUS+0, 0
	GOTO       L_main18
	MOVLW      1
	MOVWF      ?FLOC___mainT50+0
	GOTO       L_main19
L_main18:
	CLRF       ?FLOC___mainT50+0
L_main19:
	BTFSC      ?FLOC___mainT50+0, 0
	GOTO       L__main70
	BCF        PORTD+0, 4
	GOTO       L__main71
L__main70:
	BSF        PORTD+0, 4
L__main71:
;FinalProject.c,174 :: 		display(i);
	MOVF       _i+0, 0
	MOVWF      FARG_display_seconds+0
	CALL       _display+0
;FinalProject.c,176 :: 		Delay_ms(1000);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_main20:
	DECFSZ     R13+0, 1
	GOTO       L_main20
	DECFSZ     R12+0, 1
	GOTO       L_main20
	DECFSZ     R11+0, 1
	GOTO       L_main20
	NOP
	NOP
;FinalProject.c,168 :: 		for (i = WEST_RED_TIME; i > 0 && !current_mode; i--) {
	DECF       _i+0, 1
;FinalProject.c,178 :: 		}
	GOTO       L_main11
L_main12:
;FinalProject.c,180 :: 		WEST_RED_LIGHT = 0;
	BCF        PORTD+0, 0
;FinalProject.c,182 :: 		SOUTH_YELLOW_LIGHT = 0;
	BCF        PORTD+0, 4
;FinalProject.c,184 :: 		SOUTH_RED_LIGHT = 1;
	BSF        PORTD+0, 3
;FinalProject.c,186 :: 		for (i = SOUTH_RED_TIME; i > 0 && !current_mode; i--) {
	MOVLW      23
	MOVWF      _i+0
L_main21:
	MOVF       _i+0, 0
	SUBLW      0
	BTFSC      STATUS+0, 0
	GOTO       L_main22
	MOVF       _current_mode+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_main22
L__main60:
;FinalProject.c,188 :: 		WEST_GREEN_LIGHT = (i > 3 ? 1 : 0);
	MOVF       _i+0, 0
	SUBLW      3
	BTFSC      STATUS+0, 0
	GOTO       L_main26
	MOVLW      1
	MOVWF      ?FLOC___mainT64+0
	GOTO       L_main27
L_main26:
	CLRF       ?FLOC___mainT64+0
L_main27:
	BTFSC      ?FLOC___mainT64+0, 0
	GOTO       L__main72
	BCF        PORTD+0, 2
	GOTO       L__main73
L__main72:
	BSF        PORTD+0, 2
L__main73:
;FinalProject.c,190 :: 		WEST_YELLOW_LIGHT = (i <= 3 ? 1 : 0);
	MOVF       _i+0, 0
	SUBLW      3
	BTFSS      STATUS+0, 0
	GOTO       L_main28
	MOVLW      1
	MOVWF      ?FLOC___mainT68+0
	GOTO       L_main29
L_main28:
	CLRF       ?FLOC___mainT68+0
L_main29:
	BTFSC      ?FLOC___mainT68+0, 0
	GOTO       L__main74
	BCF        PORTD+0, 1
	GOTO       L__main75
L__main74:
	BSF        PORTD+0, 1
L__main75:
;FinalProject.c,192 :: 		display(i);
	MOVF       _i+0, 0
	MOVWF      FARG_display_seconds+0
	CALL       _display+0
;FinalProject.c,194 :: 		Delay_ms(1000);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_main30:
	DECFSZ     R13+0, 1
	GOTO       L_main30
	DECFSZ     R12+0, 1
	GOTO       L_main30
	DECFSZ     R11+0, 1
	GOTO       L_main30
	NOP
	NOP
;FinalProject.c,186 :: 		for (i = SOUTH_RED_TIME; i > 0 && !current_mode; i--) {
	DECF       _i+0, 1
;FinalProject.c,196 :: 		}
	GOTO       L_main21
L_main22:
;FinalProject.c,198 :: 		SOUTH_RED_LIGHT = 0;
	BCF        PORTD+0, 3
;FinalProject.c,200 :: 		WEST_YELLOW_LIGHT = 0;
	BCF        PORTD+0, 1
;FinalProject.c,202 :: 		}
	GOTO       L_main31
L_main10:
;FinalProject.c,208 :: 		if (WEST_RED_LIGHT) {
	BTFSS      PORTD+0, 0
	GOTO       L_main32
;FinalProject.c,210 :: 		for(i = SOUTH_YELLOW_TIME; i > 0 && current_mode; i--) {
	MOVLW      3
	MOVWF      _i+0
L_main33:
	MOVF       _i+0, 0
	SUBLW      0
	BTFSC      STATUS+0, 0
	GOTO       L_main34
	MOVF       _current_mode+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main34
L__main59:
;FinalProject.c,212 :: 		SOUTH_YELLOW_LIGHT = 1;
	BSF        PORTD+0, 4
;FinalProject.c,214 :: 		SOUTH_GREEN_LIGHT = 0;
	BCF        PORTD+0, 5
;FinalProject.c,216 :: 		display(i);
	MOVF       _i+0, 0
	MOVWF      FARG_display_seconds+0
	CALL       _display+0
;FinalProject.c,218 :: 		Delay_ms(1000);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_main38:
	DECFSZ     R13+0, 1
	GOTO       L_main38
	DECFSZ     R12+0, 1
	GOTO       L_main38
	DECFSZ     R11+0, 1
	GOTO       L_main38
	NOP
	NOP
;FinalProject.c,210 :: 		for(i = SOUTH_YELLOW_TIME; i > 0 && current_mode; i--) {
	DECF       _i+0, 1
;FinalProject.c,220 :: 		}
	GOTO       L_main33
L_main34:
;FinalProject.c,222 :: 		while(current_mode && MANUAL_SWITCH ==1) {
L_main39:
	MOVF       _current_mode+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main40
	BTFSS      PORTB+0, 1
	GOTO       L_main40
L__main58:
;FinalProject.c,224 :: 		WEST_RED_LIGHT = 0;
	BCF        PORTD+0, 0
;FinalProject.c,226 :: 		WEST_YELLOW_LIGHT = 0;
	BCF        PORTD+0, 1
;FinalProject.c,228 :: 		WEST_GREEN_LIGHT = 1;
	BSF        PORTD+0, 2
;FinalProject.c,230 :: 		SOUTH_RED_LIGHT = 1;
	BSF        PORTD+0, 3
;FinalProject.c,232 :: 		SOUTH_YELLOW_LIGHT = 0;
	BCF        PORTD+0, 4
;FinalProject.c,234 :: 		SOUTH_GREEN_LIGHT = 0;
	BCF        PORTD+0, 5
;FinalProject.c,236 :: 		display(0);
	CLRF       FARG_display_seconds+0
	CALL       _display+0
;FinalProject.c,238 :: 		Delay_ms(50);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_main43:
	DECFSZ     R13+0, 1
	GOTO       L_main43
	DECFSZ     R12+0, 1
	GOTO       L_main43
	NOP
	NOP
;FinalProject.c,240 :: 		}
	GOTO       L_main39
L_main40:
;FinalProject.c,242 :: 		} else {
	GOTO       L_main44
L_main32:
;FinalProject.c,244 :: 		for(i = WEST_YELLOW_TIME; i > 0 && current_mode; i--) {
	MOVLW      3
	MOVWF      _i+0
L_main45:
	MOVF       _i+0, 0
	SUBLW      0
	BTFSC      STATUS+0, 0
	GOTO       L_main46
	MOVF       _current_mode+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main46
L__main57:
;FinalProject.c,246 :: 		WEST_YELLOW_LIGHT = 1;
	BSF        PORTD+0, 1
;FinalProject.c,248 :: 		WEST_GREEN_LIGHT = 0;
	BCF        PORTD+0, 2
;FinalProject.c,250 :: 		display(i);
	MOVF       _i+0, 0
	MOVWF      FARG_display_seconds+0
	CALL       _display+0
;FinalProject.c,252 :: 		Delay_ms(1000);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_main50:
	DECFSZ     R13+0, 1
	GOTO       L_main50
	DECFSZ     R12+0, 1
	GOTO       L_main50
	DECFSZ     R11+0, 1
	GOTO       L_main50
	NOP
	NOP
;FinalProject.c,244 :: 		for(i = WEST_YELLOW_TIME; i > 0 && current_mode; i--) {
	DECF       _i+0, 1
;FinalProject.c,256 :: 		}
	GOTO       L_main45
L_main46:
;FinalProject.c,259 :: 		while(current_mode && MANUAL_SWITCH == 1) {
L_main51:
	MOVF       _current_mode+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main52
	BTFSS      PORTB+0, 1
	GOTO       L_main52
L__main56:
;FinalProject.c,261 :: 		WEST_RED_LIGHT = 1;
	BSF        PORTD+0, 0
;FinalProject.c,263 :: 		WEST_YELLOW_LIGHT = 0;
	BCF        PORTD+0, 1
;FinalProject.c,265 :: 		WEST_GREEN_LIGHT = 0;
	BCF        PORTD+0, 2
;FinalProject.c,267 :: 		SOUTH_RED_LIGHT = 0;
	BCF        PORTD+0, 3
;FinalProject.c,269 :: 		SOUTH_YELLOW_LIGHT = 0;
	BCF        PORTD+0, 4
;FinalProject.c,271 :: 		SOUTH_GREEN_LIGHT = 1;
	BSF        PORTD+0, 5
;FinalProject.c,273 :: 		display(0);
	CLRF       FARG_display_seconds+0
	CALL       _display+0
;FinalProject.c,275 :: 		Delay_ms(50);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_main55:
	DECFSZ     R13+0, 1
	GOTO       L_main55
	DECFSZ     R12+0, 1
	GOTO       L_main55
	NOP
	NOP
;FinalProject.c,277 :: 		}
	GOTO       L_main51
L_main52:
;FinalProject.c,279 :: 		}
L_main44:
;FinalProject.c,281 :: 		}
L_main31:
;FinalProject.c,283 :: 		}
	GOTO       L_main8
;FinalProject.c,285 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
