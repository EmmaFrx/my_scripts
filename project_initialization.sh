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

    cat > "Makefile" <<EOL
##
## EPITECH PROJECT, 2023
## Makefile
## File description:
## Makefile for $project_name
##

NAME =

CC = gcc

FLAGS =  -Wall -Wextra -Wno-unused-value -Wno-sign-compare \
			 -Wno-unused-parameter -I./include

SRC = main.c

OBJ = \$(SRC:.c=.o)

all: \$(NAME)

\$(NAME):    \$(OBJ)
                    \$(CC) \$(FLAGS) -o \$(NAME) \$(OBJ)

clean:
        @rm -f \$(OBJ)

fclean: clean
                @rm -f \$(NAME)

re: fclean all
EOL

    sed -i "s/    /\t/gi" Makefile


    cat > "main.c" <<EOL
/*
** EPITECH PROJECT, 2023
** main.c
** File description:
** main.c for $project_name
*/

#include "include/$project_name.h"

int main(int argc, char **argv)
{
    return 0;
}

EOL
}

if is_github_repo; then
    create_project_structure
    success_message "Project structure created in $(pwd)."
else
    echo -e "\033[1;36mYou are not in a GitHub repository. Do you want to create the structure here ? (y/n) \033[0m"
    read create_here

    if [ "$create_here" == "y" ] || [ "$create_here" == "Y" ]; then
        create_project_structure
        success_message "Project structure created in $(pwd)."
    else
        handle_error "No changes made."
    fi
fi
