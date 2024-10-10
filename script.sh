#!/bin/bash

cut -d',' -f1-11,13-15 supervivents.csv > primer_pas.csv 

awk -F ',' '$14 != "True" {print $0}' primer_pas.csv > segon_pas.csv 

L1=$(wc -l < primer_pas.csv) 

L2=$(wc -l < segon_pas.csv) 

Resta= $((L1-L2)) 

echo $Resta 

awk 'BEGIN { FS=","; OFS="," } 
NR==1 { $15="ranking_Views"; print $0; next } 
{ 
    if ($8 > 10000000) 
        $15 = "Estrella"; 
    else if ($8 <= 1000000) 
        $15 = "Excel·lent"; 
    else $15 = "Bo";                                                                                                         
   print $0 
}' segon_pas.csv > tercer_pas.csv 
