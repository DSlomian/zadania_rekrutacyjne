'''
Dane, które otrzyma³em by³y zbyt du¿e by Rstuio na moim komputerze to uci¹g³o. Dlatego podzieli³em
dane w bashu za pomoc¹ komendy:
awk -F '\t' '{if($1 == 1) print $7 "^" $8 "^" $10}' CPCT02220079.annotated.processed.vcf > chr1.vcf
Tym sposobem wyodrêbni³em dane dla pierwszego chromosomu i wyci¹gna³em tylko potrzebne mi dane
tzn. kolumny "Filter" "Info" "Genotypes". u¿y³em separatora "^" by móc tak wydorêbnione dane i
wczytaæ do pakietu R. Kod dzia³a dla poszczególnego chromosomu ale zadzia³a³by dla ca³ych danych
po przefiltrowaniu dan¹ komend¹ troszkê j¹ modyfikuj¹c.
Dane po przefiltrowaniu:
https://drive.google.com/open?id=1kBbPtcxgYD46hmFtavsWi2iqkV_oqYBJ
'''
library(stringr)
#wczytywanie danych i nazwanie kolumn
data=read.table(file.choose(), header = F, sep="^")
colnames(data) = c("Filter","Info","Genotypes")

#usuniêcie danych, które maj¹ inne wartoœci w kolumnie Filter ni¿ PASS
data = data[!data$Filter != "PASS",]

#Pêtla dziêki której zmienna heterozygus przjmuje wartoœæ jeden gdy genotyp jest heterozygotyczny 0/1
data$heterozygus = 0
for (i in 1:dim(data)[1]){
  if ("0/1" %in% strsplit(as.character(data$Genotypes[i]),":")[[1]]){
    data$heterozygus[i] = 1
  }
}
#Usuniêcie wierszy których genotypy s¹ inne ni¿ heterozygotyczne
data = data[!data$heterozygus == 0,]

#Sprawdzenie czy w kolumnie info znajdujê siê adnotacja GoNLv5_AF, co zonacza warianty o niskiej 
#czêstoœci czyli takie które nas interesuj¹
Final = str_detect(data$Info, "GoNLv5_AF")

#Podsumowujemy zmienna FINAL.
summary(Final)
#Z podsumowania wysz³o, ¿e w chromosomie pierwszym liczba heterozygotycznych wariantów z czêstoœci¹
#wystêpowania mniejsza od 0.01 wynosi 164870 o czym mówi wartoœæ TRUE
