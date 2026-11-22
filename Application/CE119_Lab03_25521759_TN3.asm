.data
n_val:  .word 20                # Thay doi gia tri n tai day de kiem thu va do
str1:   .asciiz "F("
str2:   .asciiz ") = "

.text
.globl main
main:
        lw    $s0, n_val        # Doc n tu bo nho
        move  $a0, $s0
        jal   fib_rec           # Doi thanh 'jal fib_iter' khi do phien ban lap
        move  $s1, $v0          # Luu ket qua F(n)

        # In ket qua: F(n) = <gia tri>
        li    $v0, 4
        la    $a0, str1
        syscall
        li    $v0, 1
        move  $a0, $s0
        syscall
        li    $v0, 4
        la    $a0, str2
        syscall
        li    $v0, 1
        move  $a0, $s1
        syscall

        li    $v0, 10
        syscall

# fib_rec: tinh F(n) bang de quy
# Tham so : $a0 = n (n >= 0)
# Tra ve  : $v0 = F(n)
# Thanh ghi: $ra, $s0, $s1 (cat vao khung ngan xep 12 byte)
fib_rec:
        addi  $sp, $sp, -12     # Mo dau: cap khung 3 word (12 byte)
        sw    $ra, 8($sp)       # Cat dia chi tro ve
        sw    $s0, 4($sp)       # Cat $s0 (se dung de luu n)
        sw    $s1, 0($sp)       # Cat $s1 (se dung de luu F(n-1))

        li    $t0, 2
        blt   $a0, $t0, fr_base # Neu n < 2 -> truong hop co so

        move  $s0, $a0          # Luu n vao $s0
        addi  $a0, $s0, -1      # $a0 = n - 1
        jal   fib_rec           # Tinh F(n - 1)
        move  $s1, $v0          # Luu F(n - 1) vao $s1

        addi  $a0, $s0, -2      # $a0 = n - 2
        jal   fib_rec           # Tinh F(n - 2)
        add   $v0, $s1, $v0     # $v0 = F(n - 1) + F(n - 2)
        j     fr_exit

fr_base:
        move  $v0, $a0          # F(0) = 0, F(1) = 1

fr_exit:
        lw    $s1, 0($sp)       # Ket thuc: nap lai dung offset
        lw    $s0, 4($sp)
        lw    $ra, 8($sp)
        addi  $sp, $sp, 12      # Thu hoi khung
        jr    $ra

# fib_iter: tinh F(n) bang vong lap (chep nguyen van tu de bai)
# Tham so : $a0 = n    Tra ve : $v0 = F(n)
# Thanh ghi: $t0-$t3 (thu tuc la)
fib_iter:
        move  $v0, $zero        # a = F(0)
        li    $t0, 1            # b = F(1)
        move  $t1, $zero        # i = 0
fi_loop:
        slt   $t2, $t1, $a0
        beq   $t2, $zero, fi_done
        addu  $t3, $v0, $t0     # a + b
        move  $v0, $t0
        move  $t0, $t3
        addiu $t1, $t1, 1
        j     fi_loop
fi_done:
        jr    $ra