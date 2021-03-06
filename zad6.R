'''
Dane, kt�re otrzyma�em by�y zbyt du�e by Rstuio na moim komputerze to uci�g�o. Dlatego podzieli�em
dane w bashu na dwa pliki odpowiadaj�ce chromosomowi 1 i 2 za pomoc� komend:
awk -F '\t' '{if($1 == 1) print $1 "^" $8}' CPCT02220079.annotated.processed.vcf > chr1_zad6.vcf
awk -F '\t' '{if($1 == 1) print $1 "^" $8}' CPCT02220079.annotated.processed.vcf > chr2_zad6.vcf
Tym sposobem wyodr�bni�em dane dla pierwszego i drugiego chromosomu i wyci�gna�em tylko potrzebne mi dane
tzn. kolumny "Chromosom" i info. u�y�em separatora "^" by m�c tak wydor�bnione dane i
wczyta� do pakietu R. Gdybym m�g� pracowa� na ca�ych danych i m�j komputer by to uci�gna� kroki co 
do wyodr�bnienia danych by�y by takie same a na ko�cu zamiast ��czy� dane z dw�ch plik�w jak w tym 
przypadku, wszystkie informacje wyci�gna�bym z jednego data.frameu wcze�niej wydor�bnionego w bashu
wybieraj�c tylko potrzebne mi informacje.
Dane po przefiltrowaniu:
https://drive.google.com/open?id=1ruwf0oWF6XdLG_cE8tXipH9_n0Po8SuU
'''
library(stringr)
library(gsubfn)
library(ggplot2)
#wczytywanie danych i nazwanie kolumn
data1=read.table(file.choose(), header = F, sep="^")
colnames(data1) = c("Chromosom","Info")
#Tworzenie nowej kolumny potrzebnej do wyodr�bnienia DP
data1$DP= 0
data1$Info = as.character(data1$Info)
#Wybranie z info warto�ci DP kt�ra odpowiada za  pokrycie 
data1$DP=strapplyc(data1$Info, "DP=(.*)", simplify = TRUE)
# W poprzednim kroku dostali�my string, gdzie na 1 miejscu jest liczba DP, p�tla usuwa niepotrzebne
#nam informacje i zostawia sam� warto�� DP
for (i in 1:dim(data1)[1]){
  data1$DP[i] = strsplit(as.character(data1$DP[i]),";")[[1]][1]
}
data1$DP=as.numeric(data1$DP)

#Dla danych z pliku drugiego post�pujemy analogicznie
data2=read.table(file.choose(), header = F, sep="^")
colnames(data2) = c("Chromosom","Info")
data2$DP= 0
data2$Info = as.character(data2$Info)
data2$DP=strapplyc(data2$Info, "DP=(.*)", simplify = TRUE)
for (i in 1:dim(data2)[1]){
  data2$DP[i] = strsplit(as.character(data2$DP[i]),";")[[1]][1]
}
data2$DP=as.numeric(data2$DP)
#Przerobienie danych potrzebnych do narysowania histogramu
chr1 = data.frame("1",mean(data1$DP))
colnames(chr1) = c("Chromosom","Depth_of_coverage")
chr2 = data.frame("2",mean(data2$DP))
colnames(chr2) = c("Chromosom","Depth_of_coverage")
Final = rbind(chr1,chr2)

#Rysowanie wykresu
ggplot(Final, aes(x=Chromosom, y=Depth_of_coverage)) + 
  geom_bar(stat="identity", position="dodge")

#Zapisanie danych do pliku .csv
write.csv2(Final, file="Final_zad6_table.csv")

  