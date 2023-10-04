Projeto apenas para fins de noltalgia em Clipper!

![Alt text](src/assets/brickbreacker.gif "Brick Breacker")

Utilizando o compilador Harbour para Linux Ubuntu! (Tem para Windows também)

Dependência do Framework Mauaka disponível nesta conta!

### Instalar o compilador 

Harbour compila os fontes do Clipper e já em 64bits

Download do compiador

http://www.xharbour.org/index.asp?page=download/binaries

Instale

~~~
sudo apt update
sudo apt install gcc
sudo apt install build-essential
~~~

Baixe o harbour_3.0.0-1_i386_ubu_10.04-2.deb  
~~~
sudo dpkg harbour_3.0.0-1_i386_ubu_10.04-2.deb
~~~

### Como compilar no Ubuntu

Esteja na raíz do projeto e execute os comandos abaixo

~~~
sudo harbour ./src/brickBreaker.prg  
sudo hbmk2 ./brickBreaker.c  
~~~

### Executar

~~~
./brickBreaker
~~~

