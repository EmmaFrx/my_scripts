#!/bin/bash

name_project=$1

echo "Enter the functions you want (separate with a space): "
read -e -i "" function_need

#split the input into an array
IFS=' ' read -ra names <<< "$function_need"

#parsing ?
for name in "${names[@]}"; do
  case "$name" in
      "my_putchar")
          echo "Add my_putchar.c into the directory functions"

          cat > "functions/my_putchar.c" <<EOL
/*
** EPITECH PROJECT, 2024
** my_putchar.c
** File description:
** my_putchar.c for $name_project
*/

#include "$name_project.h"

void my_putchar(char c)
{
    write(1, &c, 1);
}
EOL
    ;;

      "my_putstr")
        echo "Add my_putstr.c into the directory functions"

        cat > "functions/my_putstr.c" <<EOL
/*
** EPITECH PROJECT, 2024
** my_putstr.c
** File description:
** my_putstr.c for $name_project
*/

#include "$name_project.h"

int my_putstr(char const *str)
{
    int i = 0;

    while (str[i] != '\0'){
        my_putchar(str[i]);
        i++;
    }
    return 0;
}
EOL

        ;;

    #Add other cases for each function
    *)
        echo "What is $name ? "
        ;;
    esac
done