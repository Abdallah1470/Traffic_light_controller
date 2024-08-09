#line 1 "D:/final final/code/FinalProject.c"
#line 12 "D:/final final/code/FinalProject.c"
char current_mode = 0;
char i;

void interrupt() {
 if (INTCON.INTF) {
 Delay_ms(30);
 INTCON.INTF = 0;
 current_mode = (current_mode == 0 ? 1 : 0);
 }
}

void setCounter(char seconds) {
 char units = seconds % 10;
 char tens = seconds / 10;

 if (seconds == 0) {
  PORTB.RB2  = 0;
  PORTB.RB3  = 0;
 } else {
  PORTB.RB2  = (seconds < 10) ? 1 : 1;
  PORTB.RB3  = (seconds >= 10) ? 1 : 0;
 }
 PORTC = (units & 0x0F) | ((tens & 0x0F) << 4);
}

void main() {

 TRISB = 0x03;
 TRISC = 0x00;
 TRISD = 0x00;
 PORTC = 0x00;
 PORTD = 0x00;
  PORTB.RB2  = 1;
  PORTB.RB3  = 1;


 INTCON.GIE = 1;
 INTCON.INTE = 1;
 INTCON.INTF = 0;
 OPTION_REG.INTEDG = 1;

 while (1) {
 if (!current_mode) {

  PORTD.RD5  = 0;
  PORTD.RD3  = 0;
  PORTD.RD4  = 0;
  PORTD.RD2  = 0;
  PORTD.RD1  = 0;
  PORTD.RD0  = 1;


 for (i = 15; i > 0 && !current_mode; i--) {
  PORTD.RD5  = (i > 3 ? 1 : 0);
  PORTD.RD4  = (i <= 3 ? 1 : 0);
 setCounter(i);
 Delay_ms(1000);
 }

  PORTD.RD0  = 0;
  PORTD.RD4  = 0;
  PORTD.RD3  = 1;


 for (i = 23; i > 0 && !current_mode; i--) {
  PORTD.RD2  = (i > 3 ? 1 : 0);
  PORTD.RD1  = (i <= 3 ? 1 : 0);
 setCounter(i);
 Delay_ms(1000);
 }
  PORTD.RD3  = 0;
  PORTD.RD1  = 0;
 } else {
 if ( PORTD.RD0 ) {
 for (i = 3; i > 0 && current_mode; i--) {
  PORTD.RD4  = 1;
  PORTD.RD5  = 0;
 setCounter(i);
 Delay_ms(1000);
 }
 while (current_mode &&  PORTB.RB1  == 1) {
  PORTD.RD0  = 0;
  PORTD.RD1  = 0;
  PORTD.RD2  = 1;
  PORTD.RD3  = 1;
  PORTD.RD4  = 0;
  PORTD.RD5  = 0;
 setCounter(0);
 Delay_ms(50);
 }
 } else {
 for (i = 3; i > 0 && current_mode; i--) {
  PORTD.RD1  = 1;
  PORTD.RD2  = 0;
 setCounter(i);
 Delay_ms(1000);
 }
 while (current_mode &&  PORTB.RB1  == 1) {
  PORTD.RD0  = 1;
  PORTD.RD1  = 0;
  PORTD.RD2  = 0;
  PORTD.RD3  = 0;
  PORTD.RD4  = 0;
  PORTD.RD5  = 1;
 setCounter(0);
 Delay_ms(50);
 }
 }
 }
 }
}
