#!/bin/bash
echo  $EUID
# Function to check if the script is being run with sudo
is_sudo() {
  if [[ $EUID -eq 0 ]]; then
    echo "Script should not be run with sudo"
    exit 1
  fi
}

# user_home=$(getent passwd "$USER" | cut -d: -f6)
# script_dir="$user_home/.local/bin"

# echo "$user_home"
# exit 0

# Function to create the alias
create_alias() {
  local shell_config_file
  if [[ -f ~/.bashrc ]]; then
    shell_config_file=~/.bashrc
  elif [[ -f ~/.zshrc ]]; then
    shell_config_file=~/.zshrc
  else
    echo "No supported shell config file found."
    exit 1
  fi

  alias_name="$1"
  script_path="$2"

  # Check if alias already exists
  if grep -q "alias $alias_name=" "$shell_config_file"; then
    echo "Alias $alias_name already exists."
    exit 0
  fi

  echo "alias $alias_name='. $script_path'" >> "$shell_config_file"
  echo "Alias $alias_name created successfully."
}

# Main script logic
is_sudo

script_url="https://raw.githubusercontent.com/lightsOfTruth/switch-to-directory/main/switchto"
script_name="gotopath"
# temp_dir=$(mktemp -d)
# install_dir="$temp_dir"
install_dir="/usr/local/bin"
echo "Downloading script to $install_dir"

# Download the script
sudo curl -sL "$script_url" | tee "$install_dir/$script_name"

sudo chmod +x "$install_dir/$script_name"

ls -al "$install_dir/$script_name"

# mv "$install_dir/$script_name" "/usr/local/bin/$script_name"

#  [[ $? -ne 0 ]] && echo "Failed to move $install_dir/$script_name" && exit 1

# Make the script executable
sudo chmod +x "$install_dir/$script_name"

# Create an alias
create_alias "ccd" "/usr/local/bin/$script_name"

echo "Script installed successfully. Alias $script_name created."