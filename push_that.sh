#!/bin/bash

# Function to announce an error and stop the script with an exit 1
handle_error() {
    echo -e "\033[1;31mError:\033[0m $1"
    exit 1
}

# Function to display success messages
success_message() {
    echo -e "\033[1;32m$1\033[0m"
}

display_help() {
    echo "Usage : $0 [options]"
    echo "Description:"
    echo "This script is for pushing files or directories to a GitHub repository."
    echo "Options:"
    echo "   -h, --help   Display the help message"
    exit 0
}

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    display_help
fi

# Check if .gitignore exists, add it to staging if found, or exit with an error message
if [ -e .gitignore ]; then
    success_message "gitignore found."
    git add .gitignore
else
    handle_error "gitignore not found."
fi

# Get the name of the current branch
branch_name=$(git rev-parse --abbrev-ref HEAD)

# Prompt the user if they want to commit changes on the current branch
echo -e -n "Do you want to commit changes on the current branch \e[1m\e[35m'$branch_name'\e[0m ? (Y/n) :"
read commit_choice

# If user chooses not to commit, exit with an error message
if [ "$commit_choice" = "n" ] || [ "$commit_choice" = "N" ]; then
    handle_error "Please go on the right branch."
fi

# Prompt the user if they have specific files to add
read -e -i "" -p "Do you have specific files to add ? (y/N): " add_files

# Add specified files or all files
if [ "$add_files" == "y" ] || [ "$add_files" == "Y" ]; then
    read -e -i "" -p "Please enter space-separated list of files to add: " files_to_add
    git add $files_to_add
    success_message "$files_to_add are added"
else
    git add *
    success_message "All files are added"
fi

# Prompt the user to choose a commit mode
echo -en "Choose an commit mode:
> (default) 1 -> for a modification --> [refactor]
> 2 -> for a addition --> [feat]
> 3 -> for a removal --> [del]
> 4 -> for a bug --> [fix]
> 5 -> for amelioration of perfomance --> [perf]
> 6 -> for conding style --> [cs]
> 7 -> for a test --> [test]
> 8 -> for documentation --> [docs]
"
read -r commit_mode

# Set default commit mode if not provided
if [ -n "$commit_mode" ]; then
    commit_mode="1"
fi

# Map commit mode to symbolic representation
if [ "$commit_mode" == "2" ]; then
    commit_mode="[feat] --> "
elif [ "$commit_mode" == "3" ]; then
    commit_mode="[del] --> "
elif [ "$commit_mode" == "4" ]; then
    commit_mode="[fix] -->"
elif [ "$commit_mode" == "5" ]; then
    commit_mode="[perf] -->"
elif [ "$commit_mode" == "6" ]; then
    commit_mode="[cs] -->"
elif [ "$commit_mode" == "7" ]; then
    commit_mode="[test] -->"
elif [ "$commit_mode" == "8" ]; then
    commit_mode="[docs] -->"
else
    commit_mode="[refactor] --> "
fi

# Prompt the user to enter a commit message
read -e -i "" -p "Enter commit message: " commit_message

# Set default commit message if not provided
if [ -z "$commit_message" ]; then
    commit_message="update file(s)"
fi

# Commit changes with the chosen commit mode and message
git commit -m "$commit_mode $commit_message" &> /dev/null
git push origin "$branch_name"
echo " "

# Prompt the user if they want to merge changes into the main branch
if [ "$branch_name" != "main" ]; then
    read -p "Do you want to merge these changes into the main branch ? (y/N) :" merge_choice
fi

# If user chooses to merge, perform the merge without creating a pull request
if [ -n "$merge_choice" ] && [ "$merge_choice" == "y" ] || [ "$merge_choice" == "Y" ]; then
    git checkout main
    git pull origin main --no-edit
    git merge --no-ff "$branch_name"
    git push origin main
    git checkout "$branch_name"
    success_message "Changes merged successfully into the main branch"
fi


echo -e "\033[1;35mGood job :)\033[0m"
