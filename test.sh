#!/bin/bash

if [ $# -ne 2 ]; then
	echo "Usage: $0 [InputFile] [OutputName]" 1>&2
	exit 1
fi

#区切り文字を設定
IFS=','

#行だかの名前
jn=("A" "B" "C" "D")

#ファイルを配列に突っ込む
#ついでに\nを,にしておく。どうせ4つで1行というのは固定なのだ
array=(`cat $1 | tr '\n' ','`)

#きちんと読めたかチェック
for ((i=0;i<${#array[*]};i++))
do
	echo ${array[i]}
	echo
done

#worksheet/dimensionを決めとく
dimension=`expr ${#array[*]} / 4`
#echo $dimension

#本体出力（前）
hontai=`cat hina1`$dimension`cat hina2`

#本体出力（中身）
for ((i=0;i<`expr ${#array[*]} / 4`;i++))
do
	hontai=$hontai'<row r="'
	hontai=$hontai`expr $i + 1`
	hontai=$hontai'" customFormat="false" ht="12.8" hidden="false" customHeight="false" outlineLevel="0" collapsed="false">'

	for ((j=0;j<4;j++))
	do
		hontai=$hontai'<c r="'
		hontai=$hontai"${jn[j]}"
		hontai=$hontai"`expr $i + 1`"
		hontai=$hontai'" s="0" t="n">'
		hontai=$hontai'<v>'
		te=`expr $i \* 4 + $j`
		hontai=$hontai"${array[$te]}"
		hontai=$hontai'</v></c>'
	done

	hontai=$hontai'</row>'
done

#本体出力（後）
hontai=$hontai`cat hina3`


#雛形もってくる
unzip hina.zip -d hina

#そこに本体を突っ込む
echo $hontai > ./hina/xl/worksheets/sheet1.xml

#圧縮
cd hina
zip hoi -r ./
mv hoi.zip ../hoi.zip

#xlsxにする
cd ../
mv hoi.zip $2

#お片づけ
rm -R ./hina

exit
