#!/bin/bash

if [ $# -eq 0 ]; then
  echo "Usage: $0 <filename>"
  exit 1
fi

filename=$1

echo -e "/*\n** EPITECH PROJECT, 2024\n** FILE\n** File description:\n**\n*/" > "$filename.c"

nano "$filename.c"