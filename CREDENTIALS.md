# Git Credentials Management

This document describes how to manage git credentials for the terraform-aws-autoscaling repository.

## Current Setup

The repository is currently configured with:
- **Username**: `copilot-swe-agent[bot]`
- **Authentication**: GitHub Token via environment variable `$GITHUB_TOKEN`
- **Method**: Custom git credential helper

## Changing Your Account Credentials

### Option 1: Using the Automated Script

Run the provided script to interactively update your credentials:

```bash
./update_credentials.sh
```

This script provides options to:
1. Update to use GitHub Token (environment variable)
2. Update to use Personal Access Token (interactive)
3. Update user information (name and email)
4. Show current configuration

### Option 2: Manual Configuration

#### To use GitHub Token authentication:

```bash
# Set your username
git config credential.username "your-github-username"

# Set credential helper to use environment variable
git config credential.helper "!f() { test \"\$1\" = get && echo \"password=\$GITHUB_TOKEN\"; }; f"

# Update user information
git config user.name "Your Full Name"
git config user.email "your.email@example.com"
```

#### To use Personal Access Token:

```bash
# Remove custom helper
git config --unset credential.helper

# Set your username
git config credential.username "your-github-username"

# Update user information
git config user.name "Your Full Name"
git config user.email "your.email@example.com"
```

## Security Best Practices

1. **Never hardcode credentials** in configuration files
2. **Use environment variables** for tokens when possible
3. **Use Personal Access Tokens** instead of passwords for GitHub authentication
4. **Regularly rotate tokens** and credentials
5. **Use the minimal required permissions** for tokens

## Creating a Personal Access Token

1. Go to GitHub Settings → Developer settings → Personal access tokens
2. Click "Generate new token"
3. Select appropriate scopes (usually `repo` for private repositories)
4. Copy the token immediately (it won't be shown again)
5. Use the token as your password when prompted

## Environment Variables

To use token-based authentication, set the environment variable:

```bash
export GITHUB_TOKEN="your_personal_access_token_here"
```

Add this to your shell profile (`.bashrc`, `.zshrc`, etc.) to make it persistent.

## Troubleshooting

### Authentication Failed
- Verify your token has the correct permissions
- Check that environment variables are properly set
- Ensure your username is correct

### Token Expired
- Generate a new Personal Access Token
- Update the environment variable
- Re-run the credential update script

### Permission Denied
- Verify you have access to the repository
- Check that your token includes necessary scopes
- Confirm your username matches your GitHub account

## Checking Current Configuration

To view your current git configuration:

```bash
git config --list | grep -E "(user|credential)"
```

To test authentication:

```bash
git ls-remote origin
```