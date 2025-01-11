# Installing Xcode, Docker, Homebrew, Python with uv, and Node.js on MacOS

This guide walks you through setting up development tools needed for AI applications on macOS. It assumes you are using Apple Silicon.

## Prerequisites

Before starting, please note:
- You'll need administrator access to your Mac (you'll be prompted for your password)
- Xcode Command Line Tools will be installed if not present
  - This is a large download (several GB)
  - Installation can take 15-30 minutes depending on your internet speed
  - This is required for development tools to work on macOS
- Ensure you have enough disk space (at least 10GB free recommended)

## Installing Xcode

You'll need to Xcode tools at a minimum:

```bash
xcode-select --install
```

## Installing Docker

You'll need Docker desktop. Please note that "Commercial use of Docker Desktop at a company of more than 250 employees OR more than $10 million in annual revenue requires a paid subscription (Pro, Team, or Business)."

[Install Docker on Mac OS](https://docs.docker.com/desktop/setup/install/mac-install/)

### Installing docker images for mcp servers

To find docker images simply search for the name of the provider, e.g. Anthropic provides docker images as "mcp":

```bash
docker search mcp
```

And to install:

```bash
docker pull mcp/fetch
```

## Installing Homebrew

1. Open Terminal
2. Install Homebrew:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Note: During installation:
- You'll be prompted for your password (this is needed for system-wide installation)
- If Xcode Command Line Tools aren't installed, you'll be prompted to install them
- The Xcode installation will take some time - this is normal!

3. After installation, add Homebrew to your PATH:

For Apple Silicon Macs:
```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

For Intel Macs:
```bash
echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/usr/local/bin/brew shellenv)"
```

4. Verify installation:
```bash
brew --version
```

## Installing Python and uv

We'll install Python and use uv for package management as it's significantly faster than pip:

1. Install Python:
```bash
brew install python@3.12
```

2. Install uv:
```bash
brew install uv
```

3. Verify installations:
```bash
python3 --version
uv --version
```

4. Setup ~/.zshrc so you run inside a virtualenv:

```bash
#
# PYTHON BREW SETUP
#
###
#
# PYTORCH AND FRIENDS DON'T HAVE WHEELS FOR 3.13 YET SO USE 3.12
#
# Path to the default virtual environment

VENV_PATH="$HOME/.default_venv"

# Path to Homebrew Python
BREW_PYTHON=$(brew --prefix)/bin/python3.12

# Check if the virtual environment exists; if not, create it
if [ ! -d "$VENV_PATH" ]; then
    echo "Default virtual environment not found. Creating one..."
    $BREW_PYTHON -m venv $VENV_PATH
fi

# Activate the virtual environment
if [ -f "$VENV_PATH/bin/activate" ]; then
    source "$VENV_PATH/bin/activate"
else
    echo "Could not find or activate virtual environment at $VENV_PATH."
fi
```

5. Optional: Set up alias for Python in ~/.zshrc:
```bash
echo 'alias python=python3' >> ~/.zshrc
source ~/.zshrc
```

### Using uv for Package Management

Examples of common uv commands:

```bash
# Install a package
uv pip install requests

# Install multiple packages
uv pip install pandas numpy matplotlib

# Install from requirements file
uv pip install -r requirements.txt

# Upgrade a package
uv pip install --upgrade requests
```

## Installing Node.js

Install Node.js using nvm (Node Version Manager):

1. Install nvm:
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
```

2. Configure shell:
```bash
echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshrc
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.zshrc
echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> ~/.zshrc
```

3. Reload shell configuration:
```bash
source ~/.zshrc
```

4. Install latest LTS Node.js:
```bash
nvm install --lts
```

5. Verify installation:
```bash
node --version
npm --version
```

## Maintenance

### Homebrew Updates
```bash
brew update
brew upgrade
brew cleanup
```

### Python Package Updates
```bash
# Update specific package
uv pip install --upgrade package_name

# Update all packages in requirements.txt
uv pip install --upgrade -r requirements.txt
```

### Node.js Updates
```bash
nvm install lts/* --reinstall-packages-from=current
nvm use lts/*
```

## Troubleshooting

### Homebrew
- Run `brew doctor` to diagnose issues
- Ensure proper permissions on Homebrew directories

### Python/uv
- Use `which python3` to verify Python version
- Check `brew doctor` output for permission issues
- Verify PATH includes Homebrew's bin directory

### Node.js
- Run `nvm current` to verify active Node version
- Use `nvm ls` to list installed versions
- Check `~/.zshrc` contains nvm initialization

## Resources
- [Homebrew](https://brew.sh)
- [uv](https://github.com/astral-sh/uv)
- [nvm](https://github.com/nvm-sh/nvm)
