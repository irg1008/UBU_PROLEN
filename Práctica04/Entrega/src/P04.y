/**
 * Práctica 04 - Procesadores del Lenguaje.
 * 
 * @author Iván Ruiz Gázquez.
 * @date 08/12/2020.
 */

%{
#include <stdio.h>
#include <stdlib.h>

// If debug flag.
#ifdef YYDEBUG
  int yydebug = 1;
#endif

/**
* Input file.
*/
extern FILE *yyin;

/**
* Language class.
*/
int yylex();

/**
* Error handler.
*/
void yyerror(const char *); 

int labelCount = 0;
/**
* Get a new label.
*
* @return Previous + 1.
*/
int getNewLabel() {
    return labelCount++;
}

// Output functions.
  void valori(char* s)          { printf("\tvalori %s\n", s); }
  void valord(char* s)          { printf("\tvalord %s\n", s); }
  void mete(int n)              { printf("\tmete %d\n", n); }
  void siFalsoVea(int label)    { printf("\tsifalsovea LBL%d\n", label); }
  void siCiertoVea(int label)   { printf("\tsiciertovea LBL%d\n", label); }
  void vea(int label)           { printf("\tvea LBL%d\n", label); }
  void lbl(int label)           { printf("LBL%d\n", label); }
  void divi()                   { printf("\tdiv\n"); }
  void mul()                    { printf("\tmul\n"); }
  void res()                    { printf("\tsub\n"); }
  void sum()                    { printf("\tsum\n"); }
  void asigna()                 { printf("\tasigna\n"); }
  void display()                { printf("\tprint\n"); }
%}

%union {
    int num;
    char *id;
}

%token COMPUTE IF ELSE END_IF EVALUATE END_EVALUATE PERFORM END_PERFORM UNTIL DISPLAY WHEN MOVE TO 
%token <num>NUM
%token <id>ID
%token EQ SUM RES MUL DIV PAR_OP PAR_CL
%left SUM RES MUL DIV

%%
/**
* Program = all snetences.
*/
program: sentences;

/**
* Sentences = One or more sentence.
*/
sentences: 
        sentences sent
    |   sent
    ;

/**
* Sentence = Assignment or Process.
*/
sent:
        assig { asigna(); }
    |   proc
    ;

/**
* Variable assignment.
*/
assig:
        compute
    |   move
    ;

/**
* Assignment of variable to arithmetic value.
*/
compute: COMPUTE ID { valori($<id>2); } EQ arithexp;

/**
* Move value or variable to variable.
*/
move:
        MOVE NUM TO ID  { valori($<id>4); mete($<num>2); }
    |   MOVE ID TO ID   { valori($<id>4); valord($<id>2); }
    ;   

/**
* Processes:
*   - If
*   - Evaluate: Switch.
*   - Perofrm: While.
*   - Display: print.
*/
proc:
        if
    |   evaluate
    |   perform
    |   display
    ;

/**
* If and optional else.
* If no else is declared, label will be empty.
*/
if: 
        newLabel newLabel // ELSE, IF labels.
        IF arithexp { siFalsoVea($<num>1); }
        sentences   { vea($<num>2); lbl($<num>1);} 
        else        { lbl($<num>2); }
        END_IF
    ;

/**
* Evaluate. Switch equivalent.
* Calls whenclause.
*/
evaluate: 
        newLabel // EVALUATE label.
        EVALUATE ID { $<id>$ = $3; } // ID to stack for use in whenClause.
        whenclause
        END_EVALUATE { lbl($<num>1); }
    ;

/**
* Perform. While equivalent.
*/
perform:
        newLabel newLabel // PERFORM and END_PERFORM labels.
        PERFORM UNTIL           { lbl($<num>1); }
        arithexp                { siCiertoVea($<num>2); }
        sentences END_PERFORM   { vea($<num>1); lbl($<num>2); }
    ;

/**
* Display. Output or Print equivalent.
*/
display: DISPLAY arithexp { display(); };

/**
* Else. (Optional).
*/
else:
        // EPSILON
    |   ELSE sentences
    ;

/**
* When clause. Equivalent to 'Case x' in Switch.
* Called from evaluate.
*/
whenclause:
        whenclause when
    |   when
    ;

/**
* When clause body: WHEN keyword and arithmetic expression.
*/
when: 
        newLabel
        WHEN        { valord($<id>-1); }
        arithexp    { res(); siFalsoVea($<num>1); }
        sentences   { vea($<num>-4); lbl($<num>1); }
    ;

/**
* Arithmetic expression.
* Addition or substraction.
*/
arithexp:
        arithexp SUM multexp { sum(); }
    |   arithexp RES multexp { res(); }
    |   multexp
    ;

/**
* Multiplication or division.
*/
multexp:
        multexp MUL multexp { mul(); }
    |   multexp DIV multexp { divi(); }
    |   value
    ;

/**
* Value = number, variable id or arithmetic expression.
*/
value:
        NUM { mete($<num>1); }
    |   ID  { valord($<id>1); }
    |   PAR_OP arithexp PAR_CL
    ;

/**
* Creates a new label and returns that new label value.
*/
newLabel: { $<num>$ = getNewLabel(); };
%%

/**
* Error handler.
*/
void yyerror(const char *s) {
    printf("%s\n", s);
    exit(1);
}

/**
* Main funciton.
* Uses file if given argument or instead stdin.
*/
int main(int argc, char **argv) {
    if(argc > 1) {
		FILE *file = fopen(argv[1], "r");
		if(!file) {
			fprintf(stderr, "No se puede abrir: %s\n", argv[1]);
			exit(1);
		}
		yyin = file;
	}
    yyparse();
    return 0;
}