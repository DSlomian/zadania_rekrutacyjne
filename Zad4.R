'''
Wyodr�bni�em rekordy z delecj� i insercja przy u�yciu programu bedops2.4 do dw�ch nowych plik�w .vcf
Komendy:
vcf2bed --deletions < CPCT02220079.annotated.processed.vcf > deletions.vcf
vcf2bed --insertions < CPCT02220079.annotated.processed.vcf > insertion.vcf
Wyodr�bnione dane znajduj� si� na dysku:
https://drive.google.com/open?id=1luj_xgo5B1EHBcxhL0wHggDsOBSrmP35
W za��czniku zad4_plot.PDF znajduje si� wygenerowany wykres
'''

#Wczytanie bibliotek i danych
library(ggplot2)
library(stats)
delecje <- read.table(file.choose(), header=F)
insercje <- read.table(file.choose(), header=F)
#usuni�cie niepotrzebnych danych
insercje = insercje[!insercje$V1 == "MT",]
#Tworzenie danych sk�adaj�cych si� z sumy d�ugo�ci insercji b�d� delecji dla poszczeg�lnych chromosom�w
insercje$dl_ins = abs(insercje$V3 - insercje$V2)
insercje_sum=aggregate(insercje$dl_ins,by=list(insercje$V1), FUN='sum')
insercje_sum$INSERCJA = "Insercja"
colnames(insercje_sum) = c("Chromosom","D�ugo��","INS_DEL")
delecje$dl_del = abs(delecje$V3 - delecje$V2)
delecje_sum=aggregate(delecje$dl_del,by=list(delecje$V1), FUN='sum')
delecje_sum$DELECJE = "Delecja"
colnames(delecje_sum) = c("Chromosom","D�ugo��","INS_DEL")
#tworzenie ko�cowych danych
Final = rbind(insercje_sum,delecje_sum)
#Rysowanie wykresu
ggplot(Final, aes(x=Chromosom, y=D�ugo��, fill=INS_DEL)) + 
  geom_bar(stat="identity", position="dodge") +
  scale_fill_manual(values = c("red","blue"))


