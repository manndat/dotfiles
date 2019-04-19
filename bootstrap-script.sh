#!/usr/bin/env bash

check_requirements() {
    echo "=== Checking requirements..."

    local ok=1
    local packages=("git")

    if [ -z "${HOME}" ]; then
        echo "could not determine home directory, please set HOME" >&2
        exit 1
    fi

    if [ -d "${HOME}"/.dotfiles ]; then
        echo "there is a .dotfiles directory in $HOME already, aborting" >&2
        exit 2
    fi

    for package in ${packages[@]}; do
        if ! which $package &> /dev/null; then
            echo "$package is needed for this script" >&2
            ok=0
        fi
    done
    unset package

    if [ $ok -eq 0 ]; then
        echo "Please install the missing package(s) first"
        exit 3
    fi
}

setup_repo() {
    echo "=== Cloning and setting up the repo..."
    local target_dir="${HOME}"/.dotfiles
    git clone --depth=1 https://github.com/cheriimoya/dotfiles.git "${target_dir}"
    pushd "${target_dir}"
    rm bootstrap-script.sh
    popd
}

configure() {
    echo "=== Starting the configuration and customisation..."

    echo -e "\nNext, you'll have to answer a few questions\n"

    local git_name=("your name (for git)" "foo")
    local git_email=("your email (for git)" "foo@bar.com")
    local editor_default=("the default editor" "vim")
    local ethernet_id=("the ethernet interface name" "eth0")
    local wifi_id=("the wifi interface name" "wifi0")
    local font_face=("the default font face" "DejaVu Sans Mono")
    local font_size=("the default font size" "10")
    local keyboard_layout=("your keyboard layout" "us")
    local zsh_theme=("the zsh theme" "muse")

    echo "What is ${git_name[0]}? (default: ${git_name[1]})"
    read git_name[2]; [ -z ${git_name[2]} ] && git_name[2]=${git_name[1]}

    echo "What is ${git_email[0]}? (default: ${git_email[1]})"
    read git_email[2]; [ -z ${git_email[2]} ] && git_email[2]=${git_email[1]}

    echo "What is ${editor_default[0]}? (default: ${editor_default[1]})"
    read editor_default[2]; [ -z ${editor_default[2]} ] && editor_default[2]=${editor_default[1]}

    echo "What is ${ethernet_id[0]}? (default: ${ethernet_id[1]})"
    read ethernet_id[2]; [ -z ${ethernet_id[2]} ] && ethernet_id[2]=${ethernet_id[1]}

    echo "What is ${wifi_id[0]}? (default: ${wifi_id[1]})"
    read wifi_id[2]; [ -z ${wifi_id[2]} ] && wifi_id[2]=${wifi_id[1]}

    echo "What is ${font_face[0]}? (default: ${font_face[1]})"
    read font_face[2]; [ -z ${font_face[2]} ] && font_face[2]=${font_face[1]}

    echo "What is ${font_size[0]}? (default: ${font_size[1]})"
    read font_size[2]; [ -z ${font_size[2]} ] && font_size[2]=${font_size[1]}

    echo "What is ${keyboard_layout[0]}? (default: ${keyboard_layout[1]})"
    read keyboard_layout[2]; [ -z ${keyboard_layout[2]} ] && keyboard_layout[2]=${keyboard_layout[1]}

    echo "What is ${zsh_theme[0]}? (default: ${zsh_theme[1]})"
    read zsh_theme[2]; [ -z ${zsh_theme[2]} ] && zsh_theme[2]=${zsh_theme[1]}

    local target_dir="${HOME}"/.dotfiles

    echo "=== Replacing the placeholders with your values..."
    find "${target_dir}" -type f -exec sed -i "s/{{ git_name }}/${git_name[2]}/" {} \;
    find "${target_dir}" -type f -exec sed -i "s/{{ git_email }}/${git_email[2]}/" {} \;
    find "${target_dir}" -type f -exec sed -i "s/{{ editor_default }}/${editor_default[2]}/" {} \;
    find "${target_dir}" -type f -exec sed -i "s/{{ ethernet_id }}/${ethernet_id[2]}/" {} \;
    find "${target_dir}" -type f -exec sed -i "s/{{ wifi_id }}/${wifi_id[2]}/" {} \;
    find "${target_dir}" -type f -exec sed -i "s/{{ font_face }}/${font_face[2]}/" {} \;
    find "${target_dir}" -type f -exec sed -i "s/{{ font_size }}/${font_size[2]}/" {} \;
    find "${target_dir}" -type f -exec sed -i "s/{{ keyboard_layout }}/${keyboard_layout[2]}/" {} \;
    find "${target_dir}" -type f -exec sed -i "s/{{ zsh_theme }}/${zsh_theme[2]}/" {} \;
}

link() {
    echo "=== Linking files to their destination..."

    local source_dir="${HOME}"/.dotfiles

    what_to_link=(
        "autostart:${HOME}/.config/autostart"
        "config/conky:${HOME}/.config/conky"
        "config/htop/:${HOME}/.config/htop"
        "config/i3:${HOME}/.config/i3"
        "config/polybar:${HOME}/.config/polybar"
        "config/ranger:${HOME}/.config/ranger"
        "config/rofi:${HOME}/.config/rofi"
        "aliases:${HOME}/.aliases"
        "gitconfig:${HOME}/.gitconfig"
        "vim:${HOME}/.vim"
        "vimrc:${HOME}/.vimrc"
        "zshrc:${HOME}/.zshrc"
        "Xresources:${HOME}/.Xresources"
    )

    mkdir -p "${HOME}"/.config/

    for onelink in ${what_to_link[@]}; do
        local from="$(echo ${onelink} | cut -d ":" -f 1)"
        local to="$(echo ${onelink} | cut -d ":" -f 2)"
        echo "Linking ${from} => ${to}..."
        ln -s "${source_dir}"/"${from}" "${to}" 2> /dev/null
        if [ $? -ne 0 ]; then
        echo "[X] Could not link ${to}, moving target to ~/.dotfiles/bak/"
        mv "${to}" "${source_dir}"/bak/
            ln -s "${source_dir}"/"${from}" "${to}"
        fi
    done
}

setup_oh_my_zsh() {
    local oh_my_zsh_path="${HOME}"/.dotfiles/oh-my-zsh
    git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git "${oh_my_zsh_path}"
}

main() {
    # Check prerequisites
    check_requirements
    setup_repo
    setup_oh_my_zsh
    configure
    link
    echo "=== Done with the installation! Enjoy!"
}

install_programs() {
    package_manager_command=""

    if which apt-get &> /dev/null; then
        package_manager_command="sudo apt-get update && sudo apt-get install"
    fi

    if which pacman &> /dev/null; then
        package_manager_command="sudo pacman -Sy && sudo pacman -S"
    fi

    if which nix-env &> /dev/null; then
        package_manager_command="nix-channel --update; nix-env -iA"
    fi

    if [ "$package_manager_command" = "" ]; then
        echo "no supported package manager found, aborting" >&2
        exit 100
    fi
}

if [ "$1" = "--install" ]; then
    install_programs
fi

main
