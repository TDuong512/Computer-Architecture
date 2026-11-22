.data
n_val:  .word 20                # Do so lenh voi n = 20
str1:   .asciiz "F("
str2:   .asciiz ") = "

.text
.globl main
main:
        lw    $s0, n_val        # Doc n tu bo nho
        move  $a0, $s0
        jal   fib_opt           # Goi thu tuc toi uu truong hop co so
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

# fib_opt: tinh F(n) bang de quy co toi uu truong hop co so
# Tham so : $a0 = n (n >= 0)
# Tra ve  : $v0 = F(n)
# Thanh ghi: $ra, $s0, $s1 (chi cat vao khung ngan xep khi n >= 2), $t0
fib_opt:
        li    $t0, 2
        blt   $a0, $t0, fo_base # Kiem tra n < 2 TRUOC KHI cap khung ngan xep

        addi  $sp, $sp, -12     # Mo dau: chi cap khung 12 byte khi n >= 2
        sw    $ra, 8($sp)       # Cat dia chi tro ve
        sw    $s0, 4($sp)       # Cat $s0 (luu n)
        sw    $s1, 0($sp)       # Cat $s1 (luu F(n-1))

        move  $s0, $a0          # Luu n vao $s0
        addi  $a0, $s0, -1      # $a0 = n - 1
        jal   fib_opt           # Tinh F(n - 1)
        move  $s1, $v0          # Luu F(n - 1) vao $s1

        addi  $a0, $s0, -2      # $a0 = n - 2
        jal   fib_opt           # Tinh F(n - 2)
        add   $v0, $s1, $v0     # $v0 = F(n - 1) + F(n - 2)

        lw    $s1, 0($sp)       # Ket thuc: nap lai dung offset
        lw    $s0, 4($sp)
        lw    $ra, 8($sp)
        addi  $sp, $sp, 12      # Thu hoi khung
        jr    $ra

fo_base:
        move  $v0, $a0          # F(0) = 0, F(1) = 1
        jr    $ra               # Thoat ngay ma khong can thu hoi khung