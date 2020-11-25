	.globl selection_sort
selection_sort:
	MOV X20, #0			//i(X20) = 0
	MOV X19, X1			//x19 = arraylength
	SUB X24, X19, #1	//x24 = arraylength - 1
forloopi:
	CMP X20, X24		//compare i and arraylength - 1
	B.GE exit			//branch to exit if i >= arraylength - 1
	MOV X22, X20		//index = i
	ADD X21, X20, #1	//j = i + 1
	B forloopj
forloopj:
	CMP X21, X19		//compare j and arraylength
	B.GE forcont		//branch forcont if j >= arraylength
	B if
if:
	LSL X10, X21, #3
	ADD X10, X0, X10
	LDUR X11, [X10, #0]	//load array[j]
	LSL X10, X22, #3
	ADD X10, X0, X10
	LDUR X12, [X10, #0]	//load array[index]
	CMP X11, X12		//compare array[j] and array[index]
	B.GE jplus		 	//branch to forcontinued if greater than
	MOV X22, X21		//index = j
	B jplus
jplus:
	ADD X21, X21, #1	//add 1 to j and continue with for loop
	B forloopj
forcont:
	LSL X15, X22, #3
	ADD X15, X0, X15
	LDUR X12, [X15, #0]	//load array[index]
	MOV X23, X12		//smaller# = array[index]
	LSL X13, X20, #3
	ADD X13, X0, X13
	LDUR X14, [X13, #0]	//load array[i]
	LSL X10, X22, #3
	ADD X10, X0, X10
	STUR X14, [X10, #0]	//store array[i] in array[index]
	LSL X11, X20, #3
	ADD X11, X0, X11
	STUR X23, [X11, #0] // store smaller# in array[i]
	ADD X20, X20, #1	//i++

/*	LDUR X9, [X0, #0]	//check values in array at the end of each iteration
	LDUR X10, [X0, #8]
	LDUR X11, [X0, #16]
	LDUR X12, [X0, #24]
	LDUR X13, [X0, #32]
	LDUR X14, [X0, #40]
	LDUR X15, [X0, #48]
	LDUR X16, [X0, #56]
	LDUR X17, [X0, #64]
	LDUR X18, [X0, #72]*/
	B forloopi
exit:
	MOV X0, #-1		//figure out how to return full array
	br	X30
