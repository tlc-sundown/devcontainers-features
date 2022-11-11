#!/usr/bin/env bash
# references:
# MsQuic: https://github.com/microsoft/msquic
# Linux Software Repository: https://learn.microsoft.com/en-us/windows-server/administration/linux-package-repository-for-microsoft-software

# Stop script on NZEC
set -e

# Exposing stream 3 as a pipe to standard output of the script itself
exec 3>&1

# Setup some colors to use.
# See if stdout is a terminal
if [ -t 1 ] && command -v tput > /dev/null; then
    # see if it supports colors
    ncolors=$(tput colors || echo 0)
    if [ -n "$ncolors" ] && [ $ncolors -ge 8 ]; then
        bold="$(tput bold       || echo)"
        normal="$(tput sgr0     || echo)"
        black="$(tput setaf 0   || echo)"
        red="$(tput setaf 1     || echo)"
        green="$(tput setaf 2   || echo)"
        yellow="$(tput setaf 3  || echo)"
        blue="$(tput setaf 4    || echo)"
        magenta="$(tput setaf 5 || echo)"
        cyan="$(tput setaf 6    || echo)"
        white="$(tput setaf 7   || echo)"
    fi
fi

say() {
    # using stream 3 to not interfere with stdout of functions which may be used as return value
    printf "%b\n" "${cyan:-}msquic_install:${normal:-} $1" >&3
}

say_warning() {
    printf "%b\n" "${yellow:-}msquic_install: Warning: $1${normal:-}" >&3
}

say_err() {
    printf "%b\n" "${red:-}msquic_install: Error: $1${normal:-}" >&2
}

# Ensure apt is in non-interactive mode to avoid prompts
export DEBIAN_FRONTEND=noninteractive

apt_get_update()
{
    if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
        echo "Running apt-get update..."
        apt-get update -y
    fi
}

check_pre_reqs()
{
    local package_list=""

    # Install software-properties-common if necessary
    if [[ -z $(apt-cache --names-only search ^software-properties-common$) ]]; then
        package_list="${package_list} software-properties-common"
    fi

    # Install gnupg if necessary
    if [[ -z $(apt-cache --names-only search ^gnupg$) ]]; then
        package_list="${package_list} gnupg"
    fi

    # Install wget if necessary
    if [[ -z $(apt-cache --names-only search ^wget$) ]]; then
        package_list="${package_list} wget"
    fi

    echo ${package_list}
    return 0
}

apt_get_install_pre_reqs()
{
    # Identifying missing packages
    local package_list="$(check_pre_reqs)" || return 1
    if [ ! -z "${package_list}" ]; then
        # Install pre-reqs packages
        say "Installing packages: [${package_list}]"
        apt-get -y install --no-install-recommends ${package_list}
    fi
    return 0
}

add_microsoft_repo()
{
    # Download gpg armored key
    wget -O- https://packages.microsoft.com/keys/microsoft.asc |\
        gpg --dearmor |\
        tee /usr/share/keyrings/microsoft.gpg > /dev/null
    # Bring in variables from /etc/os-release like VERSION_ID
    . /etc/os-release
    # Add repository into the list of sources
    echo "deb [signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/${ID}/${VERSION_ID}/prod ${VERSION_CODENAME} main" |\
        tee /etc/apt/sources.list.d/packages.microsoft.com.list
    return 0
}

ver()
{
    local version=$(dpkg-query -Wf '${Version}\n' "$1")
    echo "${version}"
    return 0
}

# package to install
package="libmsquic"
# version to install (version is ignored if `latest` is requested)
[ "${version}" = "latest" ] && unset version

say "Configuring the package feed..."
apt_get_update
apt_get_install_pre_reqs
add_microsoft_repo
apt-get update -y
say "[packages.microsoft.com] feed added"

say "Installing ${package}..."
apt-get -y install --no-install-recommends ${package}${version:+=$version}
final_version=$(ver ${package})
say "${package} ${final_version} installed"