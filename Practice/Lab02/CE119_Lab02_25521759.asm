# CE119 - Lab 02 - MSSV 25521759 (d = 9, k = 12)
.data
# ---------- TN2 ----------
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
# ---------- TN3 ----------
# Cac chuoi kiem thu Bang 16
t1: .asciiz "(a+b)*[c-{d/e}]"
t2: .asciiz "f(x[i]{j}))"
t3: .asciiz "{[(])}"
t4: .asciiz "((a)"
t5: .asciiz ""
t6: .asciiz "no brackets here"
t7: .asciiz "]"
t8: .asciiz "([)]"
tP: .asciiz "([{([{([{([{}])}])}])}])"     # chuoi ca nhan P, k = 12
	   .align 2
str_tab:   .word t1, t2, t3, t4, t5, t6, t7, t8, tP   # bang dia chi 9 chuoi
str_open:  .asciiz "("
str_comma: .asciiz ", "
str_close: .asciiz ")\n"

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

	la $a0, str_nl
	li $v0, 4
	syscall

	# ---------- MO RONG: ve pho diem ----------
	la   $a0, hist
	li   $a1, 4
	jal  draw_hist

	# ---------- TN3: kiem tra ngoac cho 9 chuoi ----------
	la   $s2, str_tab        # con tro vao bang dia chi chuoi
	li   $s3, 9              # so chuoi can kiem tra
main_tn3_loop:
	beq  $s3, $zero, main_exit
	lw   $a0, 0($s2)         # a0 = dia chi chuoi thu i
	jal  check_brackets
	move $s4, $v0            # cat ket qua truoc khi dung syscall
	move $s5, $v1
	la   $a0, str_open       # in "(v0, v1)"
	li   $v0, 4
	syscall
	move $a0, $s4
	li   $v0, 1
	syscall
	la   $a0, str_comma
	li   $v0, 4
	syscall
	move $a0, $s5
	li   $v0, 1
	syscall
	la   $a0, str_close
	li   $v0, 4
	syscall
	addi $s2, $s2, 4         # sang chuoi tiep theo
	addi $s3, $s3, -1
	j    main_tn3_loop

main_exit:
	#OUT KHOI CHUONG TRINH
	li $v0,10
	syscall

# stats: tim gia tri nho nhat va lon nhat cua mang word
# Tham so : $a0 = dia chi mang, $a1 = n (n >= 1)
# Tra ve  : $v0 = min, $v1 = max
# Thanh ghi su dung: $t0 (con tro), $t1 (bo dem), $t2 (phan tu), $t3 (ket qua slt)
stats:
	lw $v0,0($a0) #min = phan tu dau tien
	lw $v1,0($a0) #max = phan tu dau tien
	move $t0,$a0 #con tro duyet mang
	move $t1,$a1 #n phan tu
stats_loop:
	beq $t1,$zero,stats_done
	lw $t2,0($t0)
	#kiem tra min
	slt $t3,$t2,$v0
	beq $t3,$zero,stats_skip_min
	move $v0,$t2
stats_skip_min:
	#kiem tra max
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
# Tham so : $a0 = dia chi mang diem, $a1 = n,
#           $a2 = dia chi grade_tab, $a3 = dia chi hist
# Tra ve  : khong co (ket qua ghi vao mang hist)
# Thanh ghi su dung: $t0 (con tro), $t1 (bo dem), $t2 (diem s),
#   $t3 (dia chi grade_tab[s]), $t4 (nhom g), $t5 (4g),
#   $t6 (dia chi hist[g]), $t7 (gia tri dem)
histogram:
	move $t0,$a0 # con tro duyet mang
	move $t1,$a1 # bien dem vong lap
histogram_loop:
	beq $t1,$zero,histogram_done
	lw $t2,0($t0) #t2 = diem so (s)
	#tra bang grade_tab dung lbu
	add $t3,$a2,$t2 # t3 = dia chi grade_tab[s]
	lbu $t4,0($t3) # t4 = nhom tuong ung (g)
	#cap nhat mang hist
	sll $t5,$t4,2 # t5 = g*4
	add $t6,$a3,$t5 # t6 = dia chi hist[g]
	lw $t7,0($t6) # nap gia tri cu
	addi $t7,$t7,1 # tang bien dem
	sw $t7,0($t6) # luu tro lai bo nho
	addi $t0,$t0,4 # tang con tro
	addi $t1,$t1,-1 # giam bien dem
	j histogram_loop
