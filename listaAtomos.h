#include<stdio.h>
#include<stdlib.h>

//Esta biblioteca sirve para poder implementar: la cadena de atomos
FILE *listaAto;

//El nodo de reservadas, tiene solo el miembro atomo
typedef struct NodoA{
    char* atomo; //apuntador a un char
    struct NodoA* next; //apuntador al siguiente
}NodoA;

typedef struct{
	struct NodoA* head;
}ListaAtomos;

ListaAtomos crearListaA();
void print_listA(ListaAtomos);  
void addFinalListaA(ListaAtomos*,char*);
int BuscarElementoA(ListaAtomos,char*);
NodoA siguienteNodo(ListaAtomos lista);

ListaAtomos crearListaA(){
	ListaAtomos lista;
	lista.head = NULL;
	return lista;
}

//La funcion crea un archivo llamado Atomos.txt el cual contendra los caracteres de la cadena esto mediante 
//una iteracion por todos los nodos, y escribiendo los datos que corresponden al nodo en el archivo
void print_listA(ListaAtomos lista) {
    if(lista.head==NULL){
    }
    else{
		listaAto = fopen("Tablas/Atomos.txt","w");
		if(listaAto== NULL){
			printf("Error al abrir el archivo");   
			exit(1);             
		}
    	NodoA *current = lista.head;
		fprintf(listaAto,"Cadena de atomos:\n");
   		while (current != 0) {
			fprintf(listaAto,"%s",current->atomo);
			current = current->next;
   	 	}
	}
}

//La funcion inserta los valores del nodoA en base a si esta vacia la lista, o si contiene elementos, se busca
//el ultimo y se inserta en la ultima posicion.
void addFinalListaA(ListaAtomos *lista,char atomo[]){
	if(lista->head==NULL){
		NodoA *nodo = (NodoA*)malloc(sizeof(NodoA));
        nodo->atomo = atomo;
    	nodo->next = NULL;
    	lista->head = nodo;
	}	
	else{
		NodoA *current = lista->head;
		while (current->next != 0) {
       		current = current->next;
 		}
		NodoA *nuevoNodo;
		nuevoNodo = (NodoA*)malloc(sizeof(NodoA));
        nuevoNodo->atomo = atomo;
    	nuevoNodo->next = NULL;
 		current->next = nuevoNodo;
	}	
}

//La funcion itera sobre la tabla de palabras reservada y de operadores relacionales.
//en este caso no se comprueba si inicialmente esta vacia ya que es seguro que por lo menos contendra un nodoR
int BuscarElementoA(ListaAtomos Lista,char atomo[]){
	NodoA *Temp=Lista.head;
	while(Temp->next!=NULL){
		if (strcmp(Temp->atomo,atomo)==0){
			return 1;
		}
		else{
			Temp=Temp->next;
		}
	}
    if (strcmp(Temp->atomo,atomo)==0){
		return 1;
	}
	return -1;
}

NodoA siguienteNodo(ListaAtomos lista){
    if(lista.head==NULL){
    }
    else{
		listaAto = fopen("Tablas/Atomos.txt","w");
		if(listaAto== NULL){
			printf("Error al abrir el archivo");   
			exit(1);             
		}
    	NodoA *current = lista.head;
//		fprintf(listaAto,"Cadena de atomos:\n");
   		//while (current != 0) {
			//fprintf(listaAto,"%s",current->atomo);
			current = current->next;
            return *current;
        //}
	}
}

