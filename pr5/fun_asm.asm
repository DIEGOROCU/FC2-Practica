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
**    Fichero de código para la práctica 5_lab
**
**-------------------------------------------------------------------*/

.global main

.extern restaNumerador
.extern calculaIndice
.extern mcm
.extern guardaSol
.extern cerosTrianguloSup
.extern simplificaEcc
.extern revisaEccCorrectas
.extern _stack
.extern revisaEccCorrectas
.extern ajustaCols
.extern intercambiaCols

.equ N , 3

.data

E1n: 	 .word 1, 1, 0, 5
E1d:     .word 1, 1, 1, 1

E2n: 	 .word 1, 0, 1, 6
E2d:     .word 1, 1, 1, 1

E3n: 	 .word 0, 1, 1, 7
E3d:     .word 1, 1, 1, 1

Primos:  .word 2, 3, 5, 7, 11, 13, 17, 0         // Para simplificar

AuxCols:     .word -1, -1, -1
IntercambiadorMoncloa: .word 0, 1, 2

.bss

Visualizador: .space 16-((( (N+1)*8) + (N*8) ) % 16)

Sn:     .space (N+1)*4
Sd:     .space (N+1)*4

.text
main:

li s1, N;                  // Valor de N
la s2, E1n;                // @ De la 1 ecc
la s3, Sn;                 // @ Del vector solucion
li s4, 1
add s4, s4, s1
slli s4, s4, 2             // s4=4*(N+1) se usara despues frecuentemente
la s5, Primos              // @ Del vector Primos
la s6, AuxCols             // @ Del vector auxiliar de columnas
la s7, IntercambiadorMoncloa

call revisaEccCorrectas

call ajustaCols

li t0, 0                   // i=0

for_trianguloInf:

addi t1, s1, -1                     // j=N-1
bge t0, t1, fin_for_trianguloInf    // jump si i>=N-1

for_trianguloInfCol:

ble t1, t0, fin_for_trianguloInfCol    // jump si j<=i

simplificacion:

mv a0, t0              // a0 y a1 cogen los indices de las ecuaciones a reducir
mv a1, t1

slli a0, a0, 1         // Multiplicamos por 2 para acceder a las ecc. reales
slli a1, a1, 1

addi sp, sp, -8        // Apilamos t0 y t1
sw t0, 4(sp)
sw t1, 0(sp)

call mcm               // Hacemos el mcm de las ecc. i, j

beq a0, zero, fin_simplificacion   // j si habia un 0

lw a0, 4(sp)
lw a1, 0(sp)

slli a0, a0, 1         // Multiplicamos por 2 para acceder a las ecc. reales
slli a1, a1, 1

call restarEcc         // Restamos la ecc. i a la ecc. j

fin_simplificacion:

lw t0, 4(sp)
lw t1, 0(sp)
addi sp, sp, 8         // Desapilamos t0 y t1

addi t1, t1, -1        // j--

j for_trianguloInfCol

fin_for_trianguloInfCol:

addi t0, t0, 1         // i++
j for_trianguloInf

fin_for_trianguloInf:

mv t0, s1
addi t0, t0, -1        // i=N-1

addi sp, sp, -4        // Apilamos i
sw t0, 0(sp)

for_guardamosSoluciones:

lw t0, 0(sp)             // Cargamos i
blt t0, zero, fin_for_guardamosSoluciones   // j si i<0

mv a0, t0
call cerosTrianguloSup   // Hacemos 0 de la ecuacion i, y guardamos su solucion correspondiente

lw t0, 0(sp)
addi t0, t0, -1          // i--
sw t0, 0(sp)

j for_guardamosSoluciones

fin_for_guardamosSoluciones:

addi sp, sp, 4

fin:

j fin

// FALTA CLASIFICAR EL SISTEMA

.end
