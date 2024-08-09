#define autoManualSwitch PORTB.RB0
#define manualSwitch PORTB.RB1
#define enableUnits PORTB.RB2
#define enableTens PORTB.RB3
#define westRedLed PORTD.RD0
#define westYellowLed PORTD.RD1
#define westGreenLed PORTD.RD2
#define southRedLed PORTD.RD3
#define southYellowLed PORTD.RD4
#define southGreenLed PORTD.RD5

char current_mode = 0;
char i;

void interrupt() {
    if (INTCON.INTF) {
        Delay_ms(30); // Debounce delay
        INTCON.INTF = 0; // Clear the interrupt flag
        current_mode = (current_mode == 0 ? 1 : 0); // Toggle mode
    }
}

void setCounter(char seconds) {
    char units = seconds % 10;
    char tens = seconds / 10;

    if (seconds == 0) {
        enableUnits = 0;
        enableTens = 0;
    } else {
        enableUnits = (seconds < 10) ? 1 : 1;
        enableTens = (seconds >= 10) ? 1 : 0;
    }
    PORTC = (units & 0x0F) | ((tens & 0x0F) << 4);
}

void main() {
    // Initialize ports
    TRISB = 0x03; // RB0, RB1 as inputs (switches), others as outputs
    TRISC = 0x00; // PORTC as output (7-segment display)
    TRISD = 0x00; // PORTD as output (LEDs)
    PORTC = 0x00; // Clear PORTC
    PORTD = 0x00; // Clear PORTD
    enableUnits = 1;
    enableTens = 1;

    // Configure interrupts
    INTCON.GIE = 1; // Enable global interrupts
    INTCON.INTE = 1; // Enable INT external interrupt
    INTCON.INTF = 0; // Clear the interrupt flag
    OPTION_REG.INTEDG = 1; // Interrupt on rising edge

    while (1) {
        if (!current_mode) { // Automatic mode
            // Reset all LEDs
            southGreenLed = 0;
            southRedLed = 0;
            southYellowLed = 0;
            westGreenLed = 0;
            westYellowLed = 0;
            westRedLed = 1; // West street red light

            // West street green/yellow timing
            for (i = 15; i > 0 && !current_mode; i--) {
                southGreenLed = (i > 3 ? 1 : 0);
                southYellowLed = (i <= 3 ? 1 : 0);
                setCounter(i);
                Delay_ms(1000); // Wait 1 second
            }

            westRedLed = 0;
            southYellowLed = 0;
            southRedLed = 1; // South street red light

            // South street green/yellow timing
            for (i = 23; i > 0 && !current_mode; i--) {
                westGreenLed = (i > 3 ? 1 : 0);
                westYellowLed = (i <= 3 ? 1 : 0);
                setCounter(i);
                Delay_ms(1000); // Wait 1 second
            }
            southRedLed = 0;
            westYellowLed = 0;
        } else { // Manual mode
            if (westRedLed) { // If West street is in red light
                for (i = 3; i > 0 && current_mode; i--) {
                    southYellowLed = 1;
                    southGreenLed = 0;
                    setCounter(i);
                    Delay_ms(1000); // Wait 1 second
                }
                while (current_mode && manualSwitch == 1) {
                    westRedLed = 0;
                    westYellowLed = 0;
                    westGreenLed = 1;
                    southRedLed = 1;
                    southYellowLed = 0;
                    southGreenLed = 0;
                    setCounter(0);
                    Delay_ms(50); // Short delay to reflect manual switch state
                }
            } else { // If West street is in yellow light
                for (i = 3; i > 0 && current_mode; i--) {
                    westYellowLed = 1;
                    westGreenLed = 0;
                    setCounter(i);
                    Delay_ms(1000); // Wait 1 second
                }
                while (current_mode && manualSwitch == 1) {
                    westRedLed = 1;
                    westYellowLed = 0;
                    westGreenLed = 0;
                    southRedLed = 0;
                    southYellowLed = 0;
                    southGreenLed = 1;
                    setCounter(0);
                    Delay_ms(50); // Short delay to reflect manual switch state
                }
            }
        }
    }
}
