set procedure to /home/ivan/dev/clipper/projects/mauaka/src/objectconcept.prg
set procedure to /home/ivan/dev/clipper/projects/mauaka/src/strings.prg
set procedure to /home/ivan/dev/clipper/projects/mauaka/src/grafic.prg
set procedure to /home/ivan/dev/clipper/projects/mauaka/src/tempo.prg
set procedure to /home/ivan/dev/clipper/projects/mauaka/src/envirionment.prg
set procedure to /home/ivan/dev/clipper/projects/mauaka/src/comunication.prg

function imprimeTabuleiro(jogo, tabuleiro, bola, raquete, blocos, b)

    local i
    local bloco

    @ prop(tabuleiro,"top"), prop(tabuleiro,"left") clear to prop(tabuleiro,"rows"), prop(tabuleiro,"cols")

    setProp(jogo,"qtdBlocos",0)
    for i = 1 to len(blocos)
        bloco = blocos[i]
        setcolor(prop(bloco,"cor"))
        if prop(bloco,"visible")
            @ prop(bloco,"row"), prop(bloco,"col") say prop(bloco,"material")
            setProp(jogo,"qtdBlocos",prop(jogo,"qtdBlocos")+1)
        endif
        if prop(bloco,"explosion") > 0
            showExplosion(bloco)
        endIf
    next

    setcolor(prop(jogo,"messagecolor"))
    @ prop(tabuleiro,"rows"), prop(tabuleiro,"left") say prop(jogo,"message")

    setColor("W+/N")
    @ prop(bola,"row") ,prop(bola,"col") say prop(bola,"char")

    set color to (prop(raquete,"cor"))
    @ prop(raquete,"row"), prop(raquete,"col") say replicate(prop(raquete,"char"),prop(raquete,"width"))

    if prop(jogo,"debug")    

        printStatistics(jogo, tabuleiro, bola, raquete, blocos[b])

        @ 08,34 say "35"
        @ 08,44 say "44"

        @ 09,35 say "|"
        @ 09,44 say "|"
    

        @ 11,35 say "@"
        @ 11,45 say "#"
        ? "Tabuleiro impresso, pressione para continuar!"
        inkey(0)
    endIf

return

function showExplosion(bloco) 

    local explosion := prop(bloco,"explosion")

    setColor("W+/N")
    if explosion = 1
        @ prop(bloco,"row"), prop(bloco,"col") say "    ()    "
        setProp(bloco,"explosion",2)
    elseif explosion = 2
        @ prop(bloco,"row"), prop(bloco,"col") say "   (  )   "
        setProp(bloco,"explosion",3)
    elseif explosion = 3
        @ prop(bloco,"row"), prop(bloco,"col") say " ((    )) "
        setProp(bloco,"explosion",0)
    endIf

return

function rebaixaBlocos(tabuleiro, bola, raquete, blocos)

    local i
    
    for i = 1 to len(blocos)
        setProp(blocos[i],"row", prop(blocos[i],"row")+zeroum())        
    next

return

function moveRaqCima(tabuleiro, bola, raquete)

    setProp(raquete,"row", prop(raquete,"row")-1)

return tabuleiro

function moveRaqBaixo(tabuleiro, bola, raquete)

    setProp(raquete,"row", prop(raquete,"row")+1)
    if prop(raquete,"row") > prop(tabuleiro,"rows")
        setProp(raquete,"row", prop(tabuleiro,"rows"))
    endIf
        
return tabuleiro

function moveRaqDireita(tabuleiro, bola, raquete)
    setProp(raquete,"col", min(prop(raquete,"col")+4,prop(tabuleiro,"cols")-prop(raquete,"width")+1))
return tabuleiro

function moveRaqEsquerda(tabuleiro, bola, raquete)
    setProp(raquete,"col", max(0,prop(raquete,"col")-4))
return tabuleiro

