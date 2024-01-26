#!/bin/bash

handle_error() {
    echo -e "\033[1;31mError:\033[0m $1"
    exit 1
}

success_message() {
    echo -e "\033[1;32m$1\033[0m"
}

if [ -e .gitignore ]; then
    success_message "gitignore found."
    git add .gitignore
else
    handle_error "gitignore not found."
fi

read -e -i "" -p "Do you have specific files to add ? (y/N): " add_files

if [ -n "$add_files" ]; then
    add_files="n"
fi

if [ "$add_files" == "y" ] || [ "$add_files" == "Y" ]; then
    read -e -i "" -p "Please enter space-separated list of files to add: " files_to_add
    git add $files_to_add
    success_message "$files_to_add are added"
else
    git add *
    success_message "All files are added"
fi

read -ei "" -p "Choose an commit mode:
> (default) 1 -> for a modification --> [~]
> 2 -> for a addition --> [+]
> 3 -> for a removal --> [-]" commit_mode

if [ -n "$commit_mode" ]; then
    commit_mode="1"
fi

if [ "$commit_mode" == "1" ]; then
    commit_mode="[~]"
elif [ "$commit_mode" == "2" ]; then
    commit_mode="[+]"
else
    commit_mode="[~]"
fi

read -e -i "" -p "Enter commit message: " commit_message

if [ -z "$commit_message" ]; then
    commit_message="update -> update file(s)"
fi

git commit -m "$commit_mode $commit_message" &> /dev/null
if git push &> /dev/null; then
    handle_error "Error: Push Failed!"
fi
echo -e "\033[1;35mGood job :)\033[0m"#!/bin/bash

handle_error() {
    echo -e "\033[1;31mError:\033[0m $1"
    exit 1
}

success_message() {
    echo -e "\033[1;32m$1\033[0m"
}

if [ -e .gitignore ]; then
    success_message "gitignore found."
    git add .gitignore
else
    handle_error "gitignore not found."
fi

echo "You are in this branch :"
git branch

read -e -i "" -p "Do you want to push here ? (Y/n) " branch_choice

if [ "$branch_choice" == "N" ] [ "$branch_choice" == "n" ]; then
    handle_error "then switch branch."
fi

read -e -i "" -p "Do you have specific files to add ? (y/N): " add_files

if [ -n "$add_files" ]; then
    add_files="n"
fi

if [ "$add_files" == "y" ] || [ "$add_files" == "Y" ]; then
    read -e -i "" -p "Please enter space-separated list of files to add: " files_to_add
    git add $files_to_add
    success_message "$files_to_add are added"
else
    git add *
    success_message "All files are added"
fi

read -e -i "" -p "Enter commit message: " commit_message

if [ -z "$commit_message" ]; then
    commit_message="[~] update -> update file(s)"
fi

git commit -m "$commit_message" &> /dev/null
git push
echo -e "\033[1;35mGood job :)\033[0m"
