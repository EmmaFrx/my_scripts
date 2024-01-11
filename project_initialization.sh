#!/bin/bash

# Function to handle errors
handle_error() {
    echo -e "\033[1;31mError:\033[0m $1"
}

# Function for success messages
success_message() {
    echo -e "\033[1;32m$1\033[0m"
}

is_github_repo() {
    git rev-parse --is-inside-work-tree &>/dev/null
}

# Get the GitHub repository name
get_github_repo_name() {
    git config --get remote.origin.url | sed 's/.*\/\([^ ]*\/[^.]*\).*/\1/'
}

create_project_structure() {
    echo -e "\033[1;36mEnter the project name:\033[0m"
    read project_name

    mkdir -p "include" "functions"
    touch "include/$project_name.h"
    uppercase_proj=$(echo "$project_name" | tr '[:lower:]' '[:upper:]')


    cat <<EOL > "include/$project_name.h"
/*
** EPITECH PROJECT, 2024
** $project_name .h
** File description:
** header for $project_name
*/

#pragma once
    #define ${uppercase_proj}_H
EOL

    echo "Enter the lib you want to include (separate with a space): "
    read -e -i "" lib_name

    IFS=' ' read -ra names <<< "$lib_name"

    for name in "${names[@]}"; do
      case "$name" in
          "stdlib")
              echo "Add lib stdlib"
              cat <<EOL >> "include/$project_name.h"
    #include <stdlib.h>
EOL
    ;;

        "stdio")
            echo "Add lib stdio"
            cat <<EOL >> "include/$project_name.h"
    #include <stdio.h>
EOL
    ;;

       "string")
           echo "Add lib string"
           cat <<EOL >> "include/$project_name.h"
    #include <string.h>
EOL
    ;;
       "math")
           echo "Add lib math"
           cat <<EOL >> "include/$project_name.h"
    #include <math.h>
EOL
    ;;
       "stdbool")
          echo "Add lib stdbool"
          cat <<EOL >> "include/$project_name.h"
    #include <stdbool.h>
EOL
    ;;
       "stdint")
          echo "Add lib stdint"
          cat <<EOL >> "include/$project_name.h"
    #include <stdint.h>
EOL
    ;;
  *)
    echo "what is this lib bro?"
    ;;
  esac
done

    cat <<EOL > "Makefile"
##
## EPITECH PROJECT, 2024
## Makefile
## File description:
## Makefile for $project_name
##

NAME = $project_name

CC = gcc

FLAGS =  -Wall -Wextra -Wno-unused-value -Wno-sign-compare \
			    -Wno-unused-parameter -I./include

SRC = \$(shell find ./ -type f -name "*.c")

OBJ = \$(SRC:./%.c=./obj/%.o)

all: \$(NAME)

\$(NAME):    \$(OBJ)
             \$(CC) \$(FLAGS) -o \$(NAME) \$(OBJ)

./obj/%.o: ./%.c
        @mkdir -p \$(dir \$@)
        @\$(CC) -c -o \$@ \$< \$(FLAGS)

clean:
        @rm -rf obj

fclean: clean
        @rm -f \$(NAME)

re: fclean all

EOL

    sed -i "s/    /\t/gi" Makefile


    cat > "main.c" <<EOL
/*
** EPITECH PROJECT, 2024
** main.c
** File description:
** main.c for $project_name
*/

#include "include/$project_name.h"

int main(int argc, char **argv)
{
    return 84;
}

EOL

~/my_scripts/functions_need.sh "$project_name"
}

if is_github_repo; then
    create_project_structure
    success_message "Project structure created in $(pwd)."
else
    echo -e "\033[1;36mYou are not in a GitHub repository. Do you want to create the structure here ? (y/n) \033[0m"
    read create_here

    if [ "$create_here" == "y" ] || [ "$create_here" == "Y" ] || [ "$create_here" == "Yes" ] || [ "$create_here" == "yes" ]; then
        create_project_structure
        success_message "Project structure created in $(pwd)."
    else
        handle_error "No changes made."
    fi
fi
