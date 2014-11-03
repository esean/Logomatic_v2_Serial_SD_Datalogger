This Folder contains the Sparkfun USB bootloader for the Phillips LPC2148 ARM.  

In order to be properly loaded onto the ARM, several precautions must be taken:

1.) The code is set up to use P0.7 as the chip select line for the SD card.  If
	this is not the case with your design, you must change the definitions in two
	files-

	a.)SD_Raw_Config.h (located inside the SYSTEM folder)
		-If the pin for the SD card chip select is on Port 0, make sure the 
		 #define SS_PORT_0 command is NOT commented out; also make sure that
		 #define SS_PORT_1 IS commented out.  If your pin is one Port 1, do 
		  the opposite.

		-Change the pin number on the SPI_SS_PIN definition to your pin.
		   (i.e. if you put the SD card chip select on pin 24, then the line
			should read #define SPI_SS_PIN 24)

	b.)spi.h (located inside the LPCUSB folder)
		*make the same changes as in SD_Raw_Config.h

	In both of these files, the changes that need to be made are located in 
	the top of the files.

2.) The code is set up to use P0.23 as the Vbus detection input.  If this is not
	the case with your design, you must change several lines in three different
	files in order for this to work-

	a.) main_msc.c (located in the LPCUSB folder)
		-On line 198 of this file, there is a while loop that reads
			while(IOPIN0 & (1<<23)){...}
		As long as your Vbus detect line is on port 0, all that needs to be changed
		is the 23, and this should be changed to whatever pin your detect line is on.

	b.) usbhw_lpc.c (located in the LPCUSB folder)
		-On line 523, P0.23 is defined as an input using a special function.  Here you
		 should also add a line to define your detect line as an input.
			(i.e. if your detect line is on pin 21, add IODIR0 |= (1<<21);)

	c.) main.c (located in the "home" directory)
		-On line 47, there is an if statement checking the state of the detect line, it 
		reads- if(IOPIN0 & (1<<23)); the 23 should be changed to whatever line you're
		using for your detect line.
