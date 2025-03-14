.global mcm
.global restarEcc


// PASAMOS A LA FUNCION mcm


mcm:

    // a0 y a1 tienen las ecc.

	addi sp, sp, -12       // Apilamos a0 y a1, y ra
	sw ra, 8(sp)
	sw a0, 4(sp)
	sw a1, 0(sp)

	mv a0, a0              // Pasamos el indice de ecc1
	mv a1, a0
	srli a1, a1, 1

	call calculaIndice

	add a0, a0, s2         // Indice real para t2 y t3

	lw t2, 0(a0)           // Con el indice del numerador, lo guardamos en t2 y en t3 el denominador
	add a0, a0, s4
	lw t3, 0(a0)

	addi sp, sp, -8        // Apilamos t2 y t3 (num y den del 1 numero)
	sw t2, 4(sp)
	sw t3, 0(sp)

	lw a0, 8(sp)           // Pasamos el indice de ecc2
	lw a1, 12(sp)
	srli a1, a1, 1

	call calculaIndice

	add a0, a0, s2         // Indice real para t4 y t5

	lw t4, 0(a0)           // Guardamos el numerador y denominador del 2 numero
	add a0, a0, s4
	lw t5, 0(a0)

	lw t2, 4(sp)           // Desapilamos todos los valores
	lw t3, 0(sp)
	lw a0, 12(sp)
	lw a1, 8(sp)
	addi sp, sp, 8

	beq t4, zero, fin_mcm  // Si ya tenemos un 0, no hacemos nada

	li t6, 0

	mul a0, a0, s4   // Calculamos las direcciones de ambas ecc.
	mul a1, a1, s4
	add a0, a0, s2
	add a1, a1, s2

	// Primer for
	for_primeraEccNum:

		blt s1, t6, fin_for_primeraEccNum         // j si i>=N

		slli t1, t6, 2                            // t1=i*4
		add t1, a0, t1                            // t1=@Ecc1N[i]
		lw t0, 0(t1)                              // Ecc1N[i]
		mul t0, t0, t4                            // Multiplicamos por t4 (num del 2 numero)
		sw t0, 0(t1)                              // Guardamos el valor en la ecc
		addi t6, t6, 1                            // i++

		j for_primeraEccNum

	fin_for_primeraEccNum:

	    li t6, 0                                  // i=0 (para el siguiente for)

	// Segundo for
	for_primeraEccDen:

		blt s1, t6, fin_for_primeraEccDen         // j si i>=N

		slli t1, t6, 2                            // t1=i*4
		add t1, a0, t1                            // t1=@Ecc1D[i]
		add t1, t1, s4
		lw t0, 0(t1)                              // Ecc1D[i]
		mul t0, t0, t5                            // Multiplicamos por t5 (den del 2 numero)
		sw t0, 0(t1)                              // Guardamos el valor en la ecc
		addi t6, t6, 1                            // i++

		j for_primeraEccDen

	fin_for_primeraEccDen:

	    li t6, 0                                  // i=0 (para el siguiente for)

	// Tercer for (ya de la 2 ecc)
	for_segundaEccNum:

		blt s1, t6, fin_for_segundaEccNum         // j si i>=N

		slli t1, t6, 2                            // t1=i*4
		add t1, a1, t1                            // t1=@Ecc2N[i]
		lw t0, 0(t1)                              // Ecc1N[i]
		mul t0, t0, t2                            // Multiplicamos por t2 (num del 1 numero)
		sw t0, 0(t1)                              // Guardamos el valor en la ecc
		addi t6, t6, 1                            // i++

		j for_segundaEccNum

	fin_for_segundaEccNum:

	    li t6, 0                                  // i=0 (para el siguiente for)

	// Cuarto for
	for_segundaEccDen:

		blt s1, t6, fin_for_segundaEccDen         // j si i>=N

		slli t1, t6, 2                            // t1=i*4
		add t1, a1, t1                            // t1=@Ecc2D[i]
		add t1, t1, s4
		lw t0, 0(t1)                              // Ecc1D[i]
		mul t0, t0, t3                            // Multiplicamos por t3 (den del 1 numero)
		sw t0, 0(t1)                              // Guardamos el valor en la ecc
		addi t6, t6, 1                            // i++

		j for_segundaEccDen

	fin_for_segundaEccDen:

	// Ahora simplificamos las ecuaciones
	lw a0, 4(sp)            // Indice de la 1 Ecc

	call simplificaEcc

	lw a0, 0(sp)            // Indice de la 2 Ecc

	call simplificaEcc

	li a0, 1                // Devolvemos que SI se han multiplicado las ecc

	lw ra, 8(sp)            // Desapilamos ra
	addi sp, sp, 12

	ret       // Ambas ecc ya multiplicadas

	fin_mcm:

	li a0, 0                // NO hemos multiplicado las ecc

	lw ra, 8(sp)            // Desapilamos ra
	addi sp, sp, 12

