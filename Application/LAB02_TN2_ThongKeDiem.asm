.data
diem:      .word 4, 1, 6, 7, 0, 3, 5, 0, 4, 7, 2, 1   # S[0..11], d = 9
grade_tab: .byte 0,0,0,0, 1,1,1, 2,2, 3,3             # nhom cua diem 0..10
	   .align 2
hist:      .word 0, 0, 0, 0                            # g0..g3
# Chuoi in ra
str_min:    .asciiz "min="
str_max:    .asciiz " max="
str_nl:     .asciiz "\n"
str_g0:     .asciiz "g0="
str_g1:     .asciiz " g1="
str_g2:     .asciiz " g2="
str_g3:     .asciiz " g3="
.text
main:
	#khai bao stats
	la $a0,diem
	li $a1,12
	jal stats
	#luu ket qua min max vao $s0,$s1 de khong bi ghi de 
	move $s0,$v0
	move $s1,$v1
	#in min va gia tri cua min
	la $a0,str_min
	li $v0,4
	syscall
	move $a0,$s0 
	li $v0,1
	syscall
	#in max va gia tri cua max
	la $a0,str_max
	li $v0,4
	syscall
	move $a0,$s1 
	li $v0,1
	syscall
	#in xuong dong
	la $a0, str_nl
	li $v0, 4
	syscall
	
	#Goi ham histogram 
	la $a0,diem
	li $a1,12
	la $a2,grade_tab
	la $a3, hist
	jal histogram
	
	#in ket qua g0 g1 g2 g3
	la $t0,hist
	
	la $a0,str_g0
	li $v0,4
	syscall
	lw $a0,0($t0)
	li $v0,1
	syscall
	
	la $a0,str_g1
	li $v0,4
	syscall
	lw $a0,4($t0)
	li $v0,1
	syscall
	
	la $a0,str_g2
	li $v0,4
	syscall
	lw $a0,8($t0)
	li $v0,1
	syscall
	
	la $a0,str_g3
	li $v0,4
	syscall
	lw $a0,12($t0)
	li $v0,1
	syscall
	
	#OUT KHOI CHUONG TRINH
	li $v0,10
	syscall
	
# stats: tim gia tri nho nhat va lon nhat cua mang word
# Tham so : $a0 = dia chi mang, $a1 = n (n >= 1)
# Tra ve  : $v0 = min, $v1 = max
# Thanh ghi su dung: $t0 (con tro), $t1 (bo dem), $t2 (phan tu), $t3 (ket qua slt)

stats:
	lw $v0 , 0($a0) #min = phan tu dau tien
	lw $v1,0($a0) #max = phan tu dau tien
	move $t0 , $a0 #con tro duyet mang
	move $t1 , $a1 #n phan tu
stats_loop:
	beq $t1,$zero,stats_done 
	lw $t2,0($t0)
	
	#kiem tra min
	slt $t3,$t2,$v0
	beq $t3,$zero,stats_skip_min
	move $v0,$t2
stats_skip_min:
	slt $t3,$v1,$t2
	beq $t3,$zero,stats_skip_max
	move $v1,$t2
stats_skip_max:
	addi $t0,$t0,4 # tro toi phan tu ke tiep
	addi $t1,$t1,-1 # giam vong lap
	j stats_loop
stats_done:
	jr $ra 
	

# histogram: thong ke so luong sinh vien theo nhom diem
# Tham so: 
#$a0 = dia chi mang diem,
# $a1 = n 
# $a2 = dia chi grade_tab
# $a3 = dia chi hist
# Tra ve : khong co (ket qua ghi vao mang hist)
# Thanh ghi su dung: $t0 (con tro), $t1 (bo dem), $t2 (diem s), $t3 (dia chi grade_tab[s]),
#                    $t4 (nhom g), $t5 (4g), $t6 (dia chi hist[g]), $t7 (gia tri dem)
histogram:
	move $t0,$a0 # con tro duyet mag
	move $t1,$a1 # bien dem vong lap
histogram_loop:
	beq $t1,$zero,histogram_done
	lw $t2,0($t0) #t2 = diem so (s)
	
	#tra bang grade_tab dung lbu
	add $t3,$a2,$t2 # t3 = dia chi gradetab[s] 
	lbu $t4 , 0($t3) #t4= nhom tuong ung (g) 
	
	#cap nhat mang hist
	sll $t5,$t4,2 #$t5 = g*4
	add $t6,$a3,$t5 #t6 = dia chi hist[g] 
	lw $t7,0($t6) #nap lai gia tric u
	addi $t7,$t7,1 # tang bien dem
	sw $t7,0($t6) #luu tro lai bo nho
	
	addi $t0,$t0,4 #tang con tro
	addi $t1,$t1,-1 #giam bien dem
	j histogram_loop
histogram_done:
	jr $ra