function blocoColidido(jogo, tabuleiro, bola, raquete, blocos)

    local colisao := {{"onde",""},{"b",0}}
    local b
    local iniBloCol
    local endBloCol

    // Colisão com bloco
    for b = 1 to len(blocos)

        if prop(blocos[b],"visible")

            iniBloCol = prop(blocos[b],"col")
            endBloCol = prop(blocos[b],"col")+prop(blocos[b],"width")-1 // -1 porque por exemplo: iniciar na 35 com tamanho 10 daria 45 certo? Soque não, pq ocupa a 35 também, então o final é na coluna 44.

            // Em cima
            do case
            case prop(bola,"row") = prop(blocos[b],"row")-1 .and. prop(bola,"col") >= iniBloCol .and. prop(bola,"col") <= endBloCol .and. prop(bola,"direction") = "down"
                setProp(colisao,"onde","above")
                setProp(colisao,"b",b)
            // Em baixo
            case prop(bola,"row") = prop(blocos[b],"row")+1 .and. prop(bola,"col") >= iniBloCol .and. prop(bola,"col") <= endBloCol .and. prop(bola,"direction") = "up"
                setProp(colisao,"onde","below")
                setProp(colisao,"b",b)
            // Na direita
            case prop(bola,"row") = prop(blocos[b],"row") .and. prop(bola,"col") = endBloCol+1 .and. prop(bola,"inclination") = "left"
                setProp(colisao,"onde","right")
                setProp(colisao,"b",b)
            // Na esquerda
            case prop(bola,"row") = prop(blocos[b],"row") .and. prop(bola,"col") = iniBloCol-1 .and. prop(bola,"inclination") = "right"
                setProp(colisao,"onde","left")
                setProp(colisao,"b",b)

            // Na quina superior esquerda
            case prop(bola,"row") = prop(blocos[b],"row")-1 .and. prop(bola,"col") = iniBloCol-1 .and. prop(bola,"direction") = "down" .and. prop(bola,"inclination") = "right"
                setProp(colisao,"onde","quina-superior-esquerda")
                setProp(colisao,"b",b)
            // Na quina superior direita
            case prop(bola,"row") = prop(blocos[b],"row")-1 .and. prop(bola,"col") = endBloCol+1 .and. prop(bola,"direction") = "down" .and. prop(bola,"inclination") = "left"
                setProp(colisao,"onde","quina-superior-direita")
                setProp(colisao,"b",b)
            // Na quina inferior direita
            case prop(bola,"row") = prop(blocos[b],"row")+1 .and. prop(bola,"col") = endBloCol+1 .and. prop(bola,"direction") = "up" .and. prop(bola,"inclination") = "left"
                setProp(colisao,"onde","quina-inferior-direita")
                setProp(colisao,"b",b)
            // Na quina inferior esquerda
            case prop(bola,"row") = prop(blocos[b],"row")+1 .and. prop(bola,"col") = iniBloCol-1 .and. prop(bola,"direction") = "up" .and. prop(bola,"inclination") = "right"
                setProp(colisao,"onde","quina-inferior-esquerda")
                setProp(colisao,"b",b)
            end

            if !empty(prop(colisao,"onde"))
                // imprimeTabuleiro(jogo, tabuleiro, bola, raquete, blocos, b)
                // alert(prop(colisao,"onde"))
                exit
            endif

        end
    end

return colisao

function printStatistics(jogo, tabuleiro, bola, raquete, bloco)

    local stats := ""

    if prop(jogo,"debug")

        stats = stats +"BOLA:(row: "+tex(prop(bola,"row"))+". col: "+tex(prop(bola,"col"))+". Direction: "+prop(bola,"direction")+". inclination: "+prop(bola,"inclination") +")  "
        stats = stats +"BLOCO:(row: "+tex(prop(bloco,"row"))+". col: "+tex(prop(bloco,"col"))+". width:"+tex(prop(bloco,"width")) +". end block: "+tex(prop(bloco,"col")+prop(bloco,"width")-1) +"). "

        ? stats
        inkey(0)
    endif

