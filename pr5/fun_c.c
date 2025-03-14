/*---------------------------------------------------------------------
**
**  Fichero:
**    fun_c.c  19/10/2022
**
**    (c) Daniel Báscones García
**    Fundamentos de Computadores II
**    Facultad de Informática. Universidad Complutense de Madrid
**
**  Propósito:
**    Fichero de código para la práctica 5_lab
**
**-------------------------------------------------------------------*/

#define N 3

int restaNumerador (int Anum, int Bnum, int Aden, int Bden){
	return (Anum*Bden) - (Aden*Bnum);
}

int calculaIndice (int ecc, int i){

	ecc *= 4*(N+1);
	ecc += i*4;

	return ecc;

}

int enArray (int *V, int num, int taMax){

	for (int i = 0; i < taMax; i++){
		if (*V == num){
			return 0;
		}
		V++;
	}

	return 1;

}
