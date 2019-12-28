.data
	array: .space 1000 
	n: .word 0
	TBNhap1: .asciiz "Size of array: "
	TBNhap2: .asciiz "a["
	TBNhap3: .asciiz "]: "
	TBXuat1: .asciiz "Array a: "
	TBXuat2: .asciiz "Empty array\n"
	Menu: .asciiz "\n==========Menu==========\n1. Input array again\n2. Output array\n3. List of prime number in array\n4. Find max\n5. Sum of array\n6. Search element\n0. Exit\n========================\nYour choice: "
	TBXuat3: .asciiz "List of prime number: "
	TBXuat4: .asciiz "Max of array is: "
	TBXuat5: .asciiz "Sum of array is: "
	TBNull: .asciiz "Invalid\n"
	TBNhapSai: .asciiz "\nWrong input, try-again\n"
	
	prompt: .asciiz "Element you want to search for: "
	answer: .asciiz "Found element at index: "
	noAnswer: .asciiz "Not found element in array"
.text
	.globl main
main:
	_NhapMang: 
		la $a0, TBNhap1 # in thong bao nhap n
		li $v0, 4
		syscall
		li $v0, 5 # nhap n
		syscall
		
		beq $v0, 0, XuatMenu # kiem tra n = 0
		li $t2, 0
		slt $t1, $v0, $t2
		beq $t1, 1, _NhapMang # n < 0 thi nhap lai
		
		sw $v0, n
		lw $s1, n
		
		li $t0, 0 # i = 0
		la $s0, array # load array to $s0
	_NhapMang.Lap:
		la $a0, TBNhap2 
		li $v0, 4
		syscall
		
		move $a0, $t0 # output i
		li $v0, 1
		syscall
		
		la $a0, TBNhap3
		li $v0, 4
		syscall
		
		li $v0, 5 # nhap so nguyen
		syscall
		
		sw $v0,($s0) # store to array
		
		addi $s0, $s0, 4
		addi $t0, $t0, 1 # i++
		
		slt $t1, $t0, $s1
		beq $t1, 1, _NhapMang.Lap
		# s1: n, $t0: i, $s0: array
		# $t0: temp
		j XuatMenu
XuatMenu:
	# menu
	li $v0, 4
	la $a0, Menu
	syscall
	
	# option
	li $v0, 5
	syscall
	
	# store to $t2
	move $t2, $v0
	
	beq $t2, 1, _NhapMang
	beq $t2, 2, _XuatMang
	beq $t2, 3, _LietKeSoNguyenTo
	beq $t2, 4, _TimGiaTriLonNhat
	beq $t2, 5, _SumArray
	beq $t2, 6, _Search
	beq $t2, 0, _Thoat
	j _NhapSai
_XuatMang: 
	la $a0, TBXuat1
	li $v0, 4
	syscall
	
	beq $s1, 0, _XuatMang.TBMangRong # check empty array
	
	li $t0, 0 # i = 0
	la $s0, array # load array to $s0
_XuatMang.Lap:
	lw $a0,($s0) # load element of array
	li $v0, 1 # output element
	syscall
	
	li $a0, 32 # xuat khoang trang
	li $v0, 11
	syscall
	
	addi $s0, $s0, 4 # next element
	addi $t0, $t0, 1 # i++
	
	slt $t1, $t0, $s1
	beq $t1, 1, _XuatMang.Lap
	
	j XuatMenu
_XuatMang.TBMangRong:
	la $a0, TBXuat2 
	li $v0, 4
	syscall
# option 3
_LietKeSoNguyenTo:
	li $t0, 0
	la $s0, array # load array to $s0
_LietKeSoNguyenTo.Lap:
	lw $a0,($s0) # take element of array
	jal _KiemTraNguyenTo
	move $t1, $v0
	beq $t1, 0, _LietKeSoNguyenTo.TiepTucLap # if not prime number, continue to next index
	jal _LietKeSoNguyenTo.Xuat
_LietKeSoNguyenTo.TiepTucLap:
	addi $s0, $s0, 4 # next element
	addi $t0, $t0, 1 # i++
	
	slt $t2, $t0, $s1
	beq $t2, 1, _LietKeSoNguyenTo.Lap
	
	j XuatMenu
_LietKeSoNguyenTo.Xuat:
	li $v0, 1
	syscall
	
	li $a0, 32 # xuat khoang trang
	li $v0, 11
	syscall
	
	jr $ra # continue to loop
