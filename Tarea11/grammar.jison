/* Definición Léxica */
%lex

%options case-insensitive

%%

"("                 return 'PARIZQ';
")"                 return 'PARDER';

"+"                 return '+';
"-"                 return '-';
"*"                 return '*';
"/"                 return '/';

/* Espacios en blanco */
[ \r\t]+            {}
\n                  {}

([a-zA-Z_])[a-zA-Z0-9_ñÑ]*	return 'ID';
[0-9]+("."[0-9]+)?\b    return 'DECIMAL';
[0-9]+\b                return 'ENTERO';

<<EOF>>                 return 'EOF';

.                       { console.error('Este es un error léxico: ' + yytext + ', en la linea: ' + yylloc.first_line + ', en la columna: ' + yylloc.first_column); }
/lex

/* Asociación de operadores y precedencia */

%left '+' '-'
%left '*' '/'
%left UMENOS

%start S

%% /* Definición de la gramática */
S 
    :E { print(E.C3D) }
;

E 
    :E + T { E.TMP = new_temp();
             E.C3D = E1.C3D + T.C3D + E.TMP + “=” + E1.TMP “+” + T.TMP }
    |E – T { E.TMP = new_temp(); }
    |T
;

T
    :T * F { T.TMP = new_temp(); }
    |T / F { T.TMP = new_temp(); }
    |F { T.TMP = F.TMP }
;

F
    :(E) { F.TMP = E.TMP }
    |ID { F.TMP = id.lex_value;
          F.C3D = "" }
;



instruccion
	: REVALUAR CORIZQ expresion CORDER PTCOMA {
		console.log('El valor de la expresión es: ' + $3);
	}
;

expresion
	: MENOS expresion %prec UMENOS  { $$ = $2 *-1; }
	| expresion MAS expresion       { $$ = $1 + $3; }
	| expresion MENOS expresion     { $$ = $1 - $3; }
	| expresion POR expresion       { $$ = $1 * $3; }
	| expresion DIVIDIDO expresion  { $$ = $1 / $3; }
	| ENTERO                        { $$ = Number($1); }
	| DECIMAL                       { $$ = Number($1); }
	| PARIZQ expresion PARDER       { $$ = $2; }
;