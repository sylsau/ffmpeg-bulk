# ffmpeg-bulk.sh - FFMPEG mass converter
ffmpeg-bulk.sh v20230604
	Convert multiple media files at once with ffmpeg.
	In pure and secure bash.
REQUIREMENTS
	ffmpeg
USAGE
	ffmpeg-bulk.sh FILES... (--to|-t) EXTENSION [--args-in|-ai INPUT_ARGS] [--args-out|-ao OUTPUT_ARGS] [--force|-f] [--log-level LOG_LEVEL]
OPTIONS AND ARGUMENTS
	EXTENSION 		format of output files
	INPUT_ARGS 		ffmpeg arguments for the input file
	OUTPUT_ARGS		ffmpeg arguments for the output file
	--force			overwrite files 
	LOG_LEVEL		change ffmpeg '-loglevel'
				(default: 'error', ffmpeg default: 'info')
EXAMPLE
	Convert all flac and wav files in the current directory to opus with the specified options:
		$ ffmpeg-bulk.sh *.flac -t opus --args-out "-b:a 320k" *.wav
SEE ALSO
	ffmpeg(1)
AUTHOR
	Written by Sylvain Saubier
REPORTING BUGS
	Mail at: <feedback@sylsau.com>
