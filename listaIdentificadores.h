#include<stdio.h>
#include<stdlib.h>

//Esta biblioteca sirve para poder implementar: Identificadores
FILE *listaIdent;

//El nodo de identificadores, tiene los miembros posicion, identificador y tipo.
typedef struct NodoI{
    int posicion;
    char* identificador;
    int tipo;
    struct NodoI* next;
}NodoI;

typedef struct{
	struct NodoI* head;
}ListaIdentificadores;

ListaIdentificadores crearListaI();
void print_listI(ListaIdentificadores);  
void addFinalListaI(ListaIdentificadores*,int,char*);
int BuscarElementoI(ListaIdentificadores, char*);

ListaIdentificadores crearListaI(){
	ListaIdentificadores lista;
	lista.head = NULL;
	return lista;
}

//La funcion crea un archivo llamado Identificadores.txt el cual contendra la posicion, identificador y tipo
//esto mediante una iteracion por todos los nodos, y escribiendo los datos que corresponden al nodo en el archivo
void print_listI(ListaIdentificadores lista) {
    if(lista.head==NULL){
    }
    else{
    	listaIdent = fopen("Tablas/Identificadores.txt","w");
		if(listaIdent == NULL){
			printf("Error al abrir el archivo");    
			exit(1);             
		}
		NodoI *current = lista.head;
		fprintf(listaIdent,"Posicion  Identificador  Tipo\n");
   		while (current != 0) {
			fprintf(listaIdent,"%d %s %d\n",current->posicion,current->identificador,current->tipo);
			current = current->next;
   	 	}
	}
}

//La funcion inserta los valores del nodoI en base a si esta vacia la lista, o si contiene elementos, se busca
//el ultimo y se inserta en la ultima posicion.
void addFinalListaI(ListaIdentificadores *lista,int posicion,char palabra[]){
	if(lista->head==NULL){
		NodoI *nodo = (NodoI*)malloc(sizeof(NodoI));
		nodo->posicion = posicion;
        nodo->identificador = palabra;
		nodo->tipo=-1;
    	nodo->next = NULL;
    	lista->head = nodo;
	}else{
		NodoI *current = lista->head;
		while (current->next != 0) {
       		current = current->next;
 		}
		NodoI *nuevoNodo;
		nuevoNodo = (NodoI*)malloc(sizeof(NodoI));
    	nuevoNodo->posicion = posicion;
        nuevoNodo->identificador = palabra;
		nuevoNodo->tipo=-1;
    	nuevoNodo->next = NULL;
 		current->next = nuevoNodo;
	}	
}

//La funcion verifica si la lista contiene elementos ya que en las primeras iteraciones puede estar vacia 
//ya que comprueba la existencia del identificador antes de insertarlo, y hace una busqueda lineal.
int BuscarElementoI(ListaIdentificadores Lista, char palabra[]){
	NodoI *Temp=Lista.head;
	if(Temp==NULL){
		return -1;
	}else{
		while(Temp->next!=NULL){
			if (strcmp(Temp->identificador,palabra)==0){
				return Temp->posicion;
			}
			else{
				Temp=Temp->next;
			}
		}
		if (strcmp(Temp->identificador,palabra)==0){
			return Temp->posicion;
		}
		return -1;
	}
}