ret       // NO multiplicamos ambas ecc


// PASAMOS A LA FUNCION restaEcc


restarEcc:

	// Restamos a la ecuacion a1 la ecuacion a0

	sub t0, a1, a0         // t0 guarda la diferencia de indices entre ambas ecc
	addi t1, s1, 1
	slli t1, t1, 2
	mul t0, t0, t1

	addi sp, sp, -8        // Apilamos ra y t0
	sw t0, 4(sp)
	sw ra, 0(sp)

	li a1, 0

	call calculaIndice     // Calculamos el indice del primer elemento de la ecuacion a0

	mv t1, a0              // t1 guarda el indice y lo apilamos
	add t1, t1, s2
	addi sp, sp, -4
	sw t1, 0(sp)

	li t2, 0               // i=0

	for_resta:

		blt s1, t2, fin_for_resta          // j si i>N

		lw t0, 8(sp)

		slli t3, t2, 2                     // i*4
		add t3, t3, t1                     // @a0[i]

		lw a0, 0(t3)                       // a0=a0[i]num
		add t3, t3, s4
		lw a1, 0(t3)                       // a1=a0[i]den
		sub t3, t3, s4
		add t3, t3, t0
		lw a2, 0(t3)                       // a2=a1[i]num
		add t3, t3, s4
		lw a3, 0(t3)                       // a3=a1[i]den

		mul t5, a1, a3
		sw t5, 0(t3)                       // a1[i]den*=a0[i]den

		addi sp, sp, -4                    // Apilamos i
		sw t2, 0(sp)

		call restaNumerador                // Calculamos el numerador

		lw t2, 0(sp)
		addi sp, sp, 4                     // Desapilamos i

		lw t1, 0(sp)
		slli t3, t2, 2                     // i*4
		add t3, t3, t1                     // @a0[i]
		lw t0, 8(sp)
		add t3, t3, t0                     // @ai[i]

		sw a0, 0(t3)                       // a1[i]num guardado

		addi t2, t2, 1                     // i++

		j for_resta

	fin_for_resta:

	lw ra, 4(sp)
	addi sp, sp, 12                    // Solo nos interesa desapilar ra

ret


// PASAMOS A LA FUNCION simplificaEcc


simplificaEcc:

	// a0 tiene el indice de la ecc

	mul a0, a0, s4    // @EccNum
	add a0, a0, s2

	li t4, 0          // j=0

	for_recorreEcc:

		blt s1, t4, fin_for_recorreEcc // j si j>N
		lw t5, 0(a0)                   // t5=EccNum[j]
		add a0, a0, s4
		lw t6, 0(a0)                   // t6=EccDen[j]
		sub a0, a0, s4

		li t0, 0          // i (se sumara de 4 en cuatro)
		add t2, t0, s5    // t2=@Primos[i]
		lw t1, 0(t2)      // t1=Primos[0]

		while_simplificaEcc:

			beq t1, zero, fin_while_simplificaEcc        // j si Primos[i]=0 (fin de la lista)

			if_simplificaEcc:     // EccNum[j] % Primos[i] == 0 && EccDen[j] % Primos[i] == 0

				rem t3, t5, t1
				bne t3, zero, else_simplificaEcc
				rem t3, t6, t1
				bne t3, zero, else_simplificaEcc

				div t5, t5, t1   // Ecc[j]/=Primos[i]
				div t6, t6, t1

				sw t5, 0(a0)                   // EccNum[j]=t5 (ya simplificado)
				add a0, a0, s4
				sw t6, 0(a0)                   // EccDen[j]=t6 (ya simplificado)
				sub a0, a0, s4

				li t0, 0                       // Volvemos a Primos[0]

				j fin_if_simplificaEcc

			else_simplificaEcc:   // Si no son divisibles por Primos[i]

				addi t0, t0, 4                 // i++ (4 para tener el indice exacto)

				j fin_if_simplificaEcc

			fin_if_simplificaEcc:

				add t2, t0, s5    // t2=@Primos[i]
				lw t1, 0(t2)      // t1=Primos[0]

				j while_simplificaEcc         // Volvemos a comprobar con el siguiente primo (o el primero si hemos podido simplificar)

		fin_while_simplificaEcc:

			addi t4, t4, 1    // j++
			addi a0, a0, 4    // Siguiente numero en la ecc.

		j for_recorreEcc

	fin_for_recorreEcc:

ret
