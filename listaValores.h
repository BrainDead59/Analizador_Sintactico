#include<stdio.h>
#include<stdlib.h>

//valores reales
FILE *listaFlot;

typedef struct NodoV{
    int posicion;
    float valor;
    struct NodoV* next;
}NodoV;

typedef struct{
	struct NodoV* head;
}ListaValores;

ListaValores crearListaV();
void print_listV(ListaValores);  
void addFinalListaV(ListaValores*,int,float);


ListaValores crearListaV(){
	ListaValores lista;
	lista.head = NULL;
	return lista;
}

//La funcion crea un archivo llamado Constantes.txt el cual contendra la posicion y valor esto mediante 
//una iteracion por todos los nodos, y escribiendo los datos que corresponden al nodo en el archivo
void print_listV(ListaValores lista) {
    if(lista.head==NULL){
    }
    else{
    	listaFlot=fopen("Tablas/Constantes.txt","w");
		if(listaFlot == NULL){
			printf("Error al abrir el archivo");    
			exit(1);             
		}
		NodoV *current = lista.head;
		fprintf(listaFlot,"Posicion Valor\n");
   		while (current != 0) {
			fprintf(listaFlot,"%d  %f\n",current->posicion,current->valor);
			current = current->next;
   	 	}
	}
}

//La funcion inserta los valores del nodoV en base a si esta vacia la lista, o si contiene elementos, se busca
//el ultimo y se inserta en la ultima posicion.
void addFinalListaV(ListaValores *lista,int posicion,float valor) {
	if(lista->head==NULL){
		NodoV *nodo = (NodoV*)malloc(sizeof(NodoV));
		nodo->valor = valor;
        nodo->posicion = posicion;
    	nodo->next = NULL;
    	lista->head = nodo;
	}	
	else{
		NodoV *current = lista->head;
		while (current->next != 0) {
       		current = current->next;
 		}
		NodoV *nuevoNodo;
		nuevoNodo = (NodoV*)malloc(sizeof(NodoV));
    	nuevoNodo->valor = valor;
        nuevoNodo->posicion = posicion;
    	nuevoNodo->next = NULL;
 		current->next = nuevoNodo;
	}	
}



