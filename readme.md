## TRACTAMENT DE DADES AMB SHELL SCRIPTS

### L'objectiu de la pràctica és realitzar un programa a Shell Script (bash) que permeti realitzar la preparació de les dades d'un dataset original.


#### awk -F',' '{ if (NF == 16) print $0 }' CAvideos.csv > supervivents.csv

<!-- lista ordenada -->
1. El primer pas de processament que es vol realitzar consisteix a eliminar les
columnes description i thumbnail_link que no aporten informació rellevant (feu-ho amb l’ordre cut).
    
2. Volem analitzar únicament els vídeos que no continguin error, per això esborrarem els registres on el valor de la columna video_error_or_removed sigui igual a True (això ho heu de fer amb l’ordre awk). El vostre script ha de dir a més quant registres ha eliminat (feu servir l’ordre wc).

3. Per facilitar el processament de les dades, crearem una columna nova (Ranking_Views) en funció de les visualitzacions del vídeo. L'objectiu serà categoritzar les visites de forma qualitativa (feu servir l’ordre awk). Per a això, classificarem els vídeos amb una nova etiqueta segons el nombre de visites (Views)
    Views      |  Ranking_Views  |  
    | ---------|:-----:| 
    | Fins a 1 milió | Bo | 
    | Entre 1 milió i 10 milions | Excel·lent | 
    | Més de 10 milions | Estrella|   

4. Crear dues noves columnes que indiquin la relació (%) del nombre de likes (Rlikes) i dislikes (Rdislikes) en funció del nombre total de visualitzacions. Aquest càlcul el fareu processant l’arxiu línia a línia (estructura iterativa while o for + ordres read, cut, echo + expressions aritmètiques per calcular (likes*100)/views i (dislikes*100)/views).

5. Finalment, si l'script rep com a paràmetre d'entrada un identificador de vídeo o el seu títol (no té perquè estar complet), en lloc de realitzar tot el processament descrit en els passos anteriors (1-4), ha d'imprimir els camps Title, Publish_time, views, likes, dislikes, Ranking_Views, Rlikes i Rdislikes pertanyents al vídeo indicat o, en cas de no trobar-lo, imprimir un missatge indicant que no s'han trobat coincidències (feu servir les ordres grep, cut i echo + estructura de control if). Com podreu notar, la informació que es demana inclou camps que hem generat durant el processament, així que la cerca de la informació la farem sobre l’arxiu sortida.csv (heu de comprovar que existeix)


