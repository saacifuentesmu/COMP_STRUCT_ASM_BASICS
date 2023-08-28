.section .text
.syntax unified
.thumb
.global main

.equ MEM_LOC, 0x20000200 @ Define a RAM address as MEM_LOC

decrement:
    ldr r0, [r2]         @ Load the value at address in R2 into R0
    subs r0, r0, r1      @ Decrease the value in R0 by R1
    str r0, [r2]         @ Store R0 back into the address in R2
    cmp r0, #0           @ Compare the new value in R0 with 0
    ble loop             @ If the value is less than or equal to 0, jump to 'loop'
    movw r0, #0          @ Clear r0 for next iteration
    add r3, r3, #1       @ Increase the iteration counter
    b decrement

main:
    ldr r0, =#813017     @ Load id into R0
    movw r1, #1017       @ Load date into R1 Less Significant Bits (LSB)

    ldr r2, =MEM_LOC     @ Load memory_location into R2
    str r0, [r2]         @ Store R0 into the address in R2
    movw r3, #0          @ initialize R3 to store the iteration counter

    bl decrement         @ Call the decrement function

    @ End (Infinite loop)
loop:
    b loop               @ Stay in this loop forever
