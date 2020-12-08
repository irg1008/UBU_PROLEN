%{
#include "y.tab.h"
#include <string.h>
%}

DIG [0-9]
CHAR [a-zA-Z_]
%%
"="                     return EQ;
"+"                     return SUM;
"-"                     return RES;
"*"                     return MUL;
"/"                     return DIV;
"("                     return PAR_OP;
")"                     return PAR_CL;
"COMPUTE"               return COMPUTE;
"IF"                    return IF;
"ELSE"                  return ELSE;
"END-IF"                return END_IF;
"EVALUATE"              return EVALUATE;
"END-EVALUATE"          return END_EVALUATE;
"PERFORM"               return PERFORM;
"END-PERFORM"           return END_PERFORM;
"UNTIL"                 return UNTIL;
"DISPLAY"               return DISPLAY;
"WHEN"                  return WHEN;
"MOVE"                  return MOVE;
"TO"                    return TO;

{DIG}+                  {
                            yylval.num = atoi(yytext);
                            return NUM;
                        }
{CHAR}({CHAR}|{DIG})*   {
                            yylval.id = strdup(yytext);
                            return ID;
                        }

[ \t\r\n]               ;
"**".*                  ;
%%