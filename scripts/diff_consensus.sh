#!/usr/bin/env bash
if [ "$#" -ne 4 ] ; then
    echo "USAGE: $0 <consensus1.fasta> <consensus2.fasta> <trim_from_start> <trim_from_end>"; exit 1
fi
tmp="$3"
start=$((tmp+1))
diff <(cat "$1" | grep -v "^>" | tr -d '\n' | sed 's/./\0\n/g' | tail -n "+$start" | head -n "-$4") <(cat "$2" | grep -v "^>" | tr -d '\n' | sed 's/./\0\n/g' | tail -n "+$start" | head -n "-$4")
