	.globl binary_search
	//@Kelsey is the author of this file. Still needs some work.

binary_search:
	lsr x1, x1, #1 //Right shift once to divide by two
	cmp x1, #1
	b.eq add_one

	mov x9, #0x8 //Move 8 in to x9
	mul x10, x1, x9 //Multiply to find middle index
	add x11, x0, x10 //Add address of beginning of sorted and the middle index, place that in to x11
	ldur x12, [x11, #0] //Load the value at the address in to x12

	cmp x12, x2 //Subtract to find if equal or not
	b.mi greater //If negative then x2 is larger value
	sub sp, sp, #32 //Add distance across arguments + the return value

	stur x0, [SP, #0]
	stur x1, [SP, #8]
	stur x2, [SP, #16]
	stur x30, [SP, #24]

	bl binary_search //Otherwise call again... (BL FOR METHOD CALL)
	b equal_exit

add_one:
	add x1, x1, #1
	br x30

greater:

	mov x0, x11 //Move middle value address in to x0
	sub sp, sp, #32 //Add distance across arguments + the return value
	stur x0, [SP, #0] //Store address of beginning of sorted array
	stur x1, [SP, #8] //Store second arg to stack
	stur x2, [SP, #16] //Store third arg to stack
	stur x30, [SP, #24] //Store return address on stack
	bl binary_search

equal_exit:
	mov x0, x12
	ldur x30, [SP, #24]
	add SP, SP, #32
	br x30

int_dne:
	mov x0, #-1
	ldur x30, [SP, #24]
	add SP, SP, #32
	br x30

