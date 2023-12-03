#!/bin/sh -
AS_PATH=../has/

line=`$AS_PATH/has bootrom.s | wc -l`
num=`expr 512 - $line` 

$AS_PATH/has bootrom.s > bootrom.s.tmp
for i in `seq 1 $num`
do
    echo 00000000000000000000000000000000 >> bootrom.s.tmp
done

cat bootrom.s.tmp | sed -e "s/	//" | sed -e "s/^\(.*\)$/    \"\1\",/" | sed -e "512s/,//" > bootrom.s.tmp2
rm bootrom.s.tmp

cat iumem_head bootrom.s.tmp2 iumem_tail > iuimem.vhd
rm bootrom.s.tmp2
