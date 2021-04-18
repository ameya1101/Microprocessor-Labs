# Spirit Level Reaction Time Tester

### Design Project for the course CS/ECE/EEE/INSTR 241 Microprocessor Programming and Interfacing

The task is to design a device used for testing the sobriety of a person.

### Working of the device

- When a Start button is pressed, the device waits for a random time interval (between four and eight seconds) and then begins incrementing LEDs on a bar graph display such that they appear to 'rise' upwards.
- When the user sees the LEDs moving, they press a STOP button as soon as possible — the earlier the button is pressed, the fewer LEDs that are lit.
- The entire bar graph will sweep to the top in 0.4 seconds (with 50ms between LED steps).

### User Interface

- Features two push-buttons — Start and Stop.
- Nine LEDs on a bar graph.
- A seven-segment display that displays the sobriety level of the user.

### Detailed Working

- When the Start button is pressed, a random time delay is generated after which the bottom-most LED lights up.
- After a 50ms time interval, the bottom-most and the next-highest LED both light up. After another 50ms delay, the three bottom LEDs light up. This process continues until either the Stop button is pressed (in which case the LEDs stop rising) or when all the LEDs are lit.
- The program must also check the STOP button just before lighting the bottom LED to ensure the user isn't cheating by holding the STOP button continually. If the user tries to cheat, blink all LEDs several times and simply go back to the start (waiting once again for the START button).
- The sobriety of a person on a scale of 1-5 (1 indicating maximum intoxication) has to be displayed on a seven-segment display.

-----------

### Files Included
1. **G25_Report:** Detailed design report
2. `G25_Hardware_Design.pdf`: Complete hardware design, with components and connections
3. `G25_spirit_level.pdsprj`: Proteus 8 Design Project File
4. `G25_spirit_level.asm`: Source code, implemented in emu8086
5. `G25_spirit_level.bin`: Compiled binary file
6. **G25_Manuals:** Manuals and datasheets of some components used in the design. 