histogram_done:
	jr $ra

# draw_hist: ve pho diem dang cot ngang, moi nhom 1 dong "gi: ||||"
# Tham so : $a0 = dia chi mang hist, $a1 = so nhom (4)
# Tra ve  : khong co
# Thanh ghi su dung: $t0 (con tro hist), $t1 (chi so nhom i),
#   $t2 (so ky tu '|' con phai in), $a0 va $v0 (tham so va ma syscall)
draw_hist:
	move $t0, $a0            # cat dia chi hist: $a0 se bi dung cho syscall
	li   $t1, 0              # i = 0
draw_hist_row:
	beq  $t1, $a1, draw_hist_done
	li   $a0, 'g'            # in nhan "gi: "
	li   $v0, 11
	syscall
	move $a0, $t1
	li   $v0, 1
	syscall
	li   $a0, ':'
	li   $v0, 11
	syscall
	li   $a0, ' '
	syscall                  # $v0 van = 11
	lw   $t2, 0($t0)         # t2 = hist[i] = so ky tu '|'
draw_hist_bar:
	beq  $t2, $zero, draw_hist_eol
	li   $a0, '|'
	li   $v0, 11
	syscall
	addi $t2, $t2, -1
	j    draw_hist_bar
draw_hist_eol:
	li   $a0, '\n'           # xuong dong
	li   $v0, 11
	syscall
	addi $t0, $t0, 4         # sang hist[i+1]
	addi $t1, $t1, 1
	j    draw_hist_row
draw_hist_done:
	jr   $ra

# check_brackets: kiem tra cac cap ngoac ( ) [ ] { } trong chuoi
# Tham so : $a0 = dia chi chuoi .asciiz
# Tra ve  : $v0 = vi tri (dem tu 1) hoac 0, $v1 = ma loi
#           0 = hop le, 1 = khac loai, 2 = dong khi rong, 3 = con ngoac mo
# Thanh ghi su dung: $t0 (con tro chuoi), $t1 (vi tri), $t2 (ky tu hien tai),
#   $t3 (ngoac mo vua pop), $t4 (ngoac mo can khop), $t5 (hang so ky tu),
#   $t9 ($sp luc vao thu tuc = day ngan xep)
# Ngan xep: moi ngoac mo push 1 word; $sp khoi phuc tai check_brackets_exit
check_brackets:
	move $t9, $sp            # ghi nho $sp luc vao
	move $t0, $a0
	li   $t1, 0
check_brackets_loop:
	lbu  $t2, 0($t0)         # doc ky tu
	beq  $t2, $zero, check_brackets_end   # gap '\0': het chuoi
	addi $t1, $t1, 1         # vi tri hien tai
	addi $t0, $t0, 1
	# ngoac mo -> push
	li   $t5, '('
	beq  $t2, $t5, check_brackets_push
	li   $t5, '['
	beq  $t2, $t5, check_brackets_push
	li   $t5, '{'
	beq  $t2, $t5, check_brackets_push
	# ngoac dong -> $t4 = ngoac mo tuong ung
	li   $t4, '('
	li   $t5, ')'
	beq  $t2, $t5, check_brackets_close
	li   $t4, '['
	li   $t5, ']'
	beq  $t2, $t5, check_brackets_close
	li   $t4, '{'
	li   $t5, '}'
	beq  $t2, $t5, check_brackets_close
	j    check_brackets_loop      # ky tu khac: bo qua
check_brackets_push:
	addi $sp, $sp, -4        # push $t2
	sw   $t2, 0($sp)
	j    check_brackets_loop
check_brackets_close:
	beq  $sp, $t9, check_brackets_err2   # ngan xep rong
	lw   $t3, 0($sp)         # pop vao $t3
	addi $sp, $sp, 4
	bne  $t3, $t4, check_brackets_err1   # khac loai
	j    check_brackets_loop
check_brackets_end:
	bne  $sp, $t9, check_brackets_err3   # con ngoac mo chua dong
	li   $v0, 0
	li   $v1, 0
	j    check_brackets_exit
check_brackets_err1:
	move $v0, $t1
	li   $v1, 1
	j    check_brackets_exit
check_brackets_err2:
	move $v0, $t1
	li   $v1, 2
	j    check_brackets_exit
check_brackets_err3:
	addi $v0, $t1, 1         # do dai chuoi + 1
	li   $v1, 3
check_brackets_exit:
	move $sp, $t9            # khoi phuc $sp tren MOI duong thoat
	jr   $ra