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
