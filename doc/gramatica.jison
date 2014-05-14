%token T_ID
%token T_INT T_FLOAT T_VEC
%token T_INST0
%token T_INST1VEC T_INST1FLOAT

%{

/*Inicializando estructuras de datos*/

// Hash para almacenar el uso de variables globales
var globalVar = {};

var localHashIndex = -1;

var localHashList = new Array ();


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
	   }
;


BLOCK: 
	INIT_BLOCK MAIN_BLOCK END_BLOCK
;

INIT_BLOCK: /* empty */
	   {
	      /* Inicializar estructuras de datos para el bloque. */
	      console.log ("Inicializando un bloque.");
	
	      localHashIndex = localHashIndex + 1;
	      localHashList[localHashIndex] = {};
	   }
;

MAIN_BLOCK:
 	LINE MAIN_BLOCK
|	LINE
;

END_BLOCK: /* empty */
	   {
	      console.log ("Cerrando un bloque.");
	      console.log ("Inidice pila hash variables: " + localHashIndex);
	      console.log ("Variables locales: ");
	      console.log (localHashList[localHashIndex]);
	      localHashList.splice(localHashIndex, 1);
	      localHashIndex = localHashIndex - 1;
	   }
;
    
LINE:
  DECLARATION
| INSTRUCTION
| CONTROL
;
    
CONTROL:
  IF
| ELSE
| WHILE
;

IF:
  T_IF '(' COMP ')' '{' BODY '}'
  ;
ELSE:
  IF T_ELSE '{' BODY '}'
  ;
WHILE:
  T_WHILE '(' COMP ')' '{' BODY '}'
	{
		
	}
  ;

COMP:
  T_ID T_COMP T_INT
| T_ID T_COMP T_ID
;

DECLARATION:
  FLOAT
| INT
| VEC;

INT:
  T_TINT T_ID '=' T_INT
	{
	        var localVar = localHashList[localHashIndex];
		if ($2 in localVar) {
			console.log ("Variable ya declarada.");
		} else {
			(localHashList[localHashIndex])[$2] = $4;
		}
	}
| T_ID '=' T_INT
	{
		var localVar = localHashList[localHashIndex];
		if ($1 in localVar) {
			(localHashList[localHashIndex])[$1] = $3;
		} else {
			console.log ("Usando una variable sin declarar.");
		}
	}
;
FLOAT:
  T_TFLOAT T_ID '=' T_FLOAT
  ;
VEC:
  T_TVEC T_ID '=' T_VEC
  ;

INSTRUCTION:
  T_INST0
	{
		console.log("Parando el movimiento.");
	}
| INST1VEC
| INST1FLOAT
;
    
INST1VEC:
  T_INST1VEC T_VEC
  ;
INST1FLOAT:
  T_INST1FLOAT T_FLOAT
  ;

