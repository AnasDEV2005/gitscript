
#!/bin/bash

configure_remote() {
    if ! git remote | grep -q "origin"; then
        read -p "Enter the remote repository link: " remote_link
        git remote add origin "$remote_link"
    fi
}

git_push() {
    if [ ! -d ".git" ]; then
        echo "Initializing Git repository..."
        git init
    fi

    git add .

    read -p "Enter your commit message: " commit_message
    git commit -m "$commit_message"

    configure_remote

    read -p "Enter the branch name to push (default: master): " branch_name
    branch_name=${branch_name:-master}

    echo "Pushing to remote repository on branch '$branch_name'..."
    git push origin "$branch_name"

    if [ $? -ne 0 ]; then
        echo "Error during push."
        PS3="Choose an option: "
        select option in "Force Push" "Handle Manually"; do
            case $option in
                "Force Push")
                    echo "Forcing push..."
                    git push origin "$branch_name" --force
                    break
                    ;;
                "Handle Manually")
                    echo "Please handle the issue manually."
                    break
                    ;;
                *)
                    echo "Invalid option. Please try again."
                    ;;
            esac
        done
    else
        echo "Push successful!"
    fi
}

PS3="Select an option: "
select choice in "Git Push to Repository" "Quit"; do
    case $choice in
        "Git Push to Repository")
            git_push
            ;;
        "Quit")
            echo "Exiting..."
            break
            ;;
        *)
            echo "Invalid choice. Please try again."
            ;;
    esac
done

