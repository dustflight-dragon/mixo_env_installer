#!/bin/bash

env_source_path=/ENV
common_directory=/home/common

function start_environment_installer() {
    directory_checker
    echo "[ENV_INSTLLER_PART] Installing => [directory_checker]"
    get_wget
    echo "[ENV_INSTLLER_PART] Installing => [get_wget]"
    get_snap
    echo "[ENV_INSTLLER_PART] Installing => [get_snap]"
    get_git
    echo "[ENV_INSTLLER_PART] Installing => [get_git]"
    get_miniconda
    echo "[ENV_INSTLLER_PART] Installing => [get_miniconda]"
    get_pip_faster
    echo "[ENV_INSTLLER_PART] Installing => [get_pip_faster]"
    get_cmake_by_apt
    echo "[get_cmake_by_apt] Installing => [get_miniconda]"
    # get_cmake_by_snap
    # echo "[ENV_INSTLLER_PART] Installing => [get_cmake_by_snap]"
    # get_cmake_by_package
    # echo "[ENV_INSTLLER_PART] Installing => [get_cmake_by_package]"
    get_docker_container
    echo "[ENV_INSTLLER_PART] Installing => [get_docker_container]"
    # load_docker_container
    # echo "[ENV_INSTLLER_PART] Installing => [get_docker_container]"
    create_common_directory
    echo "[ENV_INSTLLER_PART] Installing => [create_common_directory]"
}

function directory_checker() {
    if [ ! -d ${env_source_path} ]; then
        sudo mkdir -p ${env_source_path}
        sudo chmod -R 777 ${env_source_path}
        echo "[ROUTER_PATH] Directory => [ ${env_source_path} ] Created Successfully"
    else
        echo "[ROUTER_PATH] Directory => [ ${env_source_path} ] Has Been Created"
    fi
}

function get_wget() {
    sudo apt-get install -y wget
    if [ ! $? -eq 0 ]; then
        echo "[ENV_NOTICE] Packing => [wget] Has Been Installed! Unnecessary Installed It Again"
    else
        echo "[ENV_NOTICE] Packing => [wget] Installed Successfully"
    fi
}

function get_snap() {
    sudo apt install -y snapd snapcraft
    if [ ! $? -eq 0 ]; then
        echo "[ENV_NOTICE] Packing => [snapd] Has Been Installed! Unnecessary Installed It Again"
    else
        echo "[ENV_NOTICE] Packing => [snapd] Installed Successfully"
        subo snap --version
    fi
}

function get_git() {
    sudo apt-get install -y git
    if [ ! $? -eq 0 ]; then
        echo "[ENV_NOTICE] Packing => [git] Has Been Installed! Unnecessary Installed It Again"
    else
        echo "[ENV_NOTICE] Packing => [git] Installed Successfully"
        git --version
    fi
}

function get_miniconda() {
    conda_installer_file=Miniconda3-latest-Linux-x86_64.sh

    if [ ! -f ${env_source_path}/${conda_installer_file} ]; then
        sudo wget https://repo.anaconda.com/miniconda/${conda_installer_file} -P ${env_source_path}
        sudo chmod -R a+x ${env_source_path}/${conda_installer_file}
        echo "[ENTER] Please Enter yes by yourself:"
        sudo sh ${env_source_path}/${conda_installer_file}
        echo "export PATH=~/miniconda3/bin:$PATH" >>~/.bashrc
        source ~/.bashrc
        if [ ! $? -eq 0 ]; then
            echo "[ENV_NOTICE] Packing => [Miniconda3] Installed Invalid"
        else
            echo "[ENV_NOTICE] Packing => [Miniconda3] Installed Successfully"
        fi
    else
        sudo chmod -R a+x ${env_source_path}/${conda_installer_file}
        echo "[ENTER] Please Enter yes by yourself:"
        sudo sh ${env_source_path}/${conda_installer_file}
        echo "export PATH=~/miniconda3/bin:$PATH" >>~/.bashrc
        source ~/.bashrc
        if [ ! $? -eq 0 ]; then
            echo "[ENV_NOTICE] Packing => [Miniconda3] Installed Invalid"
        else
            echo "[ENV_NOTICE] Packing => [Miniconda3] Installed Successfully"
        fi
    fi
}

function get_pip_faster() {
    pip_dir=~/.pip
    pip_conf_path=${pip_dir}/pip.conf

    if [ ! -d ${pip_dir} ]; then
        sudo mkdir -p ${pip_dir}
        sudo touch ${pip_conf_path}
        echo '[global]' >${pip_conf_path}
        echo 'index-url=https://mirrors.aliyun.com/pypi/simple' >>${pip_conf_path}
        echo 'trusted-host=mirrors.aliyun.com' >>${pip_conf_path}
        echo 'timeout=120' >>${pip_conf_path}
    else
        echo "[PIP] PIP Faster Has Been Set Already"
    fi
}

