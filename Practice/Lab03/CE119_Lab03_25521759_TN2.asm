.data
str1:   .asciiz "kien truc may tinh"
str2:   .asciiz "mips"
str3:   .asciiz ""
str4:   .asciiz "a bc def"
str5:   .asciiz "mot lenh jr tra quyen ve noi goi" 

bar: .asciiz "|"
nl : .asciiz "\n"

.text
.globl main

main:
        la    $a0, str1
        jal   print
        la    $a0, str2
        jal   print
        la    $a0, str3
        jal   print
        la    $a0, str4
        jal  print
        la    $a0, str5
        jal   print

        li    $v0, 10
        syscall
     
print :
	addi $sp , $sp , -8
	sw $ra , 4($sp)
	sw $s0 , 0($sp)
	move $s0 , $a0 
	jal reverse_words 
	
	li    $v0, 4
        la    $a0, bar
        syscall
        move  $a0, $s0
        syscall
        la    $a0, bar
        syscall
        la    $a0, nl
        syscall

        lw    $s0, 0($sp)
        lw    $ra, 4($sp)
        addi  $sp, $sp, 8
        jr    $ra
        
        

# Strlen : ham nay dung de tinh do dai chuoi .asciiz ( thu tuc la )
# Tra ve : $v0 = do dai chuoi 
strlen: 
	move $v0 , $zero
loop_str :
	addu $t0 , $a0 , $v0 # Thanh ghi $t0 dung de luu dia chi tung byte
	lbu $t1, 0($t0)#Thanh ghi $t1 dung de luu gia tri tai dia chi offset + $t0 
	beq $t1 , $zero, done_str
	addiu $v0 , $v0 , 1 
	j loop_str 
done_str :
	jr $ra
	
#rev_range : ham nay dung de daonguoc mot doan chuoi tai cho 
#tra ve: dao thu tu tu trong chuoi
#thanh ghi $a0 luu dia chi ki tu dau
#thanh ghi $a1 luu dia chi ki tu cuoi 
rev_range :
	sltu $t2, $a0,$a1 #thanh ghi t2 dung de luu gia tri so sanh
	beq $t2 , $zero , done_rev_range
	lbu $t0 , 0($a0) #thanh ghi $t0 dung de luu gia tri byte dau chuoi
	lbu $t1 , 0($a1)# thanh ghi $t1 dung de luu gia tri byte cuoi chuoi
	sb $t1, 0($a0)
	sb $t0 , 0($a1)
	addiu $a1,$a1,-1
	addiu $a0,$a0,1
	j rev_range 
done_rev_range :
	jr $ra
#reverse_words : ham nay dung de luu  dao cac tu trong chuoi tai cho ( thu tuc khong la)
reverse_words :
	addi $sp , $sp , -20 
	sw $ra , 16($sp) # luu dia chi tra ve 
	sw $s0, 12($sp) # luu dia chi dau chuoi
	sw $s1, 8($sp) # luu con tro dau chuoi
	sw $s2 , 4($sp) # luu con tro hien tai
	sw $s3, 0($sp) # luu con tro cuoi chuoi
	
	move $s0, $a0 #$s0 luu dia chi dau chuoi
	jal strlen 
	beq $v0 , $zero , done_rev 
	
	#Buoc 1 : dao toan bo chuoi 
	move $a0 , $s0
	addu $s3, $v0 , $s0
	addiu $a1, $s3 , -1 
	jal rev_range
	
	#Buoc 2 : Duyet tung tu va dao nguoc lai
	
	move $s1 , $s0 # con tro mang gia tri bat dau mang
	move $s2, $s0 # con tro tro hien tai
loop_rev :
	sltu $t0 , $s3 , $s2 # so sanh 
	bne $t0 ,$zero, done_rev 
	lbu $t0, 0($s2) #thanh ghi $t0 mang gia tai ki tu hien tai
	li $t1,32 #32 la " " 
	beq $t0,$t1, rw_word #so sanh
	beq $t0, $zero, rw_word
	addiu $s2,$s2,1
	j loop_rev
rw_word :
	# can dung 
	move $a0, $s1 #thanh ghi a0 can chu cai dau tien cua chuoi 
	addiu $a1, $s2,-1 # thanh ghi a1 luu dia chi chu cai cuoi cua chuoi
	jal rev_range # dao chuoi
	addiu $s2,$s2,1 # sang ki tu tiep theo
	move $s1, $s2 #bat dau chuoi moi
	
	j loop_rev
done_rev :
        lw    $s3, 0($sp)#ket thuc: nap lai dung offset
        lw    $s2, 4($sp)
        lw    $s1, 8($sp)
        lw    $s0, 12($sp)
        lw    $ra, 16($sp)
        addi  $sp, $sp, 20#thu hoi khung
        jr    $ra
