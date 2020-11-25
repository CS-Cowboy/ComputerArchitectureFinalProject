 .globl mean_median_mode
mean_median_mode:
 //first find the mean
  //x0 holds address of sorted array
  //x1 holds the value of the size of the array
  //x2 holds the addres of the destination array
  //x19 - x27 are used for saved values
  //x9 - x15 are used for temporaries
  //x9 will hold the index value i
  //x19 holds the mean
  //x20 holds the median
  //x21 holds the mode
  //first initialize variables
  mov x9, x0 //array accessor stores addresses of array indicies
  mov x11, xzr //loop variable(i)
  b mean_loop
//loop that will add up all the values in the array since the value will become the mean values added will store in x19
mean_loop:
  //find address location of the first element in the array, should be regiester x0
  ldur x10, [x9, #0] // loads the first element in the array into x10
  add x19, x19, x10 //adds the element into x19 (mean variable)    **Sum of all elements is 54
  add x9, x9, #8    //increment variable to match next spot in the array(multiply by 8) 64 bits
  add x11, x11, #1  //increment compare variable(i)
  cmp x11, x1   //compare the increment variable to the size of the array
  b.lt mean_loop   // if the index value is less than the size of the array keep looping
  sdiv x19, x19, x1  //sets value of the mean
  b median
//finds the median, firsts tests to see if the array is even or odd
median:
  //find out if the size of the array is even or odd
  TST X1, #1 //ands X1 value with 1 and tests to see if the result is 1
  B.EQ size_is_even
  B.NE size_is_odd
// have to find the middle two numbers then dived them by two if the size is even
size_is_even:
 mov x14, xzr // moves the value of 0 into register x14
 add x14, x14, #2 //adds to to the register with 0 this will be used to divide middle values by two
 mov x9, x1 // move the size of the array into a temp
 mov x10, x0 //stores base address of the array in x10
 lsr x9, x9, #1 //divides by two
 lsl x9, x9, #3 //multipiles by 8
 add x10, x10, x9 //add base value of the array to this
 ldur x11, [x10, #0] //stores this value as the upper middle value
 ldur x12, [x10, #-8] //stores this value is the lower middle value
 add x13, x11, x12 //adds the middle lower and middle upper value together
 sdiv x20, x13, x14  //divides the addition of middle values by 2 which will be the mean
 b mode
// if the size is odd just return the size of the array divided by 2
size_is_odd:
 mov x9, x1 // move the size of the array into a temp
 mov x10, x0 //stores base address of the array in x10
 lsr x9, x9, #1 //divides by two
 lsl x9, x9, #3 //multipiles by 8
 add x10, x10, x9 //add base value of the array to this
 ldur x20, [x10, #0] //stores this middle value in x20 which is the mean
 b mode
mode:
 mov x23, x30 // moves the link register to here
 mov x9, x1 // moves the size of the array into a temp
 mov x10, x0 // move the base address of the array into x10
 mov x11, xzr // moves the value 0 into x11 this will be the loop counter to iterate the array
 ldur x21, [x10, #0] // if there is no duplicates the mode will be the first element
 mov x12, xzr // this will be used for global count of the highest count
 mov x13, xzr // this be used for the current count
 sub x9, x9, #1 // this will be used as the loop compare
 b mode_loop
mode_loop:
 cmp x11, x9
 b.eq exit
 //access the first element in the array
 ldur x24,[x10, #0] //stores first element in x24
 ldur x25, [x10, #8]
 cmp x24, x25
 b.eq equal_to
 b.lt not_equal
equal_to:
 add x13,x13, #1 //adds 1 to current count
 add x10, x10, #8 //adds 8 to access next index
 add x11, x11, #1 //adds 1 to loop couter
 b mode_loop
not_equal:
 cmp x13, x12
 b.le not_set
 b.gt count_set
not_set:
 mov x13, xzr//set current count to 0
 add x10, x10, #8 //adds 8 to access next index
 add x11, x11, #1 //adds 1 to loop counter
 b mode_loop
count_set:
 mov x12, x13 //moves the current count to global count register
 mov x21, x24 //moves the current number in the array access to 22
 add x11, x11, #1 //adds 1 to loop counter
 b mode_loop
exit:
 //access the array of the temp array and assign the values
 mov x9, x2 //stores the base value of the store array
 stur x19, [x9, #0] // stores the mean in slot 1
 stur x20, [x9, #8] // stores the median in slot 2
 stur x21, [x9, #16] //stores the mode in slot 3
 br x30

