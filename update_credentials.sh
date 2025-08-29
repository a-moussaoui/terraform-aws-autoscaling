#!/bin/bash

# Script to update git credentials for the terraform-aws-autoscaling repository
# This script provides a secure way to change authentication credentials

set -e

echo "Git Credential Update Script for terraform-aws-autoscaling"
echo "==========================================================="

# Function to update git credentials with GitHub token
update_github_token_auth() {
    local username="$1"
    local token_var="$2"
    
    echo "Updating git credentials to use GitHub token authentication..."
    
    # Update git configuration
    git config credential.username "$username"
    git config credential.helper "!f() { test \"\$1\" = get && echo \"password=\$$token_var\"; }; f"
    
    echo "✓ Git credentials updated successfully"
    echo "  Username: $username"
    echo "  Token: Using environment variable \$$token_var"
}

# Function to update git credentials with personal access token
update_personal_access_token() {
    local username="$1"
    
    echo "Updating git credentials to use Personal Access Token..."
    
    # Remove the custom helper and use default credential manager
    git config --unset credential.helper
    git config credential.username "$username"
    
    echo "✓ Git credentials updated to use system credential manager"
    echo "  Username: $username"
    echo "  You'll be prompted for your Personal Access Token on next git operation"
}

# Function to show current configuration
show_current_config() {
    echo "Current Git Configuration:"
    echo "=========================="
    echo "Username: $(git config credential.username 2>/dev/null || echo 'Not set')"
    echo "Helper: $(git config credential.helper 2>/dev/null || echo 'Not set')"
    echo "User Name: $(git config user.name 2>/dev/null || echo 'Not set')"
    echo "User Email: $(git config user.email 2>/dev/null || echo 'Not set')"
    echo ""
}

# Function to update user information
update_user_info() {
    local name="$1"
    local email="$2"
    
    git config user.name "$name"
    git config user.email "$email"
    
    echo "✓ User information updated"
    echo "  Name: $name"
    echo "  Email: $email"
}

# Main menu
main_menu() {
    show_current_config
    
    echo "Select an option:"
    echo "1. Update to use GitHub Token (environment variable)"
    echo "2. Update to use Personal Access Token (interactive)"
    echo "3. Update user information (name and email)"
    echo "4. Show current configuration"
    echo "5. Exit"
    echo ""
    read -p "Enter your choice (1-5): " choice
    
    case $choice in
        1)
            read -p "Enter GitHub username: " username
            read -p "Enter environment variable name for token (default: GITHUB_TOKEN): " token_var
            token_var=${token_var:-GITHUB_TOKEN}
            update_github_token_auth "$username" "$token_var"
            ;;
        2)
            read -p "Enter GitHub username: " username
            update_personal_access_token "$username"
            ;;
        3)
            read -p "Enter your full name: " name
            read -p "Enter your email address: " email
            update_user_info "$name" "$email"
            ;;
        4)
            show_current_config
            ;;
        5)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please try again."
            main_menu
            ;;
    esac
}

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "Error: Not in a git repository"
    exit 1
fi

# Run main menu
main_menu

echo ""
echo "Credential update completed!"
echo "You can run this script again anytime to modify your git credentials."