return

function paredeColidida(jogo, tabuleiro, bola, raquete, blocos)

    local onde := ""

    if prop(bola,"row") >= prop(raquete,"row")
        onde = "below"
    elseif prop(bola,"row") <= 0        
        onde = "above"
    elseif prop(bola,"col") <= 0
        onde = "left"
    elseif prop(bola,"col") >= prop(tabuleiro,"cols")-1
        onde = "right"
    end

return onde

function raqueteColidida(jogo, tabuleiro, bola, raquete, blocos)

    local onde := ""
    local meioDaRaquete

    if prop(bola,"row") >= prop(raquete,"row")-1 .and. prop(bola,"col") >= prop(raquete,"col")-1 .and. prop(bola,"col") <= prop(raquete,"col")+prop(raquete,"width") 

        meioDaRaquete = prop(raquete,"col") +(prop(raquete,"width")/2)

        if prop(bola,"col") < meioDaRaquete-2
            onde = "left"
        elseif prop(bola,"col") > meioDaRaquete+2
            onde = "right"
        else
            onde = "middle"
        endIf

    endif

return onde

function movimentaBola(jogo, tabuleiro, bola, raquete, blocos)

    local colBloco := blocoColidido(jogo, tabuleiro, bola, raquete, blocos)
    local colParede := paredeColidida(jogo, tabuleiro, bola, raquete, blocos)
    local colRaquete := raqueteColidida(jogo, tabuleiro, bola, raquete, blocos)
    local colidiu := !empty(prop(colBloco,"onde")) .or. !empty(colParede) .or. !empty(colRaquete)

    if colidiu        
        if !empty(colRaquete)
            onColision(jogo, tabuleiro, bola, raquete, blocos, 0,"raquete",colRaquete)
        elseif !empty(colParede)
            onColision(jogo, tabuleiro, bola, raquete, blocos, 0,"parede",colParede)
        elseif !empty(prop(colBloco,"onde"))
            onColision(jogo, tabuleiro, bola, raquete, blocos, prop(colBloco,"b"),"bloco",prop(colBloco,"onde"))
            setProp(blocos[prop(colBloco,"b")],"explosion",1)
        end
    endif

    if prop(bola,"direction") = "up"
        setProp(bola,"row",prop(bola,"row")-1)
    elseif prop(bola,"direction") = "down"
        setProp(bola,"row",prop(bola,"row")+1)
    endIf

    if prop(bola,"inclination") = "right"
        setProp(bola,"col",prop(bola,"col")+1)
    elseif prop(bola,"inclination") = "left"
        setProp(bola,"col",prop(bola,"col")-1)
    endIf

return

function onColision(jogo, tabuleiro, bola, raquete, blocos, iBloco, emQue, onde)

    local stats := ""

    if prop(jogo,"debug") 
        stats = concats({ "\sColidiu!!  emQue:",emQue,". Onde: ",onde,".  Bola direction: ",prop(bola,"direction"), ". Bola row: " ,prop(bola,"row"),", col: ",prop(bola,"col") })
        setProp(jogo,"message","Blocos: "+str(prop(jogo,"qtdBlocos"))+stats)
    else
        setProp(jogo,"message","Blocos: "+str(prop(jogo,"qtdBlocos")))
    end

    if emQue = "parede"

        if onde = "left"
            setProp(bola,"inclination","right")
        elseif onde = "right"
            setProp(bola,"inclination","left")
        elseif onde = "above"
            setProp(bola,"direction","down")
            // rebaixaBlocos(tabuleiro, bola, raquete, blocos)
        elseif onde = "below"
        end

    elseif emQue = "raquete"

        setProp(bola,"direction","up")
        setProp(raquete,"cor", prop(bola,"cor"))
        setProp(bola,"inclination",onde)        

    elseif emQue = "bloco"

        do case
        case onde = "above"
           setProp(bola,"direction","up")
        case onde = "below"
           setProp(bola,"direction","down")
        case onde = "right"
           setProp(bola,"inclination","right")
        case onde = "left"            
           setProp(bola,"inclination","left")

        case onde = "quina-superior-esquerda"            
           setProp(bola,"direction","up")
           setProp(bola,"inclination","left")
        case onde = "quina-superior-direita"            
           setProp(bola,"direction","up")
           setProp(bola,"inclination","right")
        case onde = "quina-inferior-direita"            
           setProp(bola,"direction","down")
           setProp(bola,"inclination","right")
        case onde = "quina-inferior-esquerda"            
           setProp(bola,"direction","down")
           setProp(bola,"inclination","left")
        endCase
        setProp(bola,"cor",prop(blocos[iBloco],"cor"))
        setProp(blocos[iBloco],"visible",.F.)

    endif

