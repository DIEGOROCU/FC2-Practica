.global revisaEccCorrectas
.global ajustaCols
.global intercambiaCols

// PASAMOS A LA FUNCION revisaEccCorrectas

revisaEccCorrectas:

    // Void

	addi sp, sp, -4
	sw ra, 0(sp)

	li t0, 0         // i=0

	for_recorreCol:

		bge t0, s1, fin_for_recorreCol   // j si i>=N

		slli t1, t0, 2
		add t1, t1, s6
		lw t1, 0(t1)
		addi t1, t1, 1                   // j empieza con el siguiente numero

		while_col:

			while_noRepetir:

				mv a0, s6
				mv a1, t1
				mv a2, s1

				addi sp, sp, -8   // Apilamos, comprobamos y desapilamos
				sw t0, 0(sp)
				sw t1, 4(sp)
				call enArray
				lw t0, 0(sp)
				lw t1, 4(sp)
				addi sp, sp, 8

				beq a0, zero, if_yaEstaba
				j else_if_yaEstaba

				if_yaEstaba:   // Si ya estaba, pasamos al siguiente numero

				addi t1, t1, 1
				j while_noRepetir

				else_if_yaEstaba:   // Si no estaba, comprobamos si el numero correspondiente es 0

				j fin_while_noRepetir 																																												//Pablo ha estado aqui

			fin_while_noRepetir:

				bge t1, s1, if_noPosible    // j si hemos revisado toda la columna
				j else_if_noPosible        // j else

			if_noPosible:

				li t1, -1

				slli t2, t0, 2
				add t2, t2, s6
				sw t1, 0(t2)     // Guardamos un -1 (pasara a 0) en la columna ya revisada

				addi t0, t0, -1  // Pasamos a la anterior ecc

				j for_recorreCol // Volvemos

			else_if_noPosible:   // Sí es posible

				mv a0, t1         // Calculamos el indice del elemento i de la 1 ecc
				slli a0, a0, 1    // Multiplicamos para contar las ecc. de denominadores
				mv a1, t0

				addi sp, sp, -8   // Apilamos, calculamos y desapilamos
				sw t0, 0(sp)
				sw t1, 4(sp)
				call calculaIndice
				lw t0, 0(sp)
				lw t1, 4(sp)
				addi sp, sp, 8

				add a0, a0, s2   // @Real del elemento

				lw t2, 0(a0)

				beq t2, zero, if_igualCero   // Comprobamos si hay un 0

				j else_if_igualCero

			if_igualCero:        // Sí hay un 0

				addi t1, t1, 1
				j while_col      // Pasamos al siguiente numero de la columna

			else_if_igualCero:   // No hay un 0

				slli t2, t0, 2
				add t2, t2, s6
				sw t1, 0(t2)     // Guardamos la posicion del numero en Aux

				addi t0, t0, 1
				j for_recorreCol // Pasamos a la siguiente columna

		fin_while_col:

			j while_col

	fin_for_recorreCol:

	lw ra, 0(sp)
	addi sp, sp, 4   // Desapilamos


ret              // Ya terminado


// PASAMOS A LA FUNCION ajustaCols


ajustaCols:

// Void

li t0, 0   // i=0
mv t1, s6  // t1=@AuxCols

for_ajustaCols:

bge t0, s1, fin_for_ajustaCols   // j si i>=N

lw t2, 0(t1)       // AuxCols[i]

beq t0, t2, if_bienColocada   // j si ya esta bien colocada
j else_bienColocada           // Else (mal colocada)

if_bienColocada:

addi t1, t1, 4     // Siguiente @
addi t0, t0, 1     // i++
j for_ajustaCols

else_bienColocada:

mv a0, t0          // a0=t0 para buscar su posicion

addi sp, sp, -16   // Apilamos
sw ra, 0(sp)
sw t0, 4(sp)
sw t1, 8(sp)
sw t2, 12(sp)

call buscaCol      // Buscamos la col
slli a0, a0, 2
add a0, a0, s2     // @De la col mal colocada

lw a1, 4(sp)
slli a1, a1, 2
add a1, a1, s2     // @De la col mal colocada

call intercambiaCols   // Intercambiamos

lw ra, 0(sp)
lw t0, 4(sp)
lw t1, 8(sp)
lw t2, 12(sp)
addi sp, sp, 16    // Desapilamos

addi t1, t1, 4     // Siguiente @
addi t0, t0, 1     // i++

j for_ajustaCols

fin_for_ajustaCols:

ret


// PASAMOS A LA FUNCION intercambiaCols


intercambiaCols:

	// a0 y a1 tienen los @ de las cols. que vamos a intercambiar

	li t0, 0           // i=0
	mv t3, s1
	slli t3, t3, 1     // t3=2*N (para contar num. y den.)

	for_intercambiaCols:

		bge t0, s1, fin_for_intercambiaCols   // j si i>=2*N

		lw t1, 0(a0)
		lw t2, 0(a1)                          // Cargamos
		sw t2, 0(a0)
		sw t1, 0(a1)                          // Guardamos (intercambiando)
		add a0, a0, s4
		add a1, a1, s4                        // Pasamos a la siguiente fila
		addi t0, t0, 1                        // i++

		j for_intercambiaCols

	fin_for_intercambiaCols:

ret


// PASAMOS A LA FUNCION buscaCol


buscaCol:

	// a0 tiene la col buscada

	li t0, 0   // i=0
	mv t1, s6  // t1=@AuxCols

	for_buscaCol:

		bge t0, s1, fin_for_buscaCol   // j si i>=N

		lw t2, 0(t1)
		beq a0, t2, fin_for_buscaCol   // j si AuxCols[i]=a0
		addi t1, t1, 4                 // Siguiente elemento de AuxCols
		addi t0, t0, 1                 // i++

		j for_buscaCol

	fin_for_buscaCol:

	mv a0, t0                      // a0=poscion de la col. buscada en AuxCols

ret
