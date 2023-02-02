%{
/*Basado en el valor del case se tendra que determinar cual es la clase
Tablas necesarias:
    -Tabla Tokens: clase-valor
    -Palabras reservadas: valor-palabra
    -Operadores: valor-operador
    -Tabla de identicadores: posicion-nombre-tipo(-1) 
    -Tabla de cadenas: posicion-cadena
    -Tabla de valores: posicion-valor --int or float

Errores:
    -Continuar la lectura con el siguiente elemento
    -Guardar los errores

Archivos:
    -Tablas de simbolos, cadenas, valores y tokens
    -Errores    
*/
#include "listaIdentificadores.h"
#include "listaReservadas.h"
#include "listaTokens.h"
#include "listaValores.h"
#include "listaAtomos.h"
#include <sys/stat.h>
#include <sys/types.h>
#include <string.h>


%}

dig [0-9]
let [a-zA-Z]
digSinCero [1-9]

%%

"alternative"|"big"|"evaluate"|"instead"|"large"|"loop"|"make"|"number"|"other"|"real"|"repeat"|"select"|"small"|"step"|"stop"|"symbol"|"throw" {return 1;}
\${let}+ 				{return 2;}
{dig}+ 					{return 3;}
(digSinCero{dig}*)|"0"  {return 3;}
(o|O)[0-7]+ 			{return 3;}
{dig}*\.{dig}+			{return 4;}
[\[\](){},:;]           {return 6;}
[+\-*/%\\\^]            {return 7;}
"<"|">"|"<="|">="|"=="|"!=" {return 8;}
"=" {return 9;}
(\“[^'“”]+\”)|(\'[^'“”]\')|(““'””)|(\'\“\')|(\'\”\')	{return 5;}
("//"(.)*)|("/*"[^*/]*"*/") {return 11;}
[^ \n\t] {return 10;}

%%

//Prototipos de las funciones de las gramaticas
NodoA* A(NodoA*);
NodoA* AP(NodoA*);
NodoA* C(NodoA*);
NodoA* CP(NodoA*);
NodoA* D(NodoA*);
NodoA* E(NodoA*);
NodoA* EP(NodoA*);
NodoA* F(NodoA*);
NodoA* H(NodoA*);
NodoA* I(NodoA*);
NodoA* IP(NodoA*);
NodoA* J(NodoA*);
NodoA* K(NodoA*);
NodoA* N(NodoA*);
NodoA* OP(NodoA*);
NodoA* P(NodoA*);
NodoA* Q(NodoA*);
NodoA* R(NodoA*);
NodoA* RP(NodoA*);
NodoA* T(NodoA*);
NodoA* TP(NodoA*);
NodoA* U(NodoA*);
NodoA* V(NodoA*);
NodoA* VP(NodoA*);
NodoA* VPP(NodoA*);
NodoA* VPPP(NodoA*);
NodoA* W(NodoA*);
NodoA* X(NodoA*);
NodoA* Y(NodoA*);
NodoA* Z(NodoA*);
NodoA* Tipo(NodoA*);
NodoA* Decl(NodoA*);
NodoA* arg(NodoA*);
NodoA* Llama(NodoA*);
NodoA* Param(NodoA*);
NodoA* valor(NodoA*);
NodoA* listaP(NodoA*);
NodoA* Cuerpo(NodoA*);
NodoA* funcion(NodoA*);
NodoA* otroArg(NodoA*);
NodoA* Devuelve(NodoA*);
NodoA* programa(NodoA*);
NodoA* otroParam(NodoA*);
NodoA* otraFuncion(NodoA*);
void parser(ListaAtomos);


//La funcion convierte de octal a decimal, para poder guardar el valor del entero
long int obtenerDecimal(char yytext[]){
    int i;
    char octal[strlen(yytext)-1];
    for(i=0;i<strlen(yytext);i++){
        octal[i]=yytext[i+1];
    }

    int octalDecimal=atoi(octal);
    
    long int decimal=0;
    int base=1;
    int temp=octalDecimal;
    while(temp){
        int lastdigit=temp%10;
        temp=temp/10;
        decimal+=lastdigit*base;
        base=base*8;
    }
    return decimal;
}


//Mediante la funcion se llenan las tablas de palabras reservadas y de operadores.
void llenadoTablas(ListaReservadas* listaPalabras, ListaReservadas* listaOperadores){
    addFinalListaR(listaPalabras,0,"alternative");
    addFinalListaR(listaPalabras,1,"big");
    addFinalListaR(listaPalabras,2,"evaluate");
    addFinalListaR(listaPalabras,3,"instead");
    addFinalListaR(listaPalabras,4,"large");
    addFinalListaR(listaPalabras,5,"loop");
    addFinalListaR(listaPalabras,6,"make");
    addFinalListaR(listaPalabras,7,"number");
    addFinalListaR(listaPalabras,8,"other");
    addFinalListaR(listaPalabras,9,"real");
    addFinalListaR(listaPalabras,10,"repeat");
    addFinalListaR(listaPalabras,11,"select");
    addFinalListaR(listaPalabras,12,"small");
    addFinalListaR(listaPalabras,13,"step");
    addFinalListaR(listaPalabras,14,"stop");
    addFinalListaR(listaPalabras,15,"symbol");
    addFinalListaR(listaPalabras,16,"throw");

    addFinalListaR(listaOperadores,0,"<");
    addFinalListaR(listaOperadores,1,">");
    addFinalListaR(listaOperadores,2,"<=");
    addFinalListaR(listaOperadores,3,">=");
    addFinalListaR(listaOperadores,4,"==");
    addFinalListaR(listaOperadores,5,"!=");
}

//Con la funcion yywrap se detiene la lectura del documento
int yywrap(void) {
	return 1;
}

/*
Se realizar la funcion main para poder realizar la lectura del documento y la creacion de cada una de las
listas, para crearlas se importarn los headers donde esta la implementacion para cada una de las tablas necesarias.
*/
int main(int argc, char *argv[]){
	yyin = fopen(argv[1], "r");
	int opcion;
    ListaReservadas listaPalabras=crearListaR();
    ListaReservadas listaCadenas=crearListaR();
    ListaReservadas listaOperadores=crearListaR();
    ListaReservadas listaErrores=crearListaR();
    ListaTokens listaTokens=crearListaT();
    ListaValores listaConstantes=crearListaV();
    ListaIdentificadores listaIdentificadores =crearListaI();
    ListaAtomos listaAtomos=crearListaA();

    llenadoTablas(&listaPalabras,&listaOperadores);

    /*
    La funcion obtiene el token que se analizo con las expresiones, y en base a la clase realizar las operaciones
    que corresponden, siendo la clase 0 la 1, la 1 la 2, y asi sucesivamente.
    */
    int posicion,posicionCadena=0,posicionValor=0,errores=0,posicionIdent=0;
    char *token;
    while((opcion=yylex())!=0){
        switch(opcion){
            //Palabras reservadas
            case 1:
                posicion=BuscarElementoR(listaPalabras,yytext);
                addFinalListaT(&listaTokens,0,posicion);

                token=malloc(strlen(yytext)+1);
                strcpy(token,yytext);
                if(strcmp(token,"alternative")==0){
                    addFinalListaA(&listaAtomos,"a");
                }
                if(strcmp(token,"big")==0){
                    addFinalListaA(&listaAtomos,"b");
                }
                if(strcmp(token,"evaluate")==0){
                    addFinalListaA(&listaAtomos,"f");
                }
                if(strcmp(token,"instead")==0){
                    addFinalListaA(&listaAtomos,"t");
                }
                if(strcmp(token,"large")==0){
                    addFinalListaA(&listaAtomos,"g");
                }
                if(strcmp(token,"loop")==0){
                    addFinalListaA(&listaAtomos,"w");
                }
                if(strcmp(token,"make")==0){
                    addFinalListaA(&listaAtomos,"m");
                }
                if(strcmp(token,"number")==0){
                    addFinalListaA(&listaAtomos,"#");
                }
                if(strcmp(token,"other")==0){
                    addFinalListaA(&listaAtomos,"o");
                }
                if(strcmp(token,"real")==0){
                    addFinalListaA(&listaAtomos,"x");
                }
                if(strcmp(token,"repeat")==0){
                    addFinalListaA(&listaAtomos,"j");
                }
                if(strcmp(token,"select")==0){
                    addFinalListaA(&listaAtomos,"h");
                }
                if(strcmp(token,"small")==0){
                    addFinalListaA(&listaAtomos,"p");
                }
                if(strcmp(token,"step")==0){
                    addFinalListaA(&listaAtomos,"c");
                }
                if(strcmp(token,"stop")==0){
                    addFinalListaA(&listaAtomos,"q");
                }
                if(strcmp(token,"symbol")==0){
                    addFinalListaA(&listaAtomos,"y");
                }
                if(strcmp(token,"throw")==0){
                    addFinalListaA(&listaAtomos,"z");
                }
            break;

            //identicadores
            case 2:
                token=malloc(strlen(yytext)+1);
                strcpy(token,yytext);
                posicion=BuscarElementoI(listaIdentificadores,yytext);
                if(posicion==-1){
                    addFinalListaI(&listaIdentificadores,posicionIdent,token);
                    addFinalListaT(&listaTokens,1,posicionIdent);
                    addFinalListaA(&listaAtomos,"i");
                    posicionIdent++;
                    
                }else{
                    addFinalListaT(&listaTokens,1,posicion);
                    addFinalListaA(&listaAtomos,"i");
                }
            break;

            //Constantes numericas enteras y octales
            case 3:
                if(yytext[0]=='O' || yytext[0]=='o'){
                    long int decimal=obtenerDecimal(yytext);
                    addFinalListaT(&listaTokens,2,decimal);
                    addFinalListaA(&listaAtomos,"n");
                }else{
                    addFinalListaT(&listaTokens,2,atoi(yytext));
                    addFinalListaA(&listaAtomos,"n");
                }
            break;

            //Constantes numericas reales
            case 4:
                addFinalListaV(&listaConstantes,posicionValor,atof(yytext));
                addFinalListaT(&listaTokens,3,posicionValor);
                addFinalListaA(&listaAtomos,"r");
                posicionValor++;
            break;

            //Cadenas
            case 5:
                token=malloc(strlen(yytext)+1);
                strcpy(token,yytext);
                addFinalListaR(&listaCadenas,posicionCadena,token);
                addFinalListaT(&listaTokens,4,posicionCadena);
                addFinalListaA(&listaAtomos,"s");
                posicionCadena++;
            break;

            //Simbolos especiales
            case 6:
                addFinalListaT(&listaTokens,5,(int)*yytext);

                token=malloc(strlen(yytext)+1);
                strcpy(token,yytext);
                addFinalListaA(&listaAtomos,token);
            break;

            //Operadores aritmeticos
            case 7:
                addFinalListaT(&listaTokens,6,(int)*yytext);

                token=malloc(strlen(yytext)+1);
                strcpy(token,yytext);
                addFinalListaA(&listaAtomos,token);
            break;

            //Operadores relacionales
            case 8:
                posicion=BuscarElementoR(listaOperadores,yytext);
                addFinalListaT(&listaTokens,7,posicion);

                token=malloc(strlen(yytext)+1);
                strcpy(token,yytext);
                if(strcmp(token,"<")==0){
                    addFinalListaA(&listaAtomos,"<");
                }
                if(strcmp(token,">")==0){
                    addFinalListaA(&listaAtomos,">");
                }
                if(strcmp(token,"<=")==0){
                    addFinalListaA(&listaAtomos,"l");
                }
                if(strcmp(token,">=")==0){
                    addFinalListaA(&listaAtomos,"u");
                }
                if(strcmp(token,"==")==0){
                    addFinalListaA(&listaAtomos,"e");
                }
                if(strcmp(token,"!=")==0){
                    addFinalListaA(&listaAtomos,"d");
                }
            break;

            //Operador asignacion
            case 9:
                addFinalListaT(&listaTokens,8,(int)*yytext);
                addFinalListaA(&listaAtomos,"=");
            break;

            //Errores
            case 10:
                token=malloc(strlen(yytext)+1);
                strcpy(token,yytext);
                addFinalListaR(&listaErrores,errores,token);
                errores++;
            break;

            //Comentarios
            default:
            break;
        }
    }
    //Se imprimen cada una de las tablas en su correspondiente archivo y se crea un directorio para poder
    //visualizar con mayor facilidad cada una
    int result = mkdir("Tablas", 0777);
    print_listT(listaTokens);
    print_listER(listaErrores);
    print_listR(listaCadenas);
    print_listV(listaConstantes);
    print_listI(listaIdentificadores);

    //Insercion del simbolo final
    addFinalListaA(&listaAtomos,"⊣");
    print_listA(listaAtomos);


    parser(listaAtomos);
	return 0;
}

NodoA* Tipo(NodoA* caracter){
    if((strcmp(caracter->atomo,"b")==0)||(strcmp(caracter->atomo,"g")==0)||(strcmp(caracter->atomo,"#")==0)||(strcmp(caracter->atomo,"y")==0)||(strcmp(caracter->atomo,"x")==0)){
        caracter=caracter->next;
    }

    return caracter;
}

NodoA* otroArg(NodoA* caracter){
    if((strcmp(caracter->atomo,",")==0)){
        caracter=caracter->next;
        caracter=V(caracter);
        caracter=otroArg(caracter);
    }else if((strcmp(caracter->atomo,")")==0)){
        return caracter;
    }
    return caracter;
}

NodoA* arg(NodoA* caracter){
    if((strcmp(caracter->atomo,"i")==0)||(strcmp(caracter->atomo,"n")==0)||(strcmp(caracter->atomo,"r")==0)||(strcmp(caracter->atomo,"s")==0)){
        caracter=V(caracter);
        caracter=otroArg(caracter);
    }else if((strcmp(caracter->atomo,")")==0)){
        return caracter;
    }
    return caracter;
}

NodoA* Llama(NodoA* caracter){
    if((strcmp(caracter->atomo,"[")==0)){
        caracter=caracter->next;
        if((strcmp(caracter->atomo,"i")==0)){
            caracter=caracter->next;
            if((strcmp(caracter->atomo,"(")==0)){
                caracter=caracter->next;
                caracter=arg(caracter);
                if((strcmp(caracter->atomo,")")==0)){
                    caracter=caracter->next;
                    if((strcmp(caracter->atomo,"]")==0)){
                        caracter=caracter->next;
                    }
                }
            }
        }
    }
    return caracter;
}

NodoA* valor(NodoA* caracter){
    if((strcmp(caracter->atomo,"i")==0)||(strcmp(caracter->atomo,"n")==0)||(strcmp(caracter->atomo,"r")==0)||(strcmp(caracter->atomo,"s")==0)){
        caracter=V(caracter);
    }else if((strcmp(caracter->atomo,")")==0)){
        return caracter;
    }
    return caracter;
}

NodoA* Devuelve(NodoA* caracter){
    if((strcmp(caracter->atomo,"z")==0)){
        caracter=caracter->next;
        if((strcmp(caracter->atomo,"(")==0)){
            caracter=caracter->next;
            caracter=valor(caracter);
            if((strcmp(caracter->atomo,")")==0)){
                caracter=caracter->next;
                if((strcmp(caracter->atomo,";")==0)){
                    caracter=caracter->next;
                }
            }
        }
    }
    return caracter;
}

NodoA* U(NodoA* caracter){
    if((strcmp(caracter->atomo,"q")==0)){
        caracter=caracter->next;
    }else if((strcmp(caracter->atomo,"}")==0)){
        caracter=caracter->next;
        if((strcmp(caracter->atomo,"a")==0)){
            caracter=caracter->next;
            if((strcmp(caracter->atomo,"o")==0)){
                caracter=caracter->next;
                return caracter;
            }
        }
    }
    return caracter;
}

NodoA* OP(NodoA* caracter){
    if((strcmp(caracter->atomo,"o")==0)){
        caracter=caracter->next;
        if((strcmp(caracter->atomo,":")==0)){
            caracter=caracter->next;
            caracter=listaP(caracter);
        }
    }else if((strcmp(caracter->atomo,"}")==0)){
        return caracter;
    }
    return caracter;
}

NodoA* CP(NodoA* caracter){
    if((strcmp(caracter->atomo,"a")==0)){
        caracter=caracter->next;
        if((strcmp(caracter->atomo,"n")==0)){
            caracter=caracter->next;
            if((strcmp(caracter->atomo,":")==0)){
                caracter=caracter->next;
                caracter=listaP(caracter);
                caracter=U(caracter);
                caracter=CP(caracter);
            }
        }
    }else if((strcmp(caracter->atomo,"}")==0)){
        caracter=caracter->next;
        if((strcmp(caracter->atomo,"o")==0)){
            caracter=caracter->next;
            return caracter;
        }
    }
    return caracter;
}

NodoA* H(NodoA* caracter){
    if((strcmp(caracter->atomo,"h")==0)){
        caracter=caracter->next;
        if((strcmp(caracter->atomo,"(")==0)){
            caracter=caracter->next;
            if((strcmp(caracter->atomo,"i")==0)){
                caracter=caracter->next;
                if((strcmp(caracter->atomo,")")==0)){
                    caracter=caracter->next;
                    if((strcmp(caracter->atomo,"{")==0)){
                        caracter=caracter->next;
                        caracter=CP(caracter);
                        caracter=OP(caracter);
                        if((strcmp(caracter->atomo,"}")==0)){
                            caracter=caracter->next;
                        }
                    }
                }
            }
        }
    }
    return caracter;
}

NodoA* Z(NodoA* caracter){
    if((strcmp(caracter->atomo,"i")==0)){
        caracter=caracter->next;
        if((strcmp(caracter->atomo,"=")==0)){
            caracter=caracter->next;
            caracter=E(caracter);
            if((strcmp(caracter->atomo,")")==0)){
                caracter=caracter->next;
            }
        }
    }else if((strcmp(caracter->atomo,")")==0)){
        caracter=caracter->next;
    }
    return caracter;
}

NodoA* X(NodoA* caracter){
    if((strcmp(caracter->atomo,"i")==0)||(strcmp(caracter->atomo,"n")==0)||(strcmp(caracter->atomo,"r")==0)||(strcmp(caracter->atomo,"s")==0)){
        caracter=R(caracter);
        if((strcmp(caracter->atomo,";")==0)){
            caracter=caracter->next;
        }
    }else if((strcmp(caracter->atomo,";")==0)){
        caracter=caracter->next;
    }
    return caracter;
}

NodoA* Y(NodoA* caracter){
    if((strcmp(caracter->atomo,"i")==0)){
        caracter=caracter->next;
        if((strcmp(caracter->atomo,"=")==0)){
            caracter=caracter->next;
            caracter=E(caracter);
            if((strcmp(caracter->atomo,";")==0)){
                caracter=caracter->next;
            }
        }
    }else if((strcmp(caracter->atomo,";")==0)){
        caracter=caracter->next;
    }
    return caracter;
}

NodoA* J(NodoA* caracter){
    if((strcmp(caracter->atomo,"j")==0)){
        caracter=caracter->next;
        if((strcmp(caracter->atomo,"(")==0)){
            caracter=caracter->next;
            caracter=Y(caracter);
            caracter=X(caracter);
            caracter=Z(caracter);
            if((strcmp(caracter->atomo,"{")==0)){
                caracter=caracter->next;
                caracter=listaP(caracter);
                if((strcmp(caracter->atomo,"}")==0)){
                    caracter=caracter->next;
                }
            }
        }
    }
    return caracter;
}

NodoA* IP(NodoA* caracter){
    if((strcmp(caracter->atomo,"t")==0)){
        caracter=caracter->next;
        caracter=listaP(caracter);
    }else if((strcmp(caracter->atomo,":")==0)){
        return caracter;
    }
    return caracter;
}

NodoA* I(NodoA* caracter){
    if((strcmp(caracter->atomo,"f")==0)){
        caracter=caracter->next;
        if((strcmp(caracter->atomo,"(")==0)){
            caracter=caracter->next;
            caracter=R(caracter);
            if((strcmp(caracter->atomo,")")==0)){
                caracter=caracter->next;
                caracter=listaP(caracter);
                caracter=IP(caracter);
                if((strcmp(caracter->atomo,":")==0)){
                    caracter=caracter->next;
                }
            }
        }
    }
    return caracter;
}

NodoA* W(NodoA* caracter){
    if((strcmp(caracter->atomo,"w")==0)){
        caracter=caracter->next;
        if((strcmp(caracter->atomo,"(")==0)){
            caracter=caracter->next;
            caracter=R(caracter);
            if((strcmp(caracter->atomo,")")==0)){
                caracter=caracter->next;
                if((strcmp(caracter->atomo,"m")==0)){
                    caracter=caracter->next;
                    if((strcmp(caracter->atomo,"{")==0)){
                        caracter=caracter->next;
                        caracter=listaP(caracter);
                        if((strcmp(caracter->atomo,"}")==0)){
                            caracter=caracter->next;
                        }
                    }
                }
            }
        }
    }
    return caracter;
}

NodoA* listaP(NodoA* caracter){
    if((strcmp(caracter->atomo,"i")==0)||(strcmp(caracter->atomo,"c")==0)||(strcmp(caracter->atomo,"w")==0)||(strcmp(caracter->atomo,"f")==0)||(strcmp(caracter->atomo,"j")==0)||(strcmp(caracter->atomo,"h")==0)||(strcmp(caracter->atomo,"z")==0)||(strcmp(caracter->atomo,"[")==0)){
        caracter=P(caracter);
        caracter=listaP(caracter);
    }else if((strcmp(caracter->atomo,"}")==0)||(strcmp(caracter->atomo,":")==0)||(strcmp(caracter->atomo,"t")==0)||(strcmp(caracter->atomo,"a")==0)||(strcmp(caracter->atomo,"o")==0)||(strcmp(caracter->atomo,"q"))){
        return caracter;
    }
    return caracter;
}

NodoA* P(NodoA* caracter){
    if((strcmp(caracter->atomo,"i")==0)){
        caracter=A(caracter);
    }else if((strcmp(caracter->atomo,"f")==0)){
        caracter=I(caracter);
    }else if((strcmp(caracter->atomo,"h")==0)){
        caracter=H(caracter);
    }else if((strcmp(caracter->atomo,"w")==0)){
        caracter=W(caracter);
    }else if((strcmp(caracter->atomo,"j")==0)){
        caracter=J(caracter);
    }else if((strcmp(caracter->atomo,"[")==0)){
        caracter=Llama(caracter);
    }else if((strcmp(caracter->atomo,"z")==0)){
        caracter=Devuelve(caracter);
    }else if((strcmp(caracter->atomo,"c")==0)){
        caracter=caracter->next;
        if((strcmp(caracter->atomo,";")==0)){
            caracter=caracter->next;
        }
    }
    return caracter;
}

NodoA* VPPP(NodoA* caracter){
    if((strcmp(caracter->atomo,"i")==0)||(strcmp(caracter->atomo,"s")==0)){
        caracter=caracter->next;
    }
    return caracter;
}

NodoA* VPP(NodoA* caracter){
    if((strcmp(caracter->atomo,"i")==0)||(strcmp(caracter->atomo,"r")==0)){
        caracter=caracter->next;
    }
    return caracter;
}

NodoA* VP(NodoA* caracter){
    if((strcmp(caracter->atomo,"i")==0)||(strcmp(caracter->atomo,"n")==0)){
        caracter=caracter->next;
    }
    return caracter;
}

NodoA* RP(NodoA* caracter){
    if((strcmp(caracter->atomo,">")==0)||(strcmp(caracter->atomo,"<")==0)||(strcmp(caracter->atomo,"l")==0)||(strcmp(caracter->atomo,"e")==0)||(strcmp(caracter->atomo,"d")==0)||(strcmp(caracter->atomo,"u")==0)){
        caracter=caracter->next;
    }
    return caracter;
}

NodoA* V(NodoA* caracter){
    if((strcmp(caracter->atomo,"i")==0)||(strcmp(caracter->atomo,"n")==0)||(strcmp(caracter->atomo,"r")==0)||(strcmp(caracter->atomo,"s")==0)){
        caracter=caracter->next;
    }
    return caracter;
}

NodoA* R(NodoA* caracter){
    if((strcmp(caracter->atomo,"i")==0)){
        caracter=caracter->next;
        caracter=RP(caracter);
        caracter=V(caracter);
    }else if((strcmp(caracter->atomo,"n")==0)){
        caracter=caracter->next;
        caracter=RP(caracter);
        caracter=VP(caracter);
    }else if((strcmp(caracter->atomo,"r")==0)){
        caracter=caracter->next;
        caracter=RP(caracter);
        caracter=VPP(caracter);
    }else if((strcmp(caracter->atomo,"s")==0)){
        caracter=caracter->next;
        caracter=RP(caracter);
        caracter=VPPP(caracter);
    }
    return caracter;
}

NodoA* F(NodoA* caracter){
    if(strcmp(caracter->atomo,"(")==0){
        caracter=caracter->next;
        caracter=E(caracter);
        if((strcmp(caracter->atomo,")")==0)){
             caracter=caracter->next;
        }
    }else if((strcmp(caracter->atomo,"i")==0)||(strcmp(caracter->atomo,"n")==0)||(strcmp(caracter->atomo,"r")==0)){
        caracter=caracter->next;
    }else if(strcmp(caracter->atomo,"[")==0){
        caracter=Llama(caracter);
    }
    
    return caracter;
}

NodoA* TP(NodoA* caracter){
    if(strcmp(caracter->atomo,"*")==0||(strcmp(caracter->atomo,"/")==0)||(strcmp(caracter->atomo,"\\")==0)||(strcmp(caracter->atomo,"%")==0)||(strcmp(caracter->atomo,"^")==0)){
        caracter=caracter->next;
        caracter=F(caracter);
        caracter=TP(caracter);
    }else if((strcmp(caracter->atomo,";")==0)||(strcmp(caracter->atomo,")")==0)||(strcmp(caracter->atomo,"+")==0)||(strcmp(caracter->atomo,"-")==0)){
        return caracter;
    }
    return caracter;
}

NodoA* T(NodoA* caracter){
    if((strcmp(caracter->atomo,"i")==0)||(strcmp(caracter->atomo,"n")==0)||(strcmp(caracter->atomo,"r")==0)||(strcmp(caracter->atomo,"[")==0)||(strcmp(caracter->atomo,"(")==0)){
        caracter=F(caracter);
        caracter=TP(caracter);
    }
    return caracter;
}

NodoA* EP(NodoA* caracter){
    if(strcmp(caracter->atomo,"+")==0||(strcmp(caracter->atomo,"-")==0)){
        caracter=caracter->next;
        caracter=T(caracter);
        caracter=EP(caracter);
    }else if((strcmp(caracter->atomo,";")==0)||(strcmp(caracter->atomo,")")==0)){
        return caracter;
    }
    return caracter;
}

NodoA* E(NodoA* caracter){
    if((strcmp(caracter->atomo,"i")==0)||(strcmp(caracter->atomo,"n")==0)||(strcmp(caracter->atomo,"r")==0)||(strcmp(caracter->atomo,"[")==0)||(strcmp(caracter->atomo,"(")==0)){
        caracter=T(caracter);
        caracter=EP(caracter);
    }
    return caracter;
}

NodoA* AP(NodoA* caracter){
    if(strcmp(caracter->atomo,"s")==0){
        caracter=caracter->next;
    }else if((strcmp(caracter->atomo,"i")==0)||(strcmp(caracter->atomo,"n")==0)||(strcmp(caracter->atomo,"r")==0)||(strcmp(caracter->atomo,"[")==0)||(strcmp(caracter->atomo,"(")==0)){
        caracter=E(caracter);
    }
    return caracter;
}

NodoA* A(NodoA* caracter){
    if(strcmp(caracter->atomo,"i")==0){
        caracter=caracter->next;
        if(strcmp(caracter->atomo,"=")==0){
            caracter=caracter->next;    
            caracter=AP(caracter);
            if(strcmp(caracter->atomo,";")==0){
                caracter=caracter->next;
            }
        }
    }
    return caracter;
}

NodoA* C(NodoA* caracter){
    if(strcmp(caracter->atomo,",")==0){
        caracter=caracter->next;
        caracter=K(caracter);
    }else if(strcmp(caracter->atomo,";")==0){
        return caracter;
    }
    return caracter;
}

NodoA* N(NodoA* caracter){
    if((strcmp(caracter->atomo,"n")==0)||(strcmp(caracter->atomo,"r")==0)||(strcmp(caracter->atomo,"s")==0)){
        caracter=caracter->next;
    }
    return caracter;
}

NodoA* K(NodoA* caracter){   
    if(strcmp(caracter->atomo,"i")==0){
        caracter=caracter->next;
        caracter=Q(caracter);
    }
    return caracter;
}

NodoA* Q(NodoA* caracter){
    if(strcmp(caracter->atomo,"=")==0){
        caracter=caracter->next;
        caracter=N(caracter);
        caracter=C(caracter);
    }else if(strcmp(caracter->atomo,",")==0){
        caracter=caracter->next;
        caracter=K(caracter);
    }else if(strcmp(caracter->atomo,";")==0){
        return caracter;
    }
    return caracter;
}

NodoA* D(NodoA* caracter){
    if((strcmp(caracter->atomo,"b")==0)||(strcmp(caracter->atomo,"g")==0)||(strcmp(caracter->atomo,"#")==0)||(strcmp(caracter->atomo,"y")==0)||(strcmp(caracter->atomo,"x")==0)){
        caracter=Tipo(caracter);
        caracter=K(caracter);
        if(strcmp(caracter->atomo,";")==0){
            caracter=caracter->next;
        }
    }
    return caracter;
}

NodoA* Decl(NodoA* caracter){
    if((strcmp(caracter->atomo,"b")==0)||(strcmp(caracter->atomo,"g")==0)||(strcmp(caracter->atomo,"#")==0)||(strcmp(caracter->atomo,"y")==0)||(strcmp(caracter->atomo,"x")==0)){
        caracter=D(caracter);
        caracter=Decl(caracter);
    }else if((strcmp(caracter->atomo,"i")==0)||(strcmp(caracter->atomo,"}")==0)||(strcmp(caracter->atomo,"c")==0)||(strcmp(caracter->atomo,"w")==0)||(strcmp(caracter->atomo,"f")==0)||(strcmp(caracter->atomo,"j")==0)||(strcmp(caracter->atomo,"h")==0)||(strcmp(caracter->atomo,"z")==0)||(strcmp(caracter->atomo,"[")==0)){
        return caracter;
    }
    return caracter;
}

NodoA* Cuerpo(NodoA* caracter){
    if((strcmp(caracter->atomo,"i")==0)||(strcmp(caracter->atomo,"}")==0)||(strcmp(caracter->atomo,"b")==0)||(strcmp(caracter->atomo,"g")==0)|(strcmp(caracter->atomo,"#")==0)||(strcmp(caracter->atomo,"y")==0)||(strcmp(caracter->atomo,"x")==0)||(strcmp(caracter->atomo,"c")==0)||(strcmp(caracter->atomo,"w")==0)||(strcmp(caracter->atomo,"f")==0)||(strcmp(caracter->atomo,"j")==0)||(strcmp(caracter->atomo,"h")==0)||(strcmp(caracter->atomo,"z")==0)||(strcmp(caracter->atomo,"[")==0)){  
        caracter=Decl(caracter);
        caracter=listaP(caracter);
    }
    return caracter;
}

NodoA* otroParam(NodoA* caracter){
    if((strcmp(caracter->atomo,",")==0)){  
        caracter=caracter->next;
        caracter=Tipo(caracter);
        if((strcmp(caracter->atomo,"i")==0)){     
            caracter=caracter->next;
            caracter=otroParam(caracter);
        }
    }else if((strcmp(caracter->atomo,")")==0)){
       return caracter; // caracter=caracter->next;
    }
    return caracter;
}

NodoA* Param(NodoA* caracter){
     if((strcmp(caracter->atomo,"b")==0)||(strcmp(caracter->atomo,"g")==0)||(strcmp(caracter->atomo,"#")==0)||(strcmp(caracter->atomo,"y")==0)||(strcmp(caracter->atomo,"x")==0)){
        caracter=Tipo(caracter);
        if((strcmp(caracter->atomo,"i")==0)){     
            caracter=caracter->next;
            caracter=otroParam(caracter);
        }
     }else if((strcmp(caracter->atomo,")")==0)){
       return caracter;
     }
     return caracter;
}

NodoA* Funcion(NodoA* caracter){
     if((strcmp(caracter->atomo,"b")==0)||(strcmp(caracter->atomo,"g")==0)||(strcmp(caracter->atomo,"#")==0)||(strcmp(caracter->atomo,"y")==0)||(strcmp(caracter->atomo,"x")==0)){  
        caracter=Tipo(caracter);
        if((strcmp(caracter->atomo,"i")==0)){
            caracter=caracter->next;
            if((strcmp(caracter->atomo,"(")==0)){
                caracter=caracter->next;
                caracter=Param(caracter);
                if((strcmp(caracter->atomo,")")==0)){
                    caracter=caracter->next;
                    if((strcmp(caracter->atomo,"{")==0)){
                        caracter=caracter->next;
                        caracter=Cuerpo(caracter);
                        if((strcmp(caracter->atomo,"}")==0)){
                            caracter=caracter->next;
                        }
                    }
                }
            }
        }    
    }
    return caracter;
}

NodoA* otraFuncion(NodoA* caracter){
    if((strcmp(caracter->atomo,"b")==0)||(strcmp(caracter->atomo,"g")==0)||(strcmp(caracter->atomo,"#")==0)||(strcmp(caracter->atomo,"y")==0)||(strcmp(caracter->atomo,"x")==0)){
        caracter=Funcion(caracter);
        caracter=otraFuncion(caracter);
    }else if(strcmp(caracter->atomo,"⊣")==0){
        return caracter;
    }
    return caracter;
}

NodoA* Programa(NodoA* caracter){
    if((strcmp(caracter->atomo,"b")==0)||(strcmp(caracter->atomo,"g")==0)||(strcmp(caracter->atomo,"#")==0)||(strcmp(caracter->atomo,"y")==0)||(strcmp(caracter->atomo,"x")==0)){
        caracter=Funcion(caracter);
        caracter=otraFuncion(caracter);
    }
    return caracter;
}

//La funcion parser recibe la lista de atomos, la cual verifica que existan atomos y en caso de que hayan
//envia el primer caracter a la funcion del programa, la que regresara el simbolo final y si cumple se imprimira
//que cumple con la sintaxis, y en caso contrario indica que no cumple

void parser(ListaAtomos lista){
    if(lista.head==NULL){
        printf("No hay cadena de atomos\n");
    }else{
        NodoA* caracterFinal=Programa(lista.head); //simbolo inicial apuntador
        if(strcmp(caracterFinal->atomo,"⊣")==0){
            printf("Aceptado\n");
        }else{
            printf("No aceptado\n");
        }
    }
}