return

function perdeu(tabuleiro, bola, raquete)

    local perdeu := .F.

    if prop(bola,"row") > prop(raquete,"row")
        perdeu = .T.
    endif

return perdeu

function ganhou(jogo)
return prop(jogo,"qtdBlocos") <= 0

function adicionaBlocos(jogo, tabuleiro, blocos)

    local bloco
    local row
    local col
    local width := 10
    local i
    local r := 2+mod(int(val(right(str(seconds()),1))),4)
    local materials := {}

    // aAdd(materials,"[XXXXXXXX]")
    aAdd(materials,chr(176)+chr(176)+chr(177)+chr(177)+chr(178)+chr(178)+chr(177)+chr(177)+chr(176)+chr(176))
    aAdd(materials,replicate(chr(178),10))

    // Adiciona blocos manualmente.
    if prop(jogo,"debug")
        bloco = {{"row",10},{"col",35},{"width",width},{"char",chr(178)},{"visible",.T.},{"cor",anyColor(12)+"/N"},{"explosion",0},{"material",materials[1]}}    
        aAdd(blocos, bloco)
        bloco = {{"row",6},{"col",28},{"width",width},{"char",chr(178)},{"visible",.T.},{"cor",anyColor(12)+"/N"},{"explosion",0},{"material",materials[1]}}    
        aAdd(blocos, bloco)
        bloco = {{"row",1},{"col",65},{"width",width},{"char",chr(178)},{"visible",.T.},{"cor",anyColor(12)+"/N"},{"explosion",0},{"material",materials[1]}}    
        aAdd(blocos, bloco)

    else

        for row = prop(tabuleiro,"top")+4 to prop(tabuleiro,"top")+12
            for col = width to prop(tabuleiro,"cols")-width step width
                bloco = {{"row",row},{"col",col},{"width",width},{"char",chr(178)},{"visible",.T.},{"cor",anyColor(row+col)+"/N"},{"explosion",0},{"material",materials[mod(row+col,len(materials))+1]}}
                aAdd(blocos, bloco)
            next
        next

        for i = 1 to len(blocos)
            
            if mod(i,r) = 0
                setProp(blocos[i],"visible",.F.)            
            end

        next
    end

return blocos

