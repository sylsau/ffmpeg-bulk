#!/bin/bash - 
#===============================================================================
#
#         USAGE: ./this.sh --help
# 
#   DESCRIPTION: Create a ffmpeg conversion script from a list of input files.
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Sylvain Saubier (ResponSyS), mail@systemicresponse.com
#       CREATED: 01/05/16 14:09
#===============================================================================

v_help=0
f_list=''
f_list_working='/tmp/ffmpegconv_list'
f_ffmpeg_script='./ffmpeg_cmd.sh'
v_argsin=''
v_argsout=''
v_extin=''
v_extout=''

if test -z "$*"; then
    v_help=1
else
    # Individually check provided args
    while test -n "$1" ; do
        case $1 in
            "--help"|"-h")
                v_help=1
                break
                ;;
            "--extin"|"-xi")
                v_extin=$2
                shift
                ;;
            "--extout"|"-xo")
                v_extout=$2
                shift
                ;;
            "--argsin"|"-ai")
                v_argsin=$2
                shift
                ;;
            "--argsout"|"-ao")
                v_argsout=$2
                shift
                ;;
            "--outfile"|"-o")
                f_ffmpeg_script="$2"
                shift
                ;;
            *)
                f_list=$1
                ;;
        esac	# --- end of case ---
        # Delete $1
        shift
    done
fi


if test $v_help -eq 1 ; then
    echo
    echo "Create a ffmpeg conversion script from a list of input files."
    echo
    echo "Usage:"
    echo "    $0 [--extin,-xi EXTENSION_OF_IN_FILES] [--extout,-xo EXTENSION_OF_OUT_FILES] [--argsin,-ai FFMPEG_ARGS_IN] [--argsout,-ao FFMPEG_ARGS_OUT] [--outfile,-o SCRIPT_FILENAME] LIST"
    echo "        FFMPEG_ARGS_IN are ffmpeg arguments for the input file"
    echo "        FFMPEG_ARGS_OUT are ffmpeg arguments for the output file"
    echo
    echo "Example:"
    echo "    ls *.flac > my_list_of_flac_files.txt"
    echo "        Creates a list of all .flac files in the current directory."
    echo "    $0 -xi .flac -xo .opus --argsout \"-c:a opus -b:a 450k\" -o wewlads.sh /tmp/my_list_of_flac_files.txt"
    echo "        Creates a ffmpeg script named \'wewlads.sh\' which converts listed .flac files to .opus music files with the specified options."
    echo "    ./wewlads.sh"
    echo "        Executes the newly created script and convert the .flac files to .opus files."
    exit
fi

echo "::: List file is: $f_list :::"
echo "::: -xi: $v_extin :::"
echo "::: -xo: $v_extout :::"
echo "::: -ai: $v_argsin :::"
echo "::: -ao: $v_argsout :::"
echo "::: -o: $f_ffmpeg_script :::"

cp $f_list $f_list_working

sed -i "s/$v_extin//" $f_list_working 

echo "::: Generating script :::"
echo "# Script generated by $0" > $f_ffmpeg_script
echo "# Press CTRL+C (^C) to exit the script while executing it" >> $f_ffmpeg_script
cat $f_list_working | gawk -v v_xi="$v_extin" -v v_xo="$v_extout" -v v_ai="$v_argsin" -v v_ao="$v_argsout" '{print "ffmpeg "v_ai" -i \""$0 v_xi"\" "v_ao" \""$0 v_xo"\" || exit"}' | tee -a $f_ffmpeg_script
echo "::: Script generated :::"
echo "::: Granting execution permission :::"
chmod ug+x $f_ffmpeg_script
echo "::: Script \"$f_ffmpeg_script\" ready to be executed :::"

exit
