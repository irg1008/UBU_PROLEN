cls
javacc P03.jj | Out-Null

echo "COMPILANDO..."
javac *.java

echo "COMPILADO SIN ERRORES"
echo "SALIDA:"
echo "---------------------------------"
echo ""
java -cp . PTres $args[0] | tee Salida/Salida.txt

echo ""
echo "---------------------------------"
echo "ELIMINADO EJECUTABLES Y BINARIOS"
sleep -seconds 1
Remove-Item *.java
Remove-Item *.class