function StartGame()

    local blocos := {}
    local tabuleiro
    local bola
    local raquete
    local jogo

    SetEnv()

    corBack := "N"
    corDefault := "W+" +"/" +corBack
    corWPFor := "W+"
    corWP := corWPFor + "/" +"N"
    corSetMessFor := "GR+"
    corSetMess := corSetMessFor +"/" +corBack
    corBordaFor := "BG+"
    corBorda := corBordaFor +"/" +corBack
    corMenuBack := "B"
    corMenuFor := "W+"
    corMenuSelFor := "R+"
    corMenu := corMenuFor +"/" +corMenuBack
    corMenuSel := corMenuSelFor +"/"+ "W+"
    corTitleSel := "GR+"
    corTitle := corTitleSel +"/" +corBack
    
    ? "Abrindo...."
    
    tabuleiro = {{"top", 0}, {"left", 0},{"rows", maxrow()}, {"cols", maxcol()}}
    raquete   = {{"row", prop(tabuleiro,"rows")-2}, {"col", prop(tabuleiro,"cols")/2}, {"width", 30},{"char",chr(9)}, {"cor",corSetMess}}

    bola      = {{"row", prop(tabuleiro,"rows")-3}, {"col", prop(tabuleiro,"cols")/2}, {"direction", "down"},{"inclination","right"},{"char",chr(9)},{"cor","G+/N"}}
    // raquete   = {{"row", prop(tabuleiro,"rows")-2}, {"col", 6}, {"width", 30},{"char",chr(178)}, {"cor",corSetMess}}

    jogo = {{"qtdBlocos", len(blocos)},{"message",""},{"messagecolor","W/N, BG+/B"},{"debug",.F.},{"vitoria",.F.}}
    adicionaBlocos(jogo, tabuleiro, blocos)

    if prop(jogo,"debug")
        bola      = {{"row", 16}, {"col", 50}, {"direction", "up"},{"inclination","left"},{"char","O"},{"cor","G+/N"}}
        bola      = {{"row", 13}, {"col", 32}, {"direction", "up"},{"inclination","right"},{"char","O"},{"cor","G+/N"}}
        bola      = {{"row", 07}, {"col", 30}, {"direction", "down"},{"inclination","right"},{"char","O"},{"cor","G+/N"}}
        bola      = {{"row", 07}, {"col", 32}, {"direction", "down"},{"inclination","right"},{"char","O"},{"cor","G+/N"}}
        bola      = {{"row", 07}, {"col", 31}, {"direction", "down"},{"inclination","right"},{"char","O"},{"cor","G+/N"}}
    endIf

    set cursor off

    set color to (corDefault)

    do while lastkey() != 27

        mili(100)
        
        if nextkey() = 4 // Direita
            moveRaqDireita(tabuleiro, bola, raquete)
            if val(substr(str(seconds()),13,1)) > 6
                movimentaBola(jogo, tabuleiro, bola, raquete, blocos)
            endIf
        elseif nextkey() = 19 // Esquerda
            moveRaqEsquerda(tabuleiro, bola, raquete)
            if val(substr(str(seconds()),13,1)) > 6
                movimentaBola(jogo, tabuleiro, bola, raquete, blocos)
            endIf
        elseif nextkey() = 5 // Cima
            moveRaqCima(tabuleiro, bola, raquete)
            if val(substr(str(seconds()),13,1)) > 6
                movimentaBola(jogo, tabuleiro, bola, raquete, blocos)
            endIf
        elseif nextkey() = 24 // Baixo
            moveRaqBaixo(tabuleiro, bola, raquete)
            if val(substr(str(seconds()),13,1)) > 6
                movimentaBola(jogo, tabuleiro, bola, raquete, blocos)
            endIf
        elseif nextkey() = 27
            exit
        else
            movimentaBola(jogo, tabuleiro, bola, raquete, blocos)
        endIf

        imprimeTabuleiro(jogo, tabuleiro, bola, raquete, blocos, 1)

        keyboard 'a'
        inkey(0)

        if perdeu(tabuleiro, bola, raquete)
            setProp(jogo,"vitoria",.F.)
            ? "PERDEU!!!!"
            exit
        endif

        if ganhou(jogo)
            setProp(jogo,"vitoria",.T.)
            ? "GANHOU!!!!"
            exit
        endIf

    endDo
    set cursor on

return

function main()

    local continua := .T.

    do while continua
        StartGame()
        continua = Confirm("Iniciar uma nova partida?")
    end
    cls
    ? "Bye!"

return