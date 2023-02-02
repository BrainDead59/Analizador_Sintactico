#include<stdio.h>
#include<stdlib.h>

//Esta biblioteca sirve para poder implementar: Palabras reservadas, operadores, cadenas y errores.
FILE *listaCad;

//El nodo de reservadas, tiene los miembros posicion y palabra.
typedef struct NodoR{
    int posicion;
    char* palabra;
    struct NodoR* next;
}NodoR;

typedef struct{
	struct NodoR* head;
}ListaReservadas;

ListaReservadas crearListaR();
void print_listR(ListaReservadas); 
void print_listER(ListaReservadas); 
void addFinalListaR(ListaReservadas*,int,char*);
void addFinalListaER(ListaReservadas*,int,char*);
int BuscarElementoR(ListaReservadas,char*);


ListaReservadas crearListaR(){
	ListaReservadas lista;
	lista.head = NULL;
	return lista;
}

//La funcion crea un archivo llamado Cadenas.txt el cual contendra la posicion y cadena esto mediante 
//una iteracion por todos los nodos, y escribiendo los datos que corresponden al nodo en el archivo
void print_listR(ListaReservadas lista) {
    if(lista.head==NULL){
    }
    else{
		listaCad = fopen("Tablas/Cadenas.txt","w");
		if(listaCad == NULL){
			printf("Error al abrir el archivo");   
			exit(1);             
		}
    	NodoR *current = lista.head;
		fprintf(listaCad,"Posicion  Cadena\n");
   		while (current != 0) {
			fprintf(listaCad,"%d %s \n",current->posicion,current->palabra);
			current = current->next;
   	 	}
	}
}

//La funcion crea un archivo llamado Errores.txt el cual contendra la posicion y el error esto mediante 
//una iteracion por todos los nodos, y escribiendo el valor que corresponde al nodo en el archivo
void print_listER(ListaReservadas lista) {
    if(lista.head==NULL){
    }
    else{
		listaCad = fopen("Tablas/Errores.txt","w");
		if(listaCad == NULL){
			printf("Error al abrir el archivo"); 
			exit(1);             
		}
		fprintf(listaCad,"Posicion  Error\n");
    	NodoR *current = lista.head;
   		while (current != 0){
			fprintf(listaCad,"%d %s \n",current->posicion,current->palabra);
			current = current->next;
   	 	}
	}
}

//La funcion inserta los valores del nodoR en base a si esta vacia la lista, o si contiene elementos, se busca
//el ultimo y se inserta en la ultima posicion.
void addFinalListaR(ListaReservadas *lista,int posicion,char palabra[]) {
	if(lista->head==NULL){
		NodoR *nodo = (NodoR*)malloc(sizeof(NodoR));
		nodo->posicion = posicion;
        nodo->palabra = palabra;
    	nodo->next = NULL;
    	lista->head = nodo;
	}	
	else{
		NodoR *current = lista->head;
		while (current->next != 0) {
       		current = current->next;
 		}
		NodoR *nuevoNodo;
		nuevoNodo = (NodoR*)malloc(sizeof(NodoR));
    	nuevoNodo->posicion = posicion;
        nuevoNodo->palabra = palabra;
    	nuevoNodo->next = NULL;
 		current->next = nuevoNodo;
	}	
}

//La funcion itera sobre la tabla de palabras reservadas y de operadores relacionales.
//en este caso no se comprueba si inicialmente esta vacia ya que es seguro que por lo menos contendra un nodoR
int BuscarElementoR(ListaReservadas Lista, char palabra[]){
	NodoR *Temp=Lista.head;
	while(Temp->next!=NULL){
		if (strcmp(Temp->palabra,palabra)==0){
			return Temp->posicion;
		}
		else{
			Temp=Temp->next;
		}
	}
    if (strcmp(Temp->palabra,palabra)==0){
		return Temp->posicion;
	}
	return -1;
}