function get_cmake_by_apt() {
    sudo apt-get install -y cmake
    sudo snap install cmake --classic
    if [ ! $? -eq 0 ]; then
        echo "[ENV_NOTICE] Packing => [cmake] Installed Invalid"
    else
        echo "[ENV_NOTICE] Packing => [cmake] Installed Successfully"
        sudo cmake --version
    fi
}

function get_cmake_by_snap() {
    sudo snap search cmake
    sudo snap install cmake --classic
    if [ ! $? -eq 0 ]; then
        echo "[ENV_NOTICE] Packing => [cmake] Installed Invalid"
    else
        echo "[ENV_NOTICE] Packing => [cmake] Installed Successfully"
        sudo cmake --version
    fi
}

function get_cmake_by_package() {
    cmake_installer_version=v3.12
    cmake_installer_file=cmake-3.12.2-Linux-x86_64
    cmake_target_file=/opt/cmake

    if [ ! -f ${cmake_target_file} ]; then
        sudo mkdir -p ${cmake_target_file}
        sudo chmod -R a+x ${cmake_target_file}
        echo "[ROUTER_PATH] Directory => [ ${cmake_target_file} ] Created Successfully"
    else
        echo "[ROUTER_PATH] Directory => [ ${cmake_target_file} ] Create Invalid"
    fi

    if [ ! -f ${env_source_path}/${cmake_installer_file}.tar.gz ]; then
        sudo wget https://cmake.org/files/${cmake_installer_version}/${cmake_installer_file}.tar.gz -P ${env_source_path}
        sudo tar zxvf ${env_source_path}/${cmake_installer_file}.tar.gz
        sudo tree -L 2 ${env_source_path}/${cmake_installer_file}.tar.gz
        sudo mv ${cmake_installer_file} ${cmake_target_file}
        sudo ln -sf ${cmake_target_file}/bin/* /usr/bin/
        if [ ! $? -eq 0 ]; then
            echo "[ENV_NOTICE] Packing => [cmake] Installed Invalid"
        else
            echo "[ENV_NOTICE] Packing => [cmake] Installed Successfully"
            sudo cmake --version
        fi
    else
        sudo tar zxvf ${env_source_path}/${cmake_installer_file}.tar.gz
        sudo tree -L 2 ${env_source_path}/${cmake_installer_file}.tar.gz
        sudo mv ${cmake_installer_file} ${cmake_target_file}
        sudo ln -sf ${cmake_target_file}/bin/* /usr/bin/
        if [ ! $? -eq 0 ]; then
            echo "[ENV_NOTICE] Packing => [cmake] Installed Invalid"
        else
            echo "[ENV_NOTICE] Packing => [cmake] Installed Successfully"
            sudo cmake --version
        fi
    fi
}

function get_docker_container() {
    sudo apt-get install -y docker.io
    if [ ! $? -eq 0 ]; then
        echo "[ENV_NOTICE] Packing => [docker] Installed Invalid"
    else
        echo "[ENV_NOTICE] Packing => [docker] Installed Successfully"
        echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
        echo "=======================[DOCKER_INFO]======================="
        sudo docker info
        echo "=======================[DOCKER_INFO]======================="
        echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    fi
}

function load_docker_container() {
    sudo docker load --input ${env_source_path}/python_container_image.tar
    if [ ! $? -eq 0 ]; then
        echo "[ENV_NOTICE] Packing => [docker] Installed Invalid"
    else
        echo "[ENV_NOTICE] Packing => [docker] Installed Successfully"
        sudo docker ps -a
    fi
}

function create_common_directory() {
    if [ ! -d $common_directory ]; then
        sudo mkdir -p ${common_directory}
        sudo chmod -R 777 ${common_directory}
        sudo cp -r /root/.bashrc ${common_directory}
        echo "[ROUTER_PATH] Directory => [ ${common_directory} ] Created Successfully"
        echo "[ROUTER_PATH] Directory => [ ${common_directory} ] bashrc Created Successfully"
    else
        echo "[ROUTER_PATH] Directory => [ ${common_directory} ] Has Been Created"
    fi
}

function main() {
    echo "==============[START_ENV_INSTALLER]=============="
    start_environment_installer
    echo "==============[ENV_INSTALLER_FINISH]=============="
    echo "[SUCCESS] Everything Environment Has Been Set Successfully"
    echo "[SUCCESS] Please Enjoy Your Developing ..."
}

main
