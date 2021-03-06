'''
Dane, kt�re otrzyma�em by�y zbyt du�e by Rstuio na moim komputerze to uci�g�o. Dlatego podzieli�em
dane w bashu za pomoc� komendy:
awk -F '\t' '{if($1 == 1) print $7 "^" $8 "^" $10}' CPCT02220079.annotated.processed.vcf > chr1.vcf
Tym sposobem wyodr�bni�em dane dla pierwszego chromosomu i wyci�gna�em tylko potrzebne mi dane
tzn. kolumny "Filter" "Info" "Genotypes". u�y�em separatora "^" by m�c tak wydor�bnione dane i
wczyta� do pakietu R. Kod dzia�a dla poszczeg�lnego chromosomu ale zadzia�a�by dla ca�ych danych
po przefiltrowaniu dan� komend� troszk� j� modyfikuj�c.
Dane po przefiltrowaniu:
https://drive.google.com/open?id=1kBbPtcxgYD46hmFtavsWi2iqkV_oqYBJ
'''
library(stringr)
#wczytywanie danych i nazwanie kolumn
data=read.table(file.choose(), header = F, sep="^")
colnames(data) = c("Filter","Info","Genotypes")

#usuni�cie danych, kt�re maj� inne warto�ci w kolumnie Filter ni� PASS
data = data[!data$Filter != "PASS",]

#P�tla dzi�ki kt�rej zmienna heterozygus przjmuje warto�� jeden gdy genotyp jest heterozygotyczny 0/1
data$heterozygus = 0
for (i in 1:dim(data)[1]){
  if ("0/1" %in% strsplit(as.character(data$Genotypes[i]),":")[[1]]){
    data$heterozygus[i] = 1
  }
}
#Usuni�cie wierszy kt�rych genotypy s� inne ni� heterozygotyczne
data = data[!data$heterozygus == 0,]

#Sprawdzenie czy w kolumnie info znajduj� si� adnotacja GoNLv5_AF, co zonacza warianty o niskiej 
#cz�sto�ci czyli takie kt�re nas interesuj�
Final = str_detect(data$Info, "GoNLv5_AF")

#Podsumowujemy zmienna FINAL.
summary(Final)
#Z podsumowania wysz�o, �e w chromosomie pierwszym liczba heterozygotycznych wariant�w z cz�sto�ci�
#wyst�powania mniejsza od 0.01 wynosi 164870 o czym m�wi warto�� TRUE