# option 4
_TimGiaTriLonNhat:
	li $s2, 0
	beq $s1, $s2, _TimGiaTriLonNhat.XuatKhongCo # if n = 0
	
	la $s0, array
	lw $t0,($s0)
	
	li $t1, 0 # array index = 0
	li $t3, 0 # max = 0
	li $t4, 0 # max index = 0
_TimGiaTriLonNhat.Lap:
	beq $t1, $s1, Print
	
	slt $t9, $t3, $t0 # max < a[i]
	bne $t9, $0, if # if $t9 != 0
_TimGiaTriLonNhat.TiepTucLap:
	addi $t1, $t1, 1 # increment i
	addi $s0, $s0, 4 # increment array address to next index
	lw $t0, ($s0) # $t0 = next index
	j _TimGiaTriLonNhat.Lap
if:
	move $t3, $t0 # max = a[i]
	move $t4, $t1 # max index = i
	j _TimGiaTriLonNhat.TiepTucLap
Print:
	move $s3, $t3 # move max to $s3
	move $s4, $t4 # move max index to $s4
	
	li $v0, 4
	la $a0, TBXuat4
	syscall
	
	li $v0, 1 
	move $a0, $s3
	syscall # print max
	
	j XuatMenu
_TimGiaTriLonNhat.XuatKhongCo:
	la $a0, TBNull
	li $v0, 4
	
	j XuatMenu
_NhapSai:
	li $v0, 4
	la $a0, TBNhapSai
	syscall
	
	j XuatMenu
_Thoat:
	li $v0, 10
	syscall
# function check prime number
# step 1
_KiemTraNguyenTo:
	addi $sp, $sp, -16
	
	sw $ra,($sp)
	sw $s0,4($sp)
	sw $t0,8($sp)
	sw $t1,12($sp)
# step 2
	li $s0, 0 # count = 0
	li $t0, 1 # i = 1
_KiemTraNguyenTo.Lap:
	div $a0, $t0
	mfhi $t1
	
	# kiem tra phan du
	beq $t1,0,_KiemTraNguyenTo.TangDem
	j _KiemTraNguyenTo.Tangi
_KiemTraNguyenTo.TangDem:
	addi $s0,$s0,1
_KiemTraNguyenTo.Tangi:
	addi $t0, $t0, 1
	
	# check condition i <= n
	slt $t1,$a0,$t0
	beq $t1,0,_KiemTraNguyenTo.Lap
	
	# check count
	beq $s0,2,_KiemTraNguyenTo.Return
	# return 0
	li $v0,0
	j _KiemTraNguyenTo.KetThuc
_KiemTraNguyenTo.Return:
	li $v0, 1
_KiemTraNguyenTo.KetThuc:
	lw $ra,($sp)
	lw $s0,4($sp)
	lw $t0,8($sp)
	lw $t1,12($sp)
	
	addi $sp,$sp,16
	
	jr $ra
# option 5
_SumArray:
	li $t0, 0 # i = 0
	la $s0, array
	li $s2, 0 # sum = 0
_SumArrayLoop:
	lw $a0, ($s0) # take element of array
	move $t1, $v0 # save result to $t1
	beq $t1, 0, _SumArrayContinueLoop
	add $s2, $s2, $a0 # sum += $s2
_SumArrayContinueLoop:
	addi $s0, $s0, 4 # next index
	addi $t0, $t0, 1 # i++
	
	slt $t2, $t0, $s1 # if i < n
	beq $t2, 1, _SumArrayLoop
	
	la $a0, TBXuat5
	li $v0, 4
	syscall
	
	move $a0, $s2 # print sum
	li $v0, 1
	syscall
	
	j XuatMenu
# option 6
_Search:
	la $s0, array
	
	li $v0, 4
	la $a0, prompt
	syscall
	
	li $v0, 5
	syscall
	
	move $t0, $v0
	
	li $t3, 0 # i = 0
	li $t6, 1000 # length of array
Lap:
	lw $s1, 0($s0) # load a[i]
	sub $t2, $t0, $s1 # $t2 = input - a[i]
	
	beq $t2, $zero, isAnswer # if $t2 = 0, value is found
	beq $t3, $t6, answerNotFound
	addi $t3, $t3, 1 # i++
	addi $s0, $s0, 4 # array address + 4
	
	j Lap
answerNotFound:
	li $v0, 4
	la $a0, noAnswer
	syscall
	
	j XuatMenu
isAnswer:
	li $v0, 4
	la $a0, answer
	syscall
	
	li $v0, 1
	move $a0, $t3
	syscall
	
	j XuatMenu