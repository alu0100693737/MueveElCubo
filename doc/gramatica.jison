%token T_ID
%token T_INT T_FLOAT T_VEC
%token T_INST0
%token T_INST1VEC T_INST1FLOAT

%lex
%%
\s+	/* ws */
"\n"					return '\n';
"+"					return '+';
"-"					return '-';
"="					return '=';
"<"					return '<';
">"					return '>';
"=="					return '==';
"!="					return '!=';
"<="					return '<=';
">="					return '>=';

[_a-z][_a-zA-Z0-9]*			return 'T_ID';

[0-9]+					return 'T_INT';
[0-9]+("."[0-9]+)?\b			return 'T_FLOAT';
"("T_FLOAT","T_FLOAT","T_FLOAT")"	return 'T_VEC';

"stop"					return 'T_INST0';
"move"					return 'T_INST1VEC';
"turn|pitch|yaw|accel|decel"		return 'T_INST1FLOAT';

<<EOF>>					return 'EOF';

/lex
%%
BODY: LINE
    | LINE "\n" BODY;
    
LINE: DECLARATION
    | INSTRUCTION
    | CONTROL;
    
CONTROL: IF
	| ELSE
	| WHILE;

IF: "if (" COMP ") {" BODY "}";
ELSE: IF "else {" BODY "}";
WHILE: "while (" COMP ") {" BODY "}";

DECLARATION: FLOAT
	    | INT
	    | VEC;

INT: "int " ID " = " T_INT
FLOAT: "float " ID " = " T_FLOAT
VEC: "vec " ID " = " T_VEC

INSTRUCTION: T_INST0
	    | INST1VEC
	    | INST1FLOAT
    
INST1VEC: T_INST1VEC T_VEC
INST1FLOAT: T_INST1FLOAT T_FLOAT