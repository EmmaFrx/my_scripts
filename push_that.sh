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

branch_name=$(git rev-parse --abbrev-ref HEAD)

read -p "Do you want to commit changes on the current branch '$branch_name' ? (Y/n) :" commit_choice

if [ "$commit_choice" = "n" ] || [ "$commit_choice" = "N" ]; then
    handle_error "Please go on the right branch."
fi

read -e -i "" -p "Do you have specific files to add ? (y/N): " add_files

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
> 3 -> for a removal --> [-] " commit_mode

if [ -n "$commit_mode" ]; then
    commit_mode="1"
fi

if [ "$commit_mode" == "3" ]; then
    commit_mode="[-] delete -->"
elif [ "$commit_mode" == "2" ]; then
    commit_mode="[+] add -->"
else
    commit_mode="[~] update -->"
fi

read -e -i "" -p "Enter commit message: " commit_message

if [ -z "$commit_message" ]; then
    commit_message="update -> update file(s)"
fi

git commit -m "$commit_mode $commit_message" &> /dev/null
git push origin "$branch_name"

read -p "Do you want to merge these changes into the main branch ? (y/N) :" merge_choice

if [ "$merge_choice" = "y" ] || [ "$merge_choice" = "Y" ]; then
    git checkout main
    git merge --no-ff "$branch_name"
    git push origin main
    git checkout "$branch_name"
fi

    echo success_message "Changes merged successfully into the main branch"

echo -e "\033[1;35mGood job :)\033[0m"
