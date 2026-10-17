.data
input : .asciiz "Vui long nhap x(kWh) (0<x<9999) : "
inputwrong : .asciiz "Gia tri khong hop le, nhap lai.\n" 
outputx: .asciiz "Tien dien: "
dong: .asciiz " dong" 

#dung luong va gia tien tung bac
dungluong : .word 50,50,100,100,100,9999
giatien: .word 1780,1840,2130,2680,3030,3180
.text
.globl main
main:
j nhap
wronginput:
	li $v0,4
	la $a0,inputwrong
	syscall
nhap :
	#in nhap
	li $v0,4
	la $a0,input
	syscall
	#nhap x 
	li $v0,5
	syscall
	move $s0,$v0 
	#kiem tra ?i?u ki?n c?a x
    	slti $t0, $s0, 10000
    	beq   $t0, $zero, wronginput
#tinh toan tien dien
tinhtoan :
    li   $s1, 0             # Tong tien = 0
    move $t4, $s0           # So kWh con lai = x
    la   $s2, dungluong    # Con tro mang dung luong
    la   $s3, giatien        # Con tro mang don gia
Loop :

	lw $t1,0($s2)	#dung luong
	lw $t2,0($s3)	#gia tien
	#so sanh xem lieu day la bac cuoi hay chua
	ble $t4,$t1,bac_cuoi
	#neu x lon hon bac 
	sub $t4,$t4,$t1
	mul $t3,$t1,$t2
	add $s1,$s1,$t3
	addiu $s2, $s2, 4       # Chuyen sang phan tu tiep theo cua mang capacities
    	addiu $s3, $s3, 4
	j Loop
bac_cuoi :
	mul $t3,$t4,$t2
	add $s1,$s1,$t3
outloop :
	li $v0,4
	la $a0,outputx
	syscall
	li $v0,1
	move $a0,$s1 
	syscall
	li $v0,4
	la $a0,dong
	syscall

# Thoat chuong trinh
    li   $v0, 10
    syscall
