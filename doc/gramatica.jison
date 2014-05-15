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
   var ignoreActualBlock = false;

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

"=="|"!="|"<"|">"|"<="|">="		return 'T_COMP';

"+"					return '+';
"-"					return '-';
"="					return '=';



"stop"					return 'T_INST0';
"move"					return 'T_INST1VEC';
"turn"|"pitch"|"yaw"|"accel"|"decel"	return 'T_INST1FLOAT';

"if"					return 'T_IF';
"while"					return 'T_WHILE';
"else"					return 'T_ELSE';

"int"					return 'T_TINT';
"float"					return 'T_TFLOAT';
"vec"					return 'T_TVEC';


"("					return '(';
")"					return ')';
"{"					return '{';
"}"					return '}';

[0-9]+("."[0-9]+)\b			return 'T_FLOAT';
[0-9]+\b				return 'T_INT';
"("[0-9]+("."[0-9]+)\b","[0-9]+("."[0-9]+)\b","[0-9]+("."[0-9]+)\b")"			return 'T_VEC';
[_a-z][_a-zA-Z0-9]*			return 'T_ID';
<<EOF>>					return 'EOF';

/lex
%left '+' '-'


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
	      ignoreActualBlock = false;
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
	ADD_LINE T_TINT T_ID '=' OPERATION_INT
	   {
	      if (searchID ($3) > -1) {
	         console.log (" --- ERROR en la linea " + lineNumberAct + ": \n --- --- Variable previamente declarada");  
	      } else {
	         if (!ignoreActualBlock ) {
	            localHashList[localHashIndex][$3] = $5;
	         }
	      }
	      
	   }
| 	ADD_LINE T_TINT T_ID
	   {
	      if (searchID ($3) > -1) {
	         console.log (" --- ERROR en la linea " + lineNumberAct + ": \n --- --- Variable previamente declarada");
	      } else {
	         if (!ignoreActualBlock ) {
	            localHashList[localHashIndex][$3] = 0;
	         }
	      }
	   }
| 	ADD_LINE T_ID '=' OPERATION_INT
	   {
	      var posID = searchID ($2);
	      if (posID > -1) {
	         if (!ignoreActualBlock ) {
	            localHashList[posID][$2] = $4;
	         }
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

OPERATION_INT:
	OPERATION_INT '+' OPERATION_INT
	   {
	      $$ = $1 + $3;
	   }
|	OPERATION_INT '-' OPERATION_INT
	   {
	      $$ = $1 - $3;
	   }
|	T_INT
	   {
	     $$ = Number(yytext);
	   }
;

OPERATION_FLOAT:
	OPERATION_FLOAT '+' OPERATION_FLOAT
	   {
	      $$ = $1 + $3;
	   }
|	OPERATION_FLOAT '-' OPERATION_FLOAT
	   {
	      $$ = $1 - $3;
	   }
|	T_FLOAT
	   {
	     $$ = Number(yytext);
	   }
;


  
CONTROL:
  	IF
| 	ELSE
| 	WHILE
;

IF:
	INIT_IF BLOCK_CONT
;

INIT_IF:
	T_IF '(' COMP ')'
	   {
	      if (!$3) {
	         ignoreActualBlock = true;
	      }
	   }
|	T_IF '(' COMP ')' '\n' ADD_LINE
	      if (!$3) {
	         ignoreActualBlock = true;
	      }
;
BLOCK_CONT:
	'{' BLOCK '}'
|	'{' '\n' ADD_LINE BLOCK  '}'
|	'{' BLOCK '\n' ADD_LINE '}'
| 	'{' '\n' ADD_LINE BLOCK '\n' ADD_LINE '}'
;

ELSE:
	  IF T_ELSE BLOCK_CONT
|	  IF T_ELSE '\n' ADD_LINE BLOCK_CONT
;

WHILE:
  	T_WHILE '(' COMP ')' '{' BLOCK '}'

;

COMP:
  	T_ID T_COMP OPERATION_INT
	   {
	      var posID = searchID ($1);
	      var result = false;
	      if ( posID > -1 ) {
	         if ( localHashList[posID][$1] == $3 ) {
	            result = true;
	         }
	      } else {
	         console.log (" --- ERROR en la linea " + lineNumberAct + ": \n --- --- Variable sin declarar en una comparacion");
	      } 
	      $$ = result;
	   }
|  	T_ID T_COMP T_ID
;



INSTRUCTION:
  	ADD_LINE T_INST0
| 	ADD_LINE INST1VEC
| 	ADD_LINE INST1FLOAT
;
    
INST1VEC:
  	T_INST1VEC T_VEC
;
INST1FLOAT:
 	T_INST1FLOAT T_FLOAT
;

ADD_LINE: /* empty */
	   {
	      ++lineNumberAct;
	   }
;