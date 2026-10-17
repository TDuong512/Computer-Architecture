# Em thí nghiem lai voi full bài Ode to Joy
# bài duocc chia làm 4 doan


.data
#  tham so cá nhân
a : .word 9 # a =9
thoiluong : .word 200 # 150 + 5*10
instrument:.word 24
#khai báo các giai ?i?u 
cao_do: 
    # Doan 1 (15 not - nhu de bai)
    .word 64, 64, 65, 67, 67, 65, 64, 62, 60, 60, 62, 64, 64, 62, 62
    # Doan 2 (15 not - lap lai doan 1 nhung ket thuc khac)
    .word 64, 64, 65, 67, 67, 65, 64, 62, 60, 60, 62, 64, 62, 60, 60
    # Doan 3 (17 not - phan diep khuc cao trao)
    .word 62, 62, 64, 60, 62, 64, 65, 64, 60, 62, 64, 65, 64, 62, 60, 62, 55
    # Doan 4 (15 not - lap lai giong doan 2)
    .word 64, 64, 65, 67, 67, 65, 64, 62, 60, 60, 62, 64, 62, 60, 60

do_dai: 
    # Doan 1 (15 not)
    .word 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 1, 4
    # Doan 2 (15 not)
    .word 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 1, 4
    # Doan 3 (17 not)
    .word 2, 2, 2, 2, 2, 1, 1, 2, 2, 2, 1, 1, 2, 2, 2, 2, 4
    # Doan 4 (15 not)
    .word 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 1, 4
notes : .word 62

#các l?nh in màng hình 
space:          .asciiz " "
newline:        .asciiz "\n"
du_kien:   .asciiz "Tong du kien (ms): "
thoi_gian:     .asciiz "Thoi gian do duoc (ms): "
.text
.globl main
main:
    # N?p tham so ca nhan tu bo nho
    lw $s0,a
    lw $s1, thoiluong
    lw $s2, instrument
     # Lay thoi gian bat dau (syscall 30)
    li  $v0, 30
    syscall # l?y th?i gian b?t ??u
    move $s3, $a0           # $a0 chua 32 bit thap cua thoi gian he thong
    
    #khoi tao các con tr? tr? vào giai ?i?u
    la $t0,cao_do
    la $t1,do_dai
    lw $t2,notes 
    li $t3,0 # ?? l?u s? note ?ã phát
    li $s4,0 #?? l?u th?i gian 
    
Loop :
	beq $t3,$t2,ExitLoop 
	
	lw $t4,0($t0) # cao ?? g?c
	lw $t5,0($t1) #?? dài g?c 
	
	# chuy?n ?ôi giai ?i?u v?i tham s? cá nhân
	add $t4,$t4,$s0 #cao ?? th?c t? 
	mul $t5,$t5,$s1 #?? dài th?c t?
	
	#c?ng d?n th?i gian d? ki?n 
	add $s4,$s4,$t5
	
	#in 
   	li  $v0, 1
    	move $a0, $t4
    	syscall

    	# In khoang trang
    	li  $v0, 4
    	la  $a0, space
    	syscall

    	# In "thoi luong (ms)"
    	li  $v0, 1
    	move $a0, $t5
    	syscall

    	# Xuong dong
    	li  $v0, 4
    	la  $a0, newline
    	syscall
    	
  	#phát n?t nh?c
  	move $a0,$t4 #cao ??
  	move $a1,$t5 #th?i l??ng
  	move $a2,$s2 #nh?c c?
  	li $a3, 100 # âm l??ng
  	li $v0,31
  	syscall
  	# Syscall 32 (Ch? - Sleep)
  	subi $t6,$t5,100
    	move $a0, $t6      # a0 = thoi luong not (ms)
    	li $v0, 32
    	syscall
  	
  	
  	# Tang con tro va bien dem
    	addiu $t0, $t0, 4
    	addiu $t1, $t1, 4
    	addiu $t3, $t3, 1
  	j Loop
ExitLoop :
# Lay thoi gian ket thuc (syscall 30)
    	li  $v0, 30
    	syscall
    	move $s5, $a0  
 
# Tinh thoi gian thuc te (Ket thuc - Bat dau)
	sub $s6,$s5,$s3
# In Tong du kien
    	li  $v0, 4
    	la  $a0, du_kien
    	syscall
    	 
    	li  $v0, 1
    	move $a0, $s4
    	syscall

    	li  $v0, 4
    	la  $a0, newline
	syscall


# In Thoi gian do duoc
    	li  $v0, 4
    	la  $a0, thoi_gian
    	syscall

    	li  $v0, 1
    	move $a0, $s6
    	syscall
    	
	li $v0, 4
    	la  $a0, newline
    	syscall

# Ket thuc chuong trinh
    	li  $v0, 10
    	syscall
	
    
    

    
