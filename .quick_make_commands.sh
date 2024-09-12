#!/bin/bash

#use a makefile in my XXXX directory
function fmake() {

      # Default values for the flags
    local make_flag=false
    local colcon_flag=false
    local run_flag=false

    # Parse the flags
    while [[ "$1" != "" ]]; do
        case $1 in
        -m | --make )   make_flag=true
                        ;;
        -c | --colcon )   colcon_flag=true
                        ;;
        -h | --help )    display_help
                        return
                        ;;
        * )              echo "Error: Unknown flag '$1'. Use 'fmake --help' for usage."
                        exit 1
        esac
        shift
    done

    # Perform actions based on the flags
    if [ "$make_flag" = true ]; then
        make_project
    fi

    if [ "$colcon_flag" = true ]; then
        build_with_colcon
    fi


    # If no flags are set, show an error
    if [ "$make_flag" = false ] && [ "$colcon_flag" = false ]; then
        echo "Error: No action specified. Use 'fmake --help' for usage."
        exit 1
    fi
}

function make_project() {
    cd build 
    make $1
    cd ..
}

function build_with_colcon() {
    colcon build --symlink-install
}

display_help() {
    echo "fmake: A simple tool for building projects"
    echo ""
    echo "Usage:"
    echo "  fmake -m | --make       From your project directory, run the makefile which is in the build directory. Argument: make command"
    echo "  fmake -c | --colcon     In a ros2 workspace, rebuild your project"
    echo "  fmake -h | --help       Show this help message"
    echo ""
    echo "Example:"
    echo "  fmake -m all       # = cd build && make all && cd .."
    echo "  fmake -c      # = colcon build --symlink-install"
}