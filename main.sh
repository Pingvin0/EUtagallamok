#!/bin/bash
j=0
year=()
country=()
declare -A STAT
while IFS= read -r line
do
	k=0
	OIFS=$IFS
	IFS=";"
	for i in $line
	do
		if [ $k -eq 0 ]; then
			country+=($i)
		else
			year+=($i)
		fi
		k=$((k+1))
	done
	IFS=$OIFS
	j=$((j+1))
done < "EUcsatlakozas.txt"

TAGALLAMOK_2018=0
TAGALLAMOK_2007=0
MAJUS=0
UTOLJARA_DATUM=0
UTOLJARA_ORSZAG=0

for((i = 0 ; i < ${#year[@]} ; i++)); do
	datum=${year[i]}
	ev=${year[i]::4}

	if [ $ev -le 2018 ]; then
		TAGALLAMOK_2018=$((TAGALLAMOK_2018+1))
	fi
	if [ $ev -eq 2007 ]; then
		TAGALLAMOK_2007=$((TAGALLAMOK_2007+1))
	fi
	if [ "${country[i]}" == "Magyarország" ]; then
		MAGYARORSZAG_DATUM=${year[i]}
	fi
	honap=$(echo $datum | cut -c6-7)
	if [ "$honap" == "05" ]; then
		MAJUS=1
	fi

	datum_mp=$(date -d ${datum//"."/"-"} +%s)
	if [ $datum_mp -gt $UTOLJARA_DATUM ]; then
		UTOLJARA_DATUM=$datum_mp
		UTOLJARA_ORSZAG=${country[i]}
	fi
done

echo "3. feladat: EU tagállamainak száma: $TAGALLAMOK_2018 db"
echo "4. feladat: 2007-ben $TAGALLAMOK_2007 ország csatlakozott."
echo "5. feladat: Magyarország csatlakozásának dátuma: $MAGYARORSZAG_DATUM"

if [ $MAJUS -eq 1 ]; then
	echo "6. feladat: Májusban volt csatlakozás!"
else
	echo "6. feladat: Májusban nem volt csatlakozás!"
fi

echo "7. feladat: Legutoljára csatlakozott ország: $UTOLJARA_ORSZAG"
