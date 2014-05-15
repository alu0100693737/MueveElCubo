%token T_ID
%token T_INT T_FLOAT T_VEC
%token T_INST0
%token T_INST1VEC T_INST1FLOAT

%{

   /*Inicializando estructuras de datos*/

   // Hash para almacenar el uso de variables globales
   var globalVar = {};

   // Array de los diversos hash locales por cada bloque creado
   // Usar como una pila 
   var localHashList = new Array ();
   var localHashIndex = -1;

   // Variables de control
   var lineNumberAct = 0;

   // Funciones globales ---
   /*
    * Funcion encargada de buscar el id de una variable en los diversos mapas locales 
    * creados hasta ese momento y nos da la posici—n en el vector de mapas.
    * Retorna -1 en caso de no encontrar el id buscado.
    */
   function searchID (text) {
      var foundVar = false;
      var i = 0;
      while (!foundVar && (i < localHashIndex + 1)) {
         if (text in localHashList[i]) {
            foundVar = true;
         } else {
            ++i;
         }
      } 
      if (!foundVar) {
         i = -1;
      }
      return i;
   }

   console.log ("Inicializando ejecucion... ------------------------------");
%}

%lex
%%
\s+ 					/* empty */
\n					return '\n';
"+"					return '+';
"-"					return '-';
"="					return '=';
"=="|"!="|"<"|">"|"<="|">="		return 'T_COMP';


"stop"					return 'T_INST0';
"move"					return 'T_INST1VEC';
"turn"|"pitch"|"yaw"|"accel"|"decel"	return 'T_INST1FLOAT';

"if"					return 'T_IF';
"while"					return 'T_WHILE';
"else"					return 'T_ELSE';

"int"					return 'T_TINT';
"float"					return 'T_TFLOAT';
"vec"					return 'T_TVEC';

[0-9]+("."[0-9]+)\b			return 'T_FLOAT';
[0-9]+					return 'T_INT';
"("[0-9]+("."[0-9]+)\b","[0-9]+("."[0-9]+)\b","[0-9]+("."[0-9]+)\b")"			return 'T_VEC';

"("					return '(';
")"					return ')';
"{"					return '{';
"}"					return '}';

[_a-z][_a-zA-Z0-9]*			return 'T_ID';
<<EOF>>					return 'EOF';

/lex
%%
BODY: 	
	BLOCK EOF
	   {
	      /* Ejecuciones finales */
	      console.log (" +++ Estado final del hash de variables globales +++");
	      console.log (globalVar);
	      console.log ("Ejecucion Finalizada. -----------------------------------------");
	   }
;



BLOCK: 
	INIT_BLOCK MAIN_BLOCK END_BLOCK
;

INIT_BLOCK: /* empty */
	   {
	      /* Inicializar estructuras de datos para el bloque. */
	      localHashIndex = localHashIndex + 1;
	      localHashList[localHashIndex] = {};
	      console.log(" +++ Inicializando Bloque " + localHashIndex + ": ");
	   }
;

MAIN_BLOCK:
 	LINE MAIN_BLOCK
|	LINE
;

END_BLOCK: /* empty */
	   {
	      /* Ejecuciones finales de un bloque */
	      console.log (" +++ Finalizando BLoque " + localHashIndex);
	      console.log (localHashList[localHashIndex]);
	      console.log (" ++++++++++++++++++++++++++++++++++++++++++ \n");
	      localHashList.splice(localHashIndex, 1);
	      localHashIndex = localHashIndex - 1;
	   }
;


    
LINE:
  	DECLARATION
| 	INSTRUCTION
| 	CONTROL
;



DECLARATION:
  	INT
| 	FLOAT
| 	VEC
;

INT:
	T_TINT T_ID '=' T_INT
	   {
	      ++lineNumberAct;
	      if (searchID ($2) > -1) {
	         console.log (" --- ERROR en la linea " + lineNumberAct + ": \n --- --- Variable previamente declarada");  
	      } else {
	         localHashList[localHashIndex][$2] = $4;
	      }
	   }
| 	T_ID '=' T_INT
	   {
	      ++lineNumberAct;
	      var posID = searchID ($1);
	      if (posID > -1) {
	         localHashList[posID][$1] = $3;
	      } else {
	         console.log (" --- ERROR en la linea " + lineNumberAct + ": \n --- --- Variable sin declaradar"); 
	      }
	   }
;

FLOAT:
  	T_TFLOAT T_ID '=' T_FLOAT
;

VEC:
  	T_TVEC T_ID '=' T_VEC
;


  
CONTROL:
  	IF
| 	ELSE
| 	WHILE
;

IF:
  	T_IF '(' COMP ')' '{' BLOCK '}'
;

ELSE:
	  IF T_ELSE '{' BLOCK '}'
;

WHILE:
  	T_WHILE '(' COMP ')' '{' BLOCK '}'
	   {
	   	
	   }
;

COMP:
  	T_ID T_COMP T_INT
|  	T_ID T_COMP T_ID
;



INSTRUCTION:
  	T_INST0
	   {
	      ++lineNumberAct;
	      console.log("Parando el movimiento.");
	   }
| 	INST1VEC
| 	INST1FLOAT
;
    
INST1VEC:
  	T_INST1VEC T_VEC
;
INST1FLOAT:
 	T_INST1FLOAT T_FLOAT
;

