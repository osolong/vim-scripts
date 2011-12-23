#!/bin/sh

#Change cscope database directory, ffmpeg and SDL source code directory if they exist`
MYDIR=$PWD
DIRECTORY=~/vim-scripts/cscope
FFMPEG=~/ffmpeg
SDL=~/SDL-1.2

if [ ! -d "$DIRECTORY" ]; then
    echo "Creating ~/cscope !!"
    mkdir "$DIRECTORY"
fi

# run cscope on current folder
# will delete previous file.
find $MYDIR -name '*.py' \
    -o -name '*.java' \
    -o -iname '*.[CH]' \
    -o -name '*.cpp' \
    -o -name '*.cc' \
    -o -name '*.hpp'  \
    -o -name "*.[chxsS]" \
    > $DIRECTORY/cscope.files

# run cscope on ffmpeg folder
# will append its results.
cd; if [ -e "$FFMPEG" ]; then
    find  $FFMPEG -name '*.cpp' \
        -o -name '*.cc' \
        -o -name '*.hpp'  \
        -o -iname "*.[CHXS]" -print >> $DIRECTORY/cscope.files
fi

# run cscope on SDL folder
# will append its results.
cd; if [ -e "$SDL" ]; then
    find  $SDL \
        -path "$SDL/*" ! -path "$SDL/src*" -prune -o \
        -path "$SDL/include*" -prune -o \
        -name '*.cpp' \
        -o -name '*.cc' \
        -o -name '*.hpp'  \
        -o -iname "*.[CHXS]" -print >> $DIRECTORY/cscope.files
fi

cd $DIRECTORY
cscope -b -q
