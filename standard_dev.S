	.globl   standard_dev

	/*@Author Jacob is the author of this file. Kinda messy at the moment but it works. */

standard_dev:
	mov x26, x30 //Save the return address for end of program!

	mov x4, #8 //Store 8 for dw size
	mul x5, x1, x4 //Get length of array in doublewords
	add x5, x5, x0 //Save end of array address in to x5

	mov x3, XZR //Initialize x3 (counter) to zero
	mov x2, x0 //Copy array pointer address
	bl mean //Begin finding the mean

	mov x2, x0 //Copy array pointer again
	mov x6, XZR //Init x6
	bl sub_and_square //Get squared differences

mean:
	ldur x4, [x2, #0] //Load array element in to x4

	add x3, x3, x4 //Add array element to counter

	add x2, x2, #8 //Move length of double word to pointer copy (move the pointer copy)
	cmp x2, x5 //Compare addresses
	b.ne mean //If not equal continue looping
	udiv x3, x3, x1 //FINDS THE MEAN

	br x30 //Go back to calling

sub_and_square:
	ldur x4, [x2, #0] //Load array element in to x4

	/*LOOP LOGIC IN NEXT FOUR LINES*/
	sub x4, x4, x3 //Subtract mean from array element
	mul x4, x4, x4 //Square result of subtraction
	stur x4, [x2, #0] //Store the value back in to the array

	add x6, x6, x4 //Add the sum of squared differences
	add x2, x2, #8
	cmp x2, x5 //Compare addresses

	b.ne sub_and_square //If not equal continue summing
	mov v1.S[0], W6
	mov v2.S[0], W1
	fdiv v0.2D, v1.2D, v2.2D //FINDS THE MEAN OF SQUARED DIFFERNCES (AKA Variance) in DW FP

	fsqrt v0.2D, v0.2D
	br x26 //Return from assembly.
