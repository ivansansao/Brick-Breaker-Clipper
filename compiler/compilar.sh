#!bash

rm ./src/brickBreaker
rm ./src/brickBreaker.c
clear

echo "Como usar:"
echo "~/dev/clipa/sudo sh ./compiler/compilar.sh "

echo "****** COMPILANDO PARTE 1 ******"
if sudo harbour ./src/brickBreaker.prg; then

    echo "****** COMPILANDO PARTE 2 ******"
    sudo hbmk2 ./brickBreaker.c

    echo "****** ABRINDO brickBreaker... ******"
    ./brickBreaker
fi
