<h1>Analizador Sintáctico</h1>
Este proyecto consiste en el desarrollo de un analizador sintáctico utilizando 
Flex/Lex, y lenguaje C, en el editor Visual Studio Code. Utilizando como base el 
analizados léxico. Para crear el analizador, se añadieron las siguientes 
estructuras y conceptos. 

<h2>Conceptos utilizados</h2>
<ul>
    <li> Lista para la tabla de atomos.
    <li> Funciones que regresentan las grámaticas y conjuntos de selección 
    para cada una de los elementos del lenguaje definido.
</ul>

El programa lee un archivo base, y por medio de Lex, se va identificando la instrucción, otorgando una posición dentro de la tabla que corresponda. 