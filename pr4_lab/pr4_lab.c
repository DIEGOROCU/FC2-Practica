/*---------------------------------------------------------------------
**
**  Fichero:
**    pr4_lab.c  19/10/2022
**
**    (c) Daniel Báscones García
**    Fundamentos de Computadores II
**    Facultad de Informática. Universidad Complutense de Madrid
**
**  Propósito:
**    Fichero de código para la práctica 4_lab
**
**-------------------------------------------------------------------*/

extern int mul (int a , int b);
extern int i_sqrt (int a);

/**
* Funci ón que guarda un valor en el puntero proporcionado
*/
void guardar ( char valor , char * ubicacion) {
* ubicacion = valor ;
}



/**
* Calculamos distancia eucl í dea . Sumamos todos los cuadrados
* y terminamos sacando la raíz cuadrada ( entera )
*/
int eucl_dist (int w [] , int size ) {
int acc = 0;
for ( int i = 0; i < size ; i ++) {
acc += mul (w[ i] , w[ i ]) ;
}
return i_sqrt ( acc );
}
