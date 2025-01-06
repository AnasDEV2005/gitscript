
#!/bin/bash

# Function to configure Git remote if not already set
configure_remote() {
    if ! git remote | grep -q "origin"; then
        read -p "Enter the remote repository link: " remote_link
        git remote add origin "$remote_link"
    fi
}

# Function to handle Git push
git_push() {
    # Check if Git is initialized
    if [ ! -d ".git" ]; then
        echo "Initializing Git repository..."
        git init
    fi

    # Stage all files
    git add .

    # Prompt for commit message
    read -p "Enter your commit message: " commit_message
    git commit -m "$commit_message"

    # Ensure remote is configured
    configure_remote

    # Push to remote (Git will handle authentication)
    echo "Pushing to remote repository..."
    git push origin main

    # Check for push errors
    if [ $? -ne 0 ]; then
        echo "Error during push."
        PS3="Choose an option: "
        select option in "Force Push" "Handle Manually"; do
            case $option in
                "Force Push")
                    echo "Forcing push..."
                    git push origin main --force
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

# Main menu using `select`
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
