/*---------------------------------------------------------------------
**
**  Fichero:
**    fun_asm.c  19/10/2022
**
**    (c) Daniel Báscones García
**    Fundamentos de Computadores II
**    Facultad de Informática. Universidad Complutense de Madrid
**
**  Propósito:
**    Fichero de código para la práctica 4
**
**-------------------------------------------------------------------*/


//rellenar con directivas .extern y .global
//con las funciones apropiadas

.extern mul
.extern i_sqrt
//.extern main
.global eucl_dist
.global guardar



//int eucl_dist(int * w, int size);
eucl_dist:
    //recibo dirección de W en a0, y tamaño N en a1
    //realizo los cálculos pertinentes
    //devuelvo el resultado en a0

    li t0, 0                      // acc=0
    li t1, 0                      // i=0

    for:

    bge t1, a1, fin_for           // j si i>=N
    lw t2, 0(a0)                  // W[i]

    addi sp, sp, -20              // Apilamos
    sw ra, 16(sp)                 // ra
    sw t0, 12(sp)                 // acc
    sw t1, 8(sp)                  // i
    sw a0, 4(sp)                  // @W[i]
    sw a1, 0(sp)                  // N

    mv a0, t2                     // Pasamos W[i] como parametro a mul
    mv a1, t2
    call mul
    mv t2, a0                     // t2=res

    lw ra, 16(sp)                 // ra
    lw t0, 12(sp)                 // acc
    lw t1, 8(sp)                  // i
    lw a0, 4(sp)                  // @W[i]
    lw a1, 0(sp)                  // N
    addi sp, sp, 20               // Desapilamos

    add t0, t0, t2                // acc+=res
    addi a0, a0, 4                // @W[i]->@W[i+1]
    addi t1, t1, 1                // ++i

    j for

    fin_for:

    mv a0, t0                     // a0=acc

    addi sp, sp, -4               // Apilamos ra
    sw ra, 0(sp)
    call i_sqrt                   // a0= i_sqrt ( acc )
    lw ra, 0(sp)
    addi sp, sp, 4                // Desapilamos

    ret


//int guardar(char valor, char * ubicacion);
guardar:
    //recibo el valor en a0, y la dirección destino en a1
    //asegurarse que sólo se guarda UN BYTE!!

    sb a0, 0(a1)                  // @a1 <- a0
    ret
