#!/bin/bash

clear

cd src

echo ""
echo "ERRORES Y WARNINGS"
echo "--------------------------"


echo "1.- FLEX"
echo "-------------"
flex P04.l

echo ""
echo "2.- BISON"
echo "-------------"
bison -ydv P04.y

echo ""
echo "3.- GCC"
echo "-------------"
gcc lex.yy.c y.tab.c -o P04 -lfl #-DYYDEBUG

rm *.c *.h *.output

cd ..

echo ""
echo "EJECUCIÓN Y SALIDA"
echo "--------------------------"


src/P04 $1 | tee Salida/Salida.txt

rm src/P04
