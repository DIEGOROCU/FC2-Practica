/*---------------------------------------------------------------------
**
**  Fichero:
**    fun_asm.asm  19/10/2022
**
**    (c) Daniel Báscones García
**    Fundamentos de Computadores II
**    Facultad de Informática. Universidad Complutense de Madrid
**
**  Propósito:
**    Fichero de código para la práctica 4_lab
**
**-------------------------------------------------------------------*/


.global mul
.global i_sqrt

.extern _stack
.extern eucl_dist
.extern guardar

.equ N , 5

.data
U: 	 .word 5 , 2, -3 , 7 , 6
V:   .word 6 , -1 , 1 , 0 , 3
.bss
mayor_u:   .space 1

.text
main :

la sp, _stack

la a0, U                               // a0=@U, a1=N
li a1, N

call eucl_dist                         // a0=eucl_dist (U , N )

addi sp, sp, -4                        // Apilamos a0
sw a0, 0(sp)

la a0, V                               // a0=@U, a1=N
li a1, N

call eucl_dist                         // a0=eucl_dist (V , N )

mv t1, a0                              // d_v

lw t0, 0(sp)
addi sp, sp, 4                         // Desapilamos d_u

if:                                    // 1 si d_u>d_v - 0 si else

ble t0, t1, else
li a0, 1
j fin_if

else:

li a0, 0

fin_if:

la a1, mayor_u

call guardar                           // guardar(mayor, @mayor_u)

while2:                                // while(1)

j while2



mul:

mul a0, a0, a1                         // a0=a0*a1
ret



i_sqrt:

li t0, 0                               // root=0
mv t1, a0                              // t1=a

while:

addi sp, sp, -12                       // Apilamos
sw ra, 8(sp)
sw t0, 4(sp)
sw t1, 0(sp)

mv a0, t0                              // a0,a1=root
mv a1, t0

call mul                               // a0=mul(root, root)

lw ra, 8(sp)
lw t0, 4(sp)
lw t1, 0(sp)
addi sp, sp, 12                        // Desapilamos

bge a0, t1, fin_while                  // j si mul>=a

addi t0, t0, 1                         // root++

j while

fin_while:

mv a0, t0                              // ret root
ret




.end

