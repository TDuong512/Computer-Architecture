
# Tien Quan Ca - theo ban nhac (Sib truong, nhip 4/4)
# Don vi do dai: 1 = nop moc don (1/8). Nop den = 2, nop trang = 4, nop den chap = 3, nop den chap trang = 6, nop tron = 8
# Cao do 0 = dau lang (nghi)

.data
a:          .word 0        # tham so dich cao do (0 = giu nguyen)
thoiluong:  .word 225     # ms cho moi don vi
instrument: .word 60

cao_do:
    # Nhac dem (lay da): nghi, nghi, Fa Sol Fa
    .word 0, 0, 65, 67, 65
    # Ô 1-2: Nam di / Chung long cuu quoc Buoc chan
    .word 70, 70, 72, 70
    .word 74, 74, 72, 70
    # Ô 3-5: don vang tren duong gap ghenh xa / Co in mau chien thang mang hon
    .word 67, 70, 70, 67, 65, 62
    .word 65, 70, 72
    .word 74, 74, 74, 72, 70
    # Ô 6-8: nuoc Sung ngoai / xa chen khuc quan hanh / ca Duong vinh
    .word 79, 73, 70
    .word 72, 72, 74, 67, 65
    .word 70, 74, 75
    # Ô 9-11: quang xay xac quan thu / Thang gian lao / cung nhau lap chien
    .word 77, 77, 79, 77
    .word 74, 74, 72
    .word 70, 65, 69, 69, 72
    # Ô 12-14: khu Vi nhan dan chien dau khong ngung Tien mau ra sa truong
    .word 70, 74, 75
    .word 76, 78, 79, 76
    .word 75, 80, 77
    # Ô 15-18: ra sa truong / Tien len Cung tien len / Nuoc Nuoc non Viet
    .word 73, 72, 70
    .word 77, 74,70, 77, 74
    .word 65, 62, 60, 65
    # Ô 19: Nam ta Vung
    .word 72, 72, 74
    # Ket (volta 2): ben
    .word 71

do_dai:
    .word 4, 1, 1, 1, 1
    .word 2, 4, 1, 1
    .word 2, 4, 1, 1
    .word 2, 2, 1, 1, 1, 1
    .word 6, 1, 1
    .word 2, 2, 2, 1, 1
    .word 6, 1, 1
    .word 2, 2, 2, 1, 1
    .word 6, 1, 1
    .word 2, 2, 3, 1
    .word 4, 3, 1
    .word 2, 2, 2, 1, 1
    .word 6, 1, 1
    .word 2, 2, 3, 1
    .word 4, 3, 1
    .word 2, 2, 4
    .word 4, 6,4, 2, 4
    .word 5, 1, 1, 1
    .word 2, 4, 2
    .word 8

notes:      .word 75

space:      .asciiz " "
newline:    .asciiz "\n"
du_kien:    .asciiz "Tong du kien (ms): "
thoi_gian:  .asciiz "Thoi gian do duoc (ms): "

.text
.globl main
main:
    lw  $s0, a
    lw  $s1, thoiluong
    lw  $s2, instrument

    li  $v0, 30
    syscall
    move $s3, $a0           # thoi gian bat dau

    la  $t0, cao_do
    la  $t1, do_dai
    lw  $t2, notes
    li  $t3, 0              # dem so not
    li  $s4, 0              # tong thoi gian du kien

Loop:
    beq $t3, $t2, ExitLoop

    lw  $t4, 0($t0)         # cao do goc
    lw  $t5, 0($t1)         # do dai goc
    mul $t5, $t5, $s1       # thoi luong thuc (ms)
    add $s4, $s4, $t5

    beqz $t4, Rest          # cao do 0 -> nghi
    add $t4, $t4, $s0       # cao do thuc

    # in cao do va thoi luong
    li  $v0, 1
    move $a0, $t4
    syscall
    li  $v0, 4
    la  $a0, space
    syscall
    li  $v0, 1
    move $a0, $t5
    syscall
    li  $v0, 4
    la  $a0, newline
    syscall

    # phat not
    move $a0, $t4
    move $a1, $t5
    move $a2, $s2
    li  $a3, 100
    li  $v0, 33
    syscall
    j   Next

Rest:
    move $a0, $t5           # nghi
    li  $v0, 32
    syscall

Next:
    addiu $t0, $t0, 4
    addiu $t1, $t1, 4
    addiu $t3, $t3, 1
    j   Loop

ExitLoop:
    li  $v0, 30
    syscall
    move $s5, $a0
    sub $s6, $s5, $s3

    li  $v0, 4
    la  $a0, du_kien
    syscall
    li  $v0, 1
    move $a0, $s4
    syscall
    li  $v0, 4
    la  $a0, newline
    syscall

    li  $v0, 4
    la  $a0, thoi_gian
    syscall
    li  $v0, 1
    move $a0, $s6
    syscall
    li  $v0, 4
    la  $a0, newline
    syscall

    li  $v0, 10
    syscall