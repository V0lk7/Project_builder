#!/bin/bash

DIR_NAME=""
EXEC_NAME=""

function get_exec_name() {
  local VALID_EXEC="false"

  while [ "$VALID_EXEC" = "false" ]; do
    # Prompt the user for the executable name
    read -p "Enter the name of the executable: " PROJECT_EXEC
    if [ -z "$PROJECT_EXEC" ]; then
      echo "Enter a non empty executable name !"
    else
      VALID_EXEC="true"
    fi
  done
  EXEC_NAME=$PROJECT_EXEC
}

function get_dir_name() {
  local VALID_DIR="false"

  while [ "$VALID_DIR" = "false" ]; do
    # Prompt the user for the directory name
    read -p "Enter the name of the directory: " PROJECT_DIR
    if [ -z "$PROJECT_DIR" ]; then
      echo "Enter a non empty directory name !"
    elif [ -f "$PROJECT_DIR" ] || [ -d "$PROJECT_DIR" ]; then
      echo "Name already exist, please take another one or delete the existing file/dir !"
    else
      VALID_DIR="true"
    fi
  done
  DIR_NAME=$PROJECT_DIR
}

function get_parameters() {
  if [ "$#" -eq "0" ]; then
    get_dir_name
    get_exec_name
  fi
}

function create_project_dirs() {
  mkdir $DIR_NAME
  mkdir $DIR_NAME/source
  mkdir $DIR_NAME/build
}

function create_project_files() {
  local MAIN_CPP="$DIR_NAME/source/main.cpp"
  local CMAKELIST="$DIR_NAME/source/CMakeLists.txt"
  local CMAKEVERSION=$(cmake --version | awk '{print $3}' | head -1 | awk -F. '{print $1 "." $2}')

  cat <<EOL >$MAIN_CPP
#include <iostream>

int main(int ac, char *av[]) {
  std::cout << "Welcome to this new project!";
  return 0;
}

EOL

  cat <<EOL >$CMAKELIST
cmake_minimum_required(VERSION $CMAKEVERSION)

project($EXEC_NAME LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 98)

add_executable($EXEC_NAME main.cpp)

EOL

}

get_parameters

create_project_dirs

create_project_files
