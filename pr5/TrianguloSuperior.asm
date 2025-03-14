.global cerosTrianguloSup

// PASAMOS A LA FUNCION cerosTrianguloSup

cerosTrianguloSup:
    // Tenemos en a0 el indice de la ecc. (el falso, sin contar los vectores denominador)
    mv t0, a0          // Posicion a0 de un vector
    mv t1, a0
    slli t0, t0, 2
    add t0, t0, s3     // @SolNum[a0]

    slli t1, t1, 1     // Indice de EccNum
    mul t1, t1, s4
    add t1, t1, s2     // @Ecc a0 Num
    add t1, t1, s4
    addi t1, t1, -4    // @Ecc a0 Num[Termino independiente]

    mv t2, s1          // t2=N-1 (i)
    addi t2, t2, -1

    addi sp, sp, -16   // Apilamos
    sw a0, 0(sp)
    sw t0, 4(sp)
    sw t1, 8(sp)
    sw t2, 12(sp)

    while_triSup:
        lw a0, 0(sp)
        lw t2, 12(sp)
        beq t2, a0, fin_while_triSup   // j si i=a0

        slli t0, t2, 2
        slli t1, s1, 2
        sub t0, t1, t0
        lw t1, 8(sp)
        sub t0, t1, t0   // @EccNum[i]

        lw a2, 0(t0)
        sw zero, 0(t0)
        add t0, t0, s4
        lw a3, 0(t0)     // Num y Den de Ecc[i]
        li t4, 1
        sw t4, 0(t0)     // Aprovechamos y ponemos el num y den de Ecc[i] a 0 y 1 respectivamente

        slli t0, t2, 2
        slli t1, s1, 2
        sub t0, t1, t0
        add t1, s3, s4
        addi t1, t1, -4
        sub t0, t1, t0   // @Sol[i]
        lw t4, 0(t0)
        mul a2, a2, t4
        add t0, t0, s4
        lw t4, 0(t0)
        mul a3, a3, t4   // Multiplicamos ese numero por la solucion correspondiente

        lw t1, 8(sp)
        lw a0, 0(t1)
        add t1, t1, s4
        lw a1, 0(t1)     // Num y Den de Ecc[Ter. independiente]

        lw t1, 8(sp)
        add t1, t1, s4
        mul t0, a1, a3   // Ecc[i]den * Ecc[Ter. independiente]den
        sw t0, 0(t1)     // Guardamos el nuevo denominador del ter. independiente

        addi sp, sp, -4
        sw ra, 0(sp)
        call restaNumerador
        lw ra, 0(sp)
        addi sp, sp, 4

        lw t1, 8(sp)
        sw a0, 0(t1)     // Guardamos el nuevo numerador del ter. independiente

        lw t2, 12(sp)
        addi t2, t2, -1
        sw t2, 12(sp)    // i--

        j while_triSup

    fin_while_triSup:
        lw a0, 0(sp)

        addi sp, sp, -4
        sw ra, 0(sp)
        call guardaSol     // Guardamos la solucion
        lw a0, 4(sp)
        slli a0, a0, 2
        add a0, a0, s3     // Calculamos @Sol[a0]
        call simplificaNum // Simplificamos la solucion
        lw ra, 0(sp)
        addi sp, sp, 4

        lw a0, 0(sp)
        slli a0, a0, 1
        mul a0, a0, s4
        add a0, a0, s2
        add a0, a0, s4
        addi a0, a0, -4

        addi sp, sp, -4
        sw ra, 0(sp)
        call simplificaNum // Simplificamos
        lw ra, 0(sp)
        addi sp, sp, 4

        lw a0, 0(sp)
        lw t0, 4(sp)
        lw t1, 8(sp)
        lw t2, 12(sp)
        addi sp, sp, 16   // Desapilamos

        ret

// PASAMOS A LA FUNCION guardaSol

guardaSol:
    // Tenemos en a0 el indice de la Ecc. falsa
    mv t0, a0
    slli t0, t0, 2   // Posicion del numero en ambos vectores

    slli a0, a0, 1
    mul a0, a0, s4
    add a0, a0, s2   // @EccNum (a0)

    add t1, a0, t0   // @EccNum[a0]
    li t2, 1

    lw t3, 0(t1)
    sw t2, 0(t1)
    add t1, t1, s4
    lw t4, 0(t1)     // Cargamos el numero que nos dara una incognita
    sw t2, 0(t1)     // Aprovehcamos y ponemos 1/1

    add t2, a0, s4
    addi t2, t2, -4  // @EccNum[Ter. independiente]

    lw t5, 0(t2)
    mul t5, t5, t4
    sw t5, 0(t2)
    add t2, t2, s4
    lw t6, 0(t2)
    mul t6, t6, t3
    sw t6, 0(t2)     // Cargamos Ecc(a0)[Ter. independiente], y lo dividimos por el numero

    add t1, t0, s3   // @SolNum[a0]
    sw t5, 0(t1)
    add t1, t1, s4
    sw t6, 0(t1)     // Guardamos la nueva solucion

    ret

// PASAMOS A LA FUNCION simplificaNum

simplificaNum:
    // a0 tiene el @ del numero
    mv t0, s5
    lw t1, 0(t0)   // Primer primo

    lw t2, 0(a0)
    add a0, a0, s4
    lw t3, 0(a0)   // Numero a simplificar
    sub a0, a0, s4

while_simplificaNum:
    lw t1, 0(t0)
    beq t1, zero, fin_while_simplificaNum // j si Primos[i]=0 (fin de la lista)

    if_simplificaNum:     // a0Num & Primos[i] == 0 && a0Den % Primos[i] == 0
        rem t4, t2, t1
        rem t5, t3, t1        // Restos al dividir el num y den por el primo
        bne t4, zero, else_simplificaNum
        bne t5, zero, else_simplificaNum

        div t2, t2, t1        // Simplificamos el numero
        div t3, t3, t1

        sw t2, 0(a0)
        add a0, a0, s4
        sw t3, 0(a0)
        sub a0, a0, s4        // Guardamos el numero

        mv t0, s5             // Volvemos a Primos[0]

        j fin_if_simplificaNum

    else_simplificaNum:   // Si no son divisibles por Primos[i]
        addi t0, t0, 4        // i++ (4 para tener el indice exacto)
        j fin_if_simplificaNum

fin_if_simplificaNum:
    lw t1, 0(t0)      // t1=Primos[i]
    j while_simplificaNum          // Volvemos a comprobar con el siguiente primo (o el primero si hemos podido simplificar)

fin_while_simplificaNum:

    // Ya esta simplificado, solo falta ver el signo
    bgt t2, zero, fin_simplificaNum
    bgt t3, zero, fin_simplificaNum

    li t0, -1
    mul t2, t2, t0
    mul t3, t3, t0

    sw t2, 0(a0)
    add a0, a0, s4
    sw t3, 0(a0)
    sub a0, a0, s4        // Guardamos el numero ya simplificado

fin_simplificaNum:

    ret
