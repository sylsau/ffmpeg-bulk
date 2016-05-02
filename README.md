# ffmpeg-mass-conv
## FFMPEG MASS CONVERTER

Creates a ffmpeg conversion script from a list of input files.

### Usage:

`ffmpeg-mass-conv.sh [--extin,-xi EXTENSION_OF_IN_FILES] [--extout,-xo EXTENSION_OF_OUT_FILES] [--argsin,-ai FFMPEG_ARGS_IN] [--argsout,-ao FFMPEG_ARGS_OUT] [--outfile,-o SCRIPT_FILENAME] LIST`
* `FFMPEG_ARGS_IN` are ffmpeg arguments for the input file
* `FFMPEG_ARGS_OUT` are ffmpeg arguments for the output file

### Example:

`ls *.flac > my_list_of_flac_files.txt`  
* Creates a list of all *.flac* files in the current directory.

`ffmpeg-mass-conv.sh -xi .flac -xo .opus --argsout "-c:a opus -b:a 450k" -o wewlads.sh /tmp/my_list_of_flac_files.txt`  
* Creates a ffmpeg script named *wewlads.sh* which converts each listed *.flac* file to a *.opus* music file with the specified options.

`./wewlads.sh`  
* Executes the newly created script and convert every single *.flac* files to a *.opus* file.

#### Example of generated script:

    ### list.txt ###
    01 Fahrenheit Fair Enough.mp3
    02 TTV.mp3
    03 Lotus Above Water.mp3
    [...]

`ffmpeg-mass-conv.sh list.txt -xi .mp3 -xo .ogg -ao "-c:a libvorbis -b:a 128k"`

    ### ffmpeg_cmd.sh generated script ###
    ffmpeg  -i "01 Fahrenheit Fair Enough.mp3" -c:a libvorbis -b:a 128k "01 Fahrenheit Fair Enough.ogg" || exit  
    ffmpeg  -i "02 TTV.mp3" -c:a libvorbis -b:a 128k "02 TTV.ogg" || exit  
    ffmpeg  -i "03 Lotus Above Water.mp3" -c:a libvorbis -b:a 128k "03 Lotus Above Water.ogg" || exit  
    [...]
