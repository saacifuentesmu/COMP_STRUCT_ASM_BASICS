    .section .text
    .syntax unified
    .thumb
    .global main

    @ Define a RAM address as memory_location
.equ MEM_LOC, 0x20000200

main:
    @ Store 42 in memory
    movw r2, #42           @ Load 42 into R0
    movt r0, #42
    movw r0, #17
    ldr  r1, =MEM_LOC      @ Load high half-word of memory_location into R1
    str  r0, [r1]          @ Store R0 into the address in R1

    @ Load 42 from memory
    ldr  r0, [r1]          @ Load the value at address in R1 into R0

    @ Add 7
    addw r0, r0, #7        @ Add 7 to R0

    @ Store back in memory
    str  r0, [r1]          @ Store R0 back into the address in R1

    @ End (Infinite loop)
loop:
    b loop
