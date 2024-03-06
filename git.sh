#!/bin/sh

handle_error() {
    echo -e "\033[1;31mError:\033[0m $1" >&2
    exit 1
}

# Function to display success messages
success_message() {
    echo -e "\033[1;32m$1\033[0m"
}

git_add() {
    read -e -i "" -p "Please enter space-separated list of files to add: " files_to_add
    if [ ! -z "$files_to_add" ]; then
        git add $files_to_add
        success_message "$files_to_add are added"
    else
        git add *
        success_message "All files are added"
    fi
}

git_branch() {
    git branch
}

git_commit() {
    # Prompt the user to choose a commit mode
    echo -en "Choose an commit mode:
    > (default) 1 -> for a modification --> [refactor]
    > 2 -> for a addition --> [feat]
    > 3 -> for a removal --> [del]
    > 4 -> for a bug --> [fix]
    > 5 -> for amelioration of perfomance --> [perf]
    > 6 -> for coding style --> [style]
    > 7 -> for a test --> [test]
    > 8 -> for documentation --> [docs]
    "
    read -r commit_mode

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
        commit_mode="[style] -->"
    elif [ "$commit_mode" == "7" ]; then
        commit_mode="[test] -->"
    elif [ "$commit_mode" == "8" ]; then
        commit_mode="[docs] -->"
    elif [ "$commit_mode" == "666" ]; then
        commit_mode="[idk_bro] -->"
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
}

git_switch() {
    read -e -i "" -p "Enter branch name: " branch_name
    if [ -z "$branch_name" ]; then
        branch_name="main"
    fi
    if git rev-parse --verify "$branch_name" &>/dev/null; then
      git switch "$branch_name"
    else
      git switch -c "$branch_name"
    fi
}

git_pull() {
    read -e -i "" -p "Enter origin branch :" branch_name
    if [ -z "$branch_name" ]; then
        branch_name="$(git branch | grep \* | cut -d' ' -f 2)"
    fi
    git pull origin "$branch_name"
}


git_push() {
    git push origin $(git branch | grep \* | cut -d' ' -f 2)
}

git_pull_force() {
    read -e -i "" -p "Enter origin branch :" branch_name
    if [ -z "$branch_name" ]; then
        branch_name="$(git branch | grep \* | cut -d' ' -f 2)"
    fi
    git pull origin "$branch_name" -f
}

git_merge() {
    handle_error "todo"
}


git_push_force() {
    git push origin $(git branch | grep \* | cut -d' ' -f 2) -f
}

git_commit_breaking() {
    # Prompt the user to choose a commit mode
    echo -en "Choose an commit mode:
    > (default) 1 -> for a modification --> [refactor]
    > 2 -> for a addition --> [feat]
    > 3 -> for a removal --> [del]
    > 4 -> for a bug --> [fix]
    > 5 -> for amelioration of perfomance --> [perf]
    > 6 -> for coding style --> [style]
    > 7 -> for a test --> [test]
    > 8 -> for documentation --> [docs]
    "
    read -r commit_mode

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
        commit_mode="[style] -->"
    elif [ "$commit_mode" == "7" ]; then
        commit_mode="[test] -->"
    elif [ "$commit_mode" == "8" ]; then
        commit_mode="[docs] -->"
    elif [ "$commit_mode" == "666" ]; then
        commit_mode="[idk_bro] -->"
    else
        commit_mode="[refactor] --> "
    fi

    # Prompt the user to enter a commit message
    read -e -i "" -p "Enter commit message: " commit_message

    # Set default commit message if not provided
    if [ -z "$commit_message" ]; then
        commit_message="update file(s)"
    fi

    # Prompt the user to enter a commit message
    read -e -i "" -p "Enter breaking message: " breaking_message

    # Set default commit message if not provided
    if [ -z "$commit_breaking" ]; then
        git commit -m "$commit_mode $commit_message" &> /dev/null
    else
        git commit -m "$commit_mode $commit_message" -m "$breaking_message" &> /dev/null
    fi
}

git_add_all() {
    git add *
}

git_merge_force() {
    handle_error "todo"
}

git_switch() {
    read -e -i "" -p "Enter branch name: " branch_name
    if [ -z "$branch_name" ]; then
        branch_name="main"
    fi
    if git rev-parse --verify "$branch_name" &>/dev/null; then
      git switch "$branch_name" -f
    else
      git switch -c "$branch_name" -f
    fi
}


for char in $(echo "$1" | grep -o .); do
    case $char in
        a)
            git_add
            ;;
        b)
            git_branch
            ;;
        c)
            git_commit
            ;;
        w)
            git_switch
            ;;
        l)
            git_pull
            ;;
        p)
            git_push
            ;;
        L)
            git_pull_force
            ;;
        m)
            git_merge
            ;;
        P)
            git_push_force
            ;;
        C)
            git_commit_breaking
            ;;
        A)
            git_add_all
            ;;
        M)
            git_merge_force
            ;;
        W)
            git_switch_force
            ;;
        *)
            handle_error "Invalid character $char!"
            ;;
    esac
done
