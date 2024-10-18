#!/bin/bash

# Primer pas: Elimina la columna 12 i es queda només amb les columnes 1 a l'11 i de la 13 a la 15.
# El resultat es guarda a primer_pas.csv.
cut -d',' -f1-11,13-15 supervivents.csv > primer_pas.csv


#Segon pas: Elimina les files on la columna 14 (ratings_disabled) és igual a "True".
# Guarda el resultat a segon_pas.csv.
awk -F ',' '$14 != "True" {print $0}' primer_pas.csv > segon_pas.csv

# Calcula el nombre de files abans i després d'aplicar el filtre del segon pas.
# Després, resta el nombre de files per saber quantes files s'han eliminat.
L1=$(wc -l < primer_pas.csv)  # Compta el nombre de línies a primer_pas.csv
L2=$(wc -l < segon_pas.csv)   # Compta el nombre de línies a segon_pas.csv
Resta=$((L1 - L2))            # Calcula la diferència de files
echo "Les files eliminades són: $Resta" >> segon_pas.csv  # Escriu el nombre de files eliminades al final de segon_pas.csv


# Tercer pas: Afegeix una nova columna anomenada "ranking_Views" per classificar els vídeos segons les visualitzacions.
# Si les visualitzacions són més de 10 milions, assigna "Estrella".
# Si les visualitzacions són iguals o menors a 1 milió, assigna "Excel·lent".
# En altres casos, assigna "Bo".
awk 'BEGIN { FS=","; OFS="," }
NR==1 { $15="ranking_Views"; print $0; next }  # Afegeix l'encapçalament "ranking_Views"
{
  if ($8 > 10000000)
    $15 = "Estrella";
  else if ($8 <= 1000000)
    $15 = "Excel·lent";
  else
    $15 = "Bo";
  print $0
}' segon_pas.csv > tercer_pas.csv


# Quart pas: Calcula el percentatge de "likes" i "dislikes" respecte a les visualitzacions i crea un arxiu final amb els resultats.
# Crea l'arxiu de sortida sortida.csv amb l'encapçalament adequat.
input_file="tercer_pas.csv"
output_file="sortida.csv"
echo "video_id,trending_date,title,channel_title,category_id,publish_time,tags,views,likes,dislikes,comment_count,comments_disabled,ratings_disabled,video_error_or_removed,ranking_Views,Rlikes,Rdislikes" > "$output_file"

# Recorre l'arxiu tercer_pas.csv fila per fila i calcula el percentatge de likes i dislikes respecte a les visualitzacions.
# Si les visualitzacions són 0, assigna 0 a Rlikes i Rdislikes per evitar divisió per zero.
while IFS=',' read -r video_id trending_date title channel_title category_id publish_time tags views likes dislikes comment_count comments_disabled ratings_disabled video_error_or_removed ranking_Views; do
# Salta la primera línia (encapçalament)
  if [ "$video_id" == "video_id" ]; then
    continue
  fi
   views=${views:-0} 
  # Si el camp de visualitzacions està buit o és 0, estableix Rlikes i Rdislikes en 0.
  if [ "$views" == 0 ]; then
    Rlikes=0
    Rdislikes=0
  else
  # Calcula el percentatge de likes i dislikes respecte a les visualitzacions.
    Rlikes=$(( (likes * 100) / views ))
    Rdislikes=$(( (dislikes * 100) / views ))
  fi
# Escriu la fila amb les noves dades al fitxer de sortida.
  echo "$video_id,$trending_date,$title,$channel_title,$category_id,$publish_time,$tags,$views,$likes,$dislikes,$comment_count,$comments_disabled,$ratings_disabled,$video_error_or_removed,$ranking_Views,$Rlikes,$Rdislikes" >> "$output_file"
done < "$input_file"


# Cinquè pas: Si es proporciona un argument al script, busca coincidències a sortida.csv i mostra un resum dels vídeos.
if [ -n "$1" ]; then
  input="$1"
  if [ ! -f sortida.csv ]; then
    echo "L'arxiu sortida.csv no existeix."
    exit 1
  fi
  resultat=$(grep -i "$input" sortida.csv)
  if [ -z "$resultat" ]; then
    echo "No s'han trobat coincidències."
  else
    echo "$resultat" | while IFS=',' read -r video_id trending_date title channel_title category_id publish_time tags views likes dislikes comment_count comments_disabled ratings_disabled video_error_or_removed ranking_Views Rlikes Rdislikes; do
      echo "Title: $title"
      echo "Publish_time: $publish_time"
      echo "Views: $views"
      echo "Likes: $likes"
      echo "Dislikes: $dislikes"
      echo "Ranking_Views: $ranking_Views"
      echo "Rlikes: $Rlikes"
      echo "Rdislikes: $Rdislikes"
    done
  fi
  exit
fi
