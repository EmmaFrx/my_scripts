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

read -p "Do you have specific files to add ? (y/n):" add_files

if [ "$add_files" == "y" ] || [ "$add_files" == "Y" ]; then
    read -p "Please enter space-separated list of files to add:" files_to_add
    git add $files_to_add
    success_message "$files_to_add are added"
else
    git add .
    success_message "All files are added"
fi

read -p "Enter commit message: " commit_message

if [ -z "$commit_message" ]; then
    commit_message="[~] update -> update file(s)"
fi

git commit -m "$commit_message"
git push
success_message "Good job :)"
