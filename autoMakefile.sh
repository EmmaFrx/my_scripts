#!/bin/bash

MAKEFILE="Makefile"

if [ "$#" -ne 1 ]; then
    echo "We need the name of the binary"
    exit 1
fi

if [ -f "$MAKEFILE" ]; then
    rm "$MAKEFILE"
fi

touch "$MAKEFILE"

echo "##" >> "$MAKEFILE"
echo "## EPITECH PROJECT, 2024" >> "$MAKEFILE"
echo "## Makefile" >> "$MAKEFILE"
echo "## File description:" >> "$MAKEFILE"
echo "## Makefile for compilation" >> "$MAKEFILE"
echo "##" >> "$MAKEFILE"

echo "" >> "$MAKEFILE"
echo "NAME = $1" >> "$MAKEFILE"

echo "" >> "$MAKEFILE"
echo "CC = gcc" >> "$MAKEFILE"

echo "" >> "$MAKEFILE"
echo "CFLAGS = -Wall -Wextra -Werror\\" >> "$MAKEFILE"
echo "               -I./include/" >> "$MAKEFILE"

echo "" >> "$MAKEFILE"
echo "SRC = src/main.c \\" >> "$MAKEFILE"
find . -type f -name "*.c" | while read -r file; do
    if [ "$(basename "$file")" != "main.c" ]; then
        file_path="${file#./}"
        echo "    $file_path \\" >> "$MAKEFILE"
    fi
done

echo "" >> "$MAKEFILE"
echo "OBJ = \$(SRC:.c=.o)" >> "$MAKEFILE"

echo "" >> "$MAKEFILE"
echo "all: \$(NAME)" >> "$MAKEFILE"

echo "" >> "$MAKEFILE"
echo "\$(NAME): \$(OBJ)" >> "$MAKEFILE"
echo "          \$(CC) \$(CFLAGS) -o \$(NAME) \$(OBJ)" >> "$MAKEFILE"

echo "" >> "$MAKEFILE"
echo "clean:" >> "$MAKEFILE"
echo "          @rm -f \$(OBJ)" >> "$MAKEFILE"

echo "" >> "$MAKEFILE"
echo "fclean: clean" >> "$MAKEFILE"
echo "              @rm -f \$(NAME)" >> "$MAKEFILE"

echo "" >> "$MAKEFILE"
echo "re: fclean all" >> "$MAKEFILE"


sed -i "s/    /\t/gi" Makefile
