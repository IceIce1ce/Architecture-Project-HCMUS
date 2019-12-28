.data

str1:		.asciiz "\n"
str4:  		.asciiz "\nArray: "
str5:  		.asciiz	" "
OutputFile:	.asciiz "C:/Users/Tran Huy Vu/Desktop/18127070_18127257/output_sort.txt"
InputFile:	.asciiz	"C:/Users/Tran Huy Vu/Desktop/18127070_18127257/input_sort.txt"
File: 		.space	1024	

Array: 		.word	0:1000			#1000 Phan tu
N:		.word	1			#1 phan tu

.text
# a0: Name File, a1: Dia chi mang, a2: So luong phan tu
main:					
jal LoadData
j quickSort

LoadData:
li $v0, 13				#Open File
la $a0, InputFile
li $a1, 0				
syscall 
move $s0, $v0				#Copy mo ta file
li $v0, 14				#Read file 
move $a0, $s0				#Copy mo ta file
la $a1, File				#Address nhan
la $a2, 1024				#Length Address nhan
syscall
li $v0, 16				#Close file
move $a0, $s0				#Copy address mo ta 
syscall
li $t1, 10				#bien tang hang don vi
li $s1, 0				#s1 bien nhan N
la $a1, File				#bien giu dia chi
Read_n:
lb $t2, ($a1)
addi $a1, $a1, 1
beq $t2, 13, SaveN			#s0 = Max
subi $t2, $t2, 48
mul $s1, $s1, $t1
add $s1, $s1, $t2
j Read_n
SaveN:
addi $a1, $a1, 1
la $a2, N
sw $s1, ($a2)
ReadArray:
la $a2, N
lw $s1, ($a2)				#s1 = N		a1 van la bien giu~ file
la $a2, Array				#a2 = Array
li $s2, 0				#s2 bien nhan Phan tu
li $t1, 10				#bien tang hang don vi
li $t0, 0				#bien dem
ReadElement:
beq $t0, $s1, OutFunction		#s0 = N stop
lb $t2, ($a1)
addi $a1, $a1, 1
beq $t2, 32, SaveElement		#neu gap 32 (khoang trong) thi luu lai
beq $t2, 0, SaveElementNExit		#neu gap ma 0 thi dung ham
subi $t2, $t2, 48
mul $s2, $s2, $t1
add $s2, $s2, $t2
j ReadElement

SaveElement:
sw $s2, ($a2)
addi $a2, $a2, 4
li $s2, 0
addi $t0, $t0, 1
j ReadElement

SaveElementNExit:
sw $s2, ($a2)
jr $ra


OutFunction:				#thoat ham
jr $ra

quickSort:
#quickSort
la	$a0, Array
la	$t7, N
lw	$s0, ($t7)
li	$a1, 0 		# low
addi 	$a2, $s0, -1 	# high
jal quicksort
j WriteFile

#write file
#restore
li	$t1, 0		# t1 : bien dem
la	$t0, Array	# t0: dia chi mang
la	$t7, N
lw	$s0, ($t7)
j	WriteFile

#exit program
j ExitProgram

#ghi ra file
WriteFile:
	li $v0, 9  	#tao 1 buffer moi
	li $a0 , 256 	#64 byte
	syscall
	move $s1, $v0 	#save address of string

    
    # addi  $sp, $sp,-4
    # sw $ra, ($sp)
	jal resetFile
    

	jal OpenFile 
	jal saveBuffer
	returnSaveBuffer:

	jal saveFile

	jal CloseFile

    li 	$v0, 10 		#cham dut chuong trinh chay
    syscall 




OpenFile:
	li   $v0, 13       		# system call for open file
	la   $a0, OutputFile 		# mo file
	li   $a1, 9        		# mo de doc, 0 la doc, 1 la ghi
	li   $a2, 0        		# mode is ignored
	syscall            		# open a file (file descriptor returned in $v0)
	move $s7, $v0
jr $ra

resetFile:
li   $v0, 13       			# system call for open file
	la   $a0, OutputFile     	# mo file
	li   $a1, 1        		# mo de doc, 0 la doc, 1 la ghi
	li   $a2, 0       		# mode is ignored
	syscall            		# open a file (file descriptor returned in $v0)
	move $s7, $v0
	addi $sp,$sp,-4
	sw $ra ,0($sp)
	jal CloseFile

	lw $ra ,0($sp)
	addi $sp,$sp,4
jr $ra

CloseFile:
	li  $v0, 16       # system call for close file
	move $a0, $s7     # file descriptor to close
	syscall           # close file
jr $ra

saveFile:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	addi $t1, $t1, -1
	addi $s1, $s1, 1
	loopsave:
	li $v0, 15
	move $a0, $s7
	addi $t1, $t1, -1
	move $a1, $t1
	li $a2, 1  # so phan tu ghi vao file
	syscall
	bgt $t1, $s1, loopsave

	lw $ra, 0($sp)
	addi $sp, $sp, 4
jr $ra




