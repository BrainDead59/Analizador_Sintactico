#include<stdio.h>
#include<stdlib.h>

//Esta biblioteca sirve para poder implementar: Tokens.
FILE *listaTok;

//El nodo de tokens, tiene los miembros clase y valor
typedef struct NodoT{
    int clase;
    long int val;
    struct NodoT* next;
}NodoT;

typedef struct{
	struct NodoT* head;
}ListaTokens;

ListaTokens crearListaT();
void print_listT(ListaTokens);  
void addFinalListaT(ListaTokens*,int,int);


ListaTokens crearListaT(){
	ListaTokens lista;
	lista.head = NULL;
	return lista;
}

//La funcion crea un archivo llamado Tokens.txt el cual contendra la clase y valor esto mediante 
//una iteracion por todos los nodos, y escribiendo los datos que corresponden al nodo en el archivo
void print_listT(ListaTokens lista) {
    if(lista.head==NULL){
    }
    else{
    	listaTok=fopen("Tablas/Tokens.txt","w");
		if(listaTok == NULL){
			printf("Error al abrir el archivo");    
			exit(1);             
		}
		NodoT *current = lista.head;
		fprintf(listaTok,"Clase Valor\n");
   		while (current != 0) {
			fprintf(listaTok,"%d     %ld\n",current->clase,current->val);
			current = current->next;
   	 	}
	}
}

//La funcion inserta los valores del nodoT en base a si esta vacia la lista, o si contiene elementos, se busca
//el ultimo y se inserta en la ultima posicion.
void addFinalListaT(ListaTokens *lista, int clase,int val) {
	if(lista->head==NULL){
		NodoT *nodo = (NodoT*)malloc(sizeof(NodoT));
		nodo->val = val;
        nodo->clase = clase;
    	nodo->next = NULL;
    	lista->head = nodo;
	}	
	else{
		NodoT *current = lista->head;
		while (current->next != 0) {
       		current = current->next;
 		}
		NodoT *nuevoNodo;
		nuevoNodo = (NodoT*)malloc(sizeof(NodoT));
    	nuevoNodo->val = val;
        nuevoNodo->clase = clase;
    	nuevoNodo->next = NULL;
 		current->next = nuevoNodo;
	}	
}





