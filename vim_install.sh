#!/bin/bash
DIRECTORY=~/vim-scripts
PLUGIN=$DIRECTORY/plugin
VIMRC=~/.vimrc
CSCOPE_PATH=$HOME/cscope

#Update address as needed
WGET_TAGLIST=http://www.vim.org/scripts/download_script.php?src_id=7701
WGET_PROJECT=http://www.vim.org/scripts/download_script.php?src_id=6273
WGET_ENH_COMMENT=http://www.vim.org/scripts/download_script.php?src_id=8319
WGET_SUPER_TAB=http://www.vim.org/scripts/download_script.php?src_id=16104i
WGET_CSCOPE_MAPS=http://cscope.sourceforge.net/cscope_maps.vim
=

initial_setup () {
    echo "========================================================"
    echo " Installing vim"
    echo " vim vim-common vim-gnome vim-gui-common vim-runtime exuberant-ctags cscope"
    echo "========================================================"
    sudo apt-get -y install vim vim-common vim-gnome vim-gui-common vim-runtime exuberant-ctags cscope
}

create_if_missing() {
    if [ ! -d "$1" ]; then
        echo "Creating $1 !!"
        sudo mkdir "$1"
    fi
}

install_cscope_maps() {
    create_if_missing "$PLUGIN"
    cd "$PLUGIN"
    sudo wget -O cscope_maps.vim  $WGET_CSCOPE_MAPS
}

install_taglist (){
    cd /usr/src
    sudo wget -O taglist.zip $WGET_TAGLIST

    create_if_missing $DIRECTORY
    cd "$DIRECTORY"
    sudo unzip -u /usr/src/taglist.zip
}

install_project(){
    cd /usr/src
    sudo wget -O project.tar.gz $WGET_PROJECT

    create_if_missing $DIRECTORY
    cd "$DIRECTORY"
    sudo tar -xvzf /usr/src/project.tar.gz
}

install_enh_comment(){
    cd /usr/src
    sudo wget -O enh_comment.tar.gz $WGET_ENH_COMMENT

    create_if_missing $DIRECTORY
    cd "$DIRECTORY"
    sudo tar -xvzf /usr/src/enh_comment.tar.gz
    cd EnhancedCommentify-2.3
    sudo cp -r * $DIRECTORY
    cd $DIRECTORY
    sudo rm -r EnhancedCommentify-2.3/
}

install_super_tab() {
    cd /usr/src
    sudo wget -O supertab.vba $WGET_SUPER_TAB

    cd
    export user=$(whoami)
    sudo chown -R $user:$user .vim
}

initial_setup
install_taglist
install_project
install_enh_comment
install_super_tab
install_cscope_maps

echo "----------------------------------------------------"
echo "|                                                  |"
echo "|   Vim Install and configuration Complete         |"
echo "|   To finalize type: vim /usr/src/supertab.vba    |"
echo "|   and enter the comand:                          |"
echo "|                            :so %                 |"
echo "|                                                  |"
echo "----------------------------------------------------"