saveBuffer:
	la $t0, Array  # t0 address of input buffer
	la $t6, Array
	li $t7, 32

    sll $t1, $s0, 2 #t1 * 4

	add $t0, $t0, $t1

	move $t1, $s1		#s1 address of output buffer || t1 = cur of s1

	nextInt:
	addi $t0, $t0, -4 #last element of string
	lw $t5, ($t0)

	sb $t7, ($t1) #add spacebar
	addi $t1, $t1, 1 # t1++
	blt $t0, $t6, returnSaveBuffer
	loopSaveBuffer:

		j getDiv
		doneGetDiv:

		addi $t4, $t4, 48  #change remainder int to char
		sb $t4, ($t1)  #save remainder to string t1

		addi $t1,$t1,1 #t1++

		beqz $t3 nextInt #quotient=0 --->next element pf array


	j loopSaveBuffer




#s5=10
getDiv:
div $t5, $t5, 10  #t5/10
mfhi $t4 #remainder
mflo $t3 #quotient
move $t5, $t3 #t5=t5/10
j doneGetDiv
		



#void quickSort( uint32_t a[], int l, int r) 

quicksort:
	addi $sp,$sp,-20    	# allocate space for saving registers in the stack
	sw $ra,0($sp)      	# save return address register in the stack
	sw $s0,4($sp)       	# save $s0 register in the stack
	sw $s1,8($sp)       	# save $s1 register in the stack
	sw $s2,12($sp)      	# save $s2 register in the stack
	sw $s3,16($sp)      	# save $s3 register in the stack

	bge $a1,$a2,endif1          #   if( l < r )

# {

# // divide and conquer

	move $s0,$a0                # save value of $a0
	move $s1,$a1                # save value of $a1
	move $s2,$a2                # save value of $a2

	jal partition               # j = partition( a, l, r);

	move $s3,$v0                # save return value in $s3 (j)
	move $a0,$s0                # load saved value of $a0
	move $a1,$s1                # load saved value of $a1
	addi $a2,$s3,-1             # load value of j-1

	jal  quicksort              # quickSort( a, l, j-1);

	move $a0,$s0                # load saved value of $a0
	addi $a1,$s3,1              # load value of j+1
	move $a2,$s2                # load saved value of $a2

	jal  quicksort              # quickSort( a, j+1, r);

endif1:                         # }

	lw $ra,0($sp)       # restore contents of $ra from the stack
	lw $s0,4($sp)       # restore $s0 register from the stack
	lw $s1,8($sp)       # restore $s1 register from the stack
	lw $s2,12($sp)      # restore $s2 register from the stack
	lw $s3,16($sp)      # restore $s3 register from the stack
	addi $sp,$sp,20     # restore stack pointer

	jr $ra

#————————————————–

# int partition(uint32_t a[], int l, int r) {


partition:

	addi $sp,$sp,-16    # allocate space for saving registers in the stack
	sw $ra,0($sp)       # save return address register in the stack
	sw $s0,4($sp)       # save $s0 register in the stack
	sw $s1,8($sp)       # save $s1 register in the stack
	sw $s2,12($sp)      # save $s2 register in the stack
	sll $t4,$a1,2       # multiply l by 4 to get offset in array
	add $t4,$t4,$a0     # get address of a[l] in t4
	lw  $s0,($t4)       # pivot = a[l]; $s0 will be pivot
	move $s1,$a1        # i = l;  $s1 will be i
	addi $s2,$a2,1      # j = r+1;  $s2 will be j

while1:                 # while( 1)

# {

do1:                    # do

	addi $s1,$s1,1      #   ++i;
	sll $t1,$s1,2       # multiply i by 4 to get offset in array
	add $t1,$t1,$a0     # get address of a[i] in t1
	lw  $t0,($t1)       # $t0 = a[i]
	bgt $t0,$s0,do2     # while( a[i] <= pivot && i <= r );
	bgt $s1,$a2,do2

	j   do1

do2:                    # do

	addi $s2,$s2,-1     # –j;
	sll $t2,$s2,2       # multiply j by 4 to get offset in array
	add $t2,$t2,$a0     # get address of a[j] in t2
	lw  $t0,($t2)       # $t0 = a[j]
	bgt $t0,$s0,do2     # while( a[j] > pivot );
	bge $s1,$s2,brk1    # if( i >= j ) break;
	lw $t0,($t1)        # t = a[i];
	lw $t3,($t2)        # a[i] = a[j];

	sw $t3,($t1)
	sw $t0,($t2)        # a[j] = t;
	j while1            # }

brk1:

	lw $t0,($t4)        # t = a[l];
	lw $t3,($t2)        # a[l] = a[j];
	sw $t3,($t4)
	sw $t0,($t2)        # a[j] = t;
	move $v0,$s2        # return j;
	lw $ra,0($sp)       # restore contents of $ra from the stack
	lw $s0,4($sp)       # restore $s0 register from the stack
	lw $s1,8($sp)       # restore $s1 register from the stack
	lw $s2,12($sp)      # restore $s2 register from the stack
	addi $sp,$sp,16     # restore stack pointer

	jr $ra


ExitProgram:
	li $v0, 10
	syscall