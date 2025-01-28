#!/usr/bin/env zsh
setopt ERR_EXIT NO_UNSET PIPE_FAIL
exec </dev/tty >/dev/tty 2>/dev/tty

{

# Print banner
echo 'Cloud Security Alliance - Claude Desktop Configuration Script'
echo '--------------------------------------------------------'
echo 'This script will:'
echo '- Check your system compatibility'
echo '- Install/update Docker images'
echo '- Create a Claude Desktop configuration file'
echo ''
echo 'Review the source at:'
echo 'https://github.com/cloudsecurityalliance/CSA-AI-Tool-Setup'
echo '--------------------------------------------------------'
echo ''

# Prompt for confirmation
read "REPLY?Would you like to proceed? (y/N) "
echo ''
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo '❌ Setup cancelled.'
    exit 1
fi

# Rest of the script remains exactly the same...
