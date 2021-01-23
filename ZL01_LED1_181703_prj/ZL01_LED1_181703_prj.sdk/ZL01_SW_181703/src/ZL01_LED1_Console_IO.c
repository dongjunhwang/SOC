#include "xparameters.h"
#include "xgpio.h"
#include "xstatus.h"
#include "xil_printf.h"
#define GPIO_DEVICE_ID XPAR_AXI_GPIO_0_DEVICE_ID
#define LED 0x0
#define LED_CHANNEL 1 // GPIO port for LEDs
XGpio Gpio; // GPIO Device driver instance
int LEDOutputExample(void);
int main(void) { // main function
	int Status;
	xil_printf("Start LED lighting!\r\n");
		Status = LEDOutputExample(); // LED control func.
	if (Status != XST_SUCCESS) {
		xil_printf("GPIO output to the LEDs failed!\r\n");
	}
	xil_printf("Bye!\r\n");
	return 0;
}
int LEDOutputExample(void) {
	int Status, led = LED;
	char8 ch;
	Status = XGpio_Initialize(&Gpio, GPIO_DEVICE_ID);
	if (Status != XST_SUCCESS) { return XST_FAILURE; }
	XGpio_SetDataDirection(&Gpio, LED_CHANNEL, 0x0);
	XGpio_DiscreteWrite(&Gpio, LED_CHANNEL, led); // turn off LED
	while (1) {
		xil_printf("Enter an LED value in hex : " );
			ch = inbyte(); // input a char
		if (ch == 'q') { xil_printf("%c\r\n", ch); break; } // if ��q��, exit
		else if ((0x40 < ch && ch < 0x47) || (0x60 < ch && ch < 0x67) ||
			(0x2f < ch && ch < 0x3a)) { // check if number
			led = (int)(ch > 0x40 ? ((ch & 0xf) + 0x09) : (ch & 0x0f)); // to hex
			xil_printf("%c\r\n", ch);
		}
		else {
			led = 0;
			xil_printf("%c : not a number!\r\n", ch);
		}
		XGpio_DiscreteWrite(&Gpio, LED_CHANNEL, led);
	}
	return XST_SUCCESS;
}