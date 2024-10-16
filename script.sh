#!/bin/bash
awk -F',' '{ if (NF == 16) print $0 }' CAvideos.csv > supervivents.csv

# Primer paso
cut -d',' -f1-11,13-15 supervivents.csv > primer_pas.csv

# Segundo paso
awk -F ',' '$14 != "True" {print $0}' primer_pas.csv > segon_pas.csv


L1=$(wc -l < primer_pas.csv)
L2=$(wc -l < segon_pas.csv)
Resta=$((L1 - L2))
echo "Les files eliminades son: $Resta" >> segon_pas.csv

#Tercer pas
awk 'BEGIN { FS=","; OFS="," }
NR==1 { $15="ranking_Views"; print $0; next }
{
  if ($8 > 10000000)
    $15 = "Estrella";
  else if ($8 <= 1000000)
    $15 = "Excel·lent";
  else
    $15 = "Bo";
  print $0
}' segon_pas.csv > tercer_pas.csv

#Quart pas
input_file="tercer_pas.csv"
output_file="sortida.csv"


echo "video_id,trending_date,title,channel_title,category_id,publish_time,tags,views,likes,dislikes,comment_count,comments_disabled,ratings_disabled,video_error_or_removed,ranking_Views,Rlikes,Rdislikes" > "$output_file"


while IFS=',' read -r video_id trending_date title channel_title category_id publish_time tags views likes dislikes comment_count comments_disabled ratings_disabled video_error_or_removed ranking_Views; do
  if [ "$video_id" == "video_id" ]; then
    continue
  fi
   views=${views:-0} 
  if [ "$views" == 0 ]; then
    Rlikes=0
    Rdislikes=0
  else
    Rlikes=$(( (likes * 100) / views ))
    Rdislikes=$(( (dislikes * 100) / views ))
  fi

  echo "$video_id,$trending_date,$title,$channel_title,$category_id,$publish_time,$tags,$views,$likes,$dislikes,$comment_count,$comments_disabled,$ratings_disabled,$video_error_or_removed,$ranking_Views,$Rlikes,$Rdislikes" >> "$output_file"
done < "$input_file"


#Cinquè pas
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
  exit 0
fi

