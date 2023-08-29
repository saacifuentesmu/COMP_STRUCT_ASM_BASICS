/*
 * main.s
 *  Created on: Aug 28, 2023
 *      Author: saaci
 */
    .section .text
    .syntax unified
    .thumb
    .global main

/** The LD2 of the NUCLEO is connected to PA5
    Steps to control the Green LED:
    1. Enable the GPIOA Clock
    2. Set the Pin as Output
    3. Set/Reset the bit 5 in the output register
*/

/* The RCC (Reset and Clock Control) is the
   subsystem to Enable/Disable any clock */
.equ RCC_BASE,           0x40021000 @ RM0351 page 79
.equ RCC_AHB2_OFFSET,    0x4C       @ RM0351 page 251
.equ RCC_AHB2_GPIOA,     0x00000001 @ LSB of AHB2 clk enable register


.equ GPIOA_BASE,         0x48000000 @ RM0351 page 78

.equ GPIOA_MODER_OFFSET, 0x00       @ RM0351 page 303
.equ GPIOA_MODER_MASK,   0x03       @ This is to clear the bits
.equ GPIOA_MODER_OUTPUT, 0x01       @ This is to set as output

.equ GPIOA_ODR_OFFSET,   0x14       @ RM0351 page 306
.equ GPIOA_PIN_ODR_MASK, 0x01       @ a single bit per pin

.equ GPIO_PIN_5,         5

main:
	@ Enable the GPIOA Clock
	ldr r6, = RCC_BASE             @ load the RCC address into R6
	ldr r5, [r6, RCC_AHB2_OFFSET]  @ read the current value of the AHB2 CLK enable reg
	orr r5, RCC_AHB2_GPIOA         @ set the bit 0 to enable GPIOA
	str r5, [r6, RCC_AHB2_OFFSET]  @ write the updated value into the AHB2 CLK enable reg

	@ Configure the Pin 5 of GPIOA as output
	ldr r6, = GPIOA_BASE                                  @ load the GPIOA address
	ldr r5, [r6, GPIOA_MODER_OFFSET]                      @ read the current value of MODER
	bic r5, r5, #(GPIOA_MODER_MASK << (GPIO_PIN_5 * 2))   @ clear the bytes for pin 5
	orr r5, r5, #(GPIOA_MODER_OUTPUT << (GPIO_PIN_5 * 2)) @ set the value as output for pin 5
	str r5, [r6, GPIOA_MODER_OFFSET]                      @ write the updated value in MODER

loop:
	@ Toggle Pin 5
	ldr r5, [r6, GPIOA_ODR_OFFSET]              @ read the current value of the output register
	eor r5, #(GPIOA_PIN_ODR_MASK << GPIO_PIN_5) @ change the value of the bit  for pin 5
	str r5, [r6, GPIOA_ODR_OFFSET]              @ write the updated value in the output register

	b loop               @ Stay in this loop forever
