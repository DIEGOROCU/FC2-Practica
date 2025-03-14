/*---------------------------------------------------------------------
**
**  Fichero:
**    pr3_lab.asm  19/10/2022
**
**    (c) Daniel Báscones García
**    Fundamentos de Computadores II
**    Facultad de Informática. Universidad Complutense de Madrid
**
**  Propósito:
**    Fichero de código para la práctica 3_lab
**
**-------------------------------------------------------------------*/

.global main
.extern _stack
.equ N , 4

.data
B: 	 .word 3, 5, 1, 9
A:   .word 1, 6, 2, 3
.bss
res:   .space 4
normA: .space 4
normB: .space 4

.text
main :

la s3, res             // @res, @normA, @normB, @stack
la s1, normA
la s2, normB
la sp, _stack

la a0, A               // @A, @B, N
la a1, A               // a2, a3 = @A
li a2, N
call dotprod           // @s1=normA
sw a0, 0(s1)


la a0, B               // a2, a3 = @B
la a1, B
li a2, N
call dotprod           // @s2=normB
sw a0, 0(s2)

lw t0, 0(s1)
lw t1, 0(s2)

if:

ble t0, t1, else         // j si normA<=normB
li t3, 10                // aux
sw t3, 0(s3)             // res=0xa

j fin

else:

li t3, 11                // aux
sw t3, 0(s3)             // res=0xb

j fin

dotprod :

addi sp, sp, -12         // Pila (apilamos)
sw ra, 8(sp)
sw s3, 4(sp)
sw s1, 0(sp)

li s3, 0                 // acc=0
li s1, 0                 // i=0

mv t2, a0
mv t3, a1

for:

bge s1, a2, fin_for      // j si i>=n

lw a0, 0(t2)             // V[i]
lw a1, 0(t3)             // W[i]

call mul
add s3, s3, a0
addi t2, t2, 4
addi t3, t3, 4
addi s1, s1, 1
j for

fin_for:

add a0, s3, zero         // a0=acc
lw ra, 8(sp)
lw s3, 4(sp)
lw s1, 0(sp)
addi sp, sp, 12          // Pila (desapilamos)
ret

mul :

li t0, 0                 // t0<-res

while:

ble a1, zero, fin_while  // j si b<=0
add t0, t0, a0           // res+=a
addi a1, a1, -1          // b--
j while

fin_while:

mv a0, t0
ret

fin:

j .

.end
