#!/bin/bash - 
#===============================================================================
#
#		  USAGE: ./this.sh --help
# 
#	DESCRIPTION: Create a ffmpeg conversion script from a list of input files.
# 
#		OPTIONS: ---
#  REQUIREMENTS: sed, gawk, ffmpeg, tee
#		   BUGS: ---
#		  NOTES: ---
#		 AUTHOR: Sylvain Saubier (ResponSyS), mail@sylsau.com
#		CREATED: 01/05/16 14:09
#===============================================================================

[[ $DEBUG ]] && set -o nounset
set -o pipefail -o errexit -o errtrace
trap 'echo -e "${FMT_BOLD}ERROR${FMT_OFF}: at $FUNCNAME:$LINENO"' ERR

readonly FMT_BOLD='\e[1m'
readonly FMT_UNDERL='\e[4m'
readonly FMT_OFF='\e[0m'

readonly PROGRAM_NAME="${0##*/}"
readonly SCRIPT_NAME="${0##*/}"
RES="$( stat -c %y $0 | cut -d" " -f1 )"
readonly VERSION=${RES//-/}

readonly ERR_NO_CMD=60

FFMPEG="${FFMPEG:-ffmpeg}"
OPT_EXT=
OPT_ARGS_IN=
OPT_ARGS_OUT=
OPT_FORCE=
OPT_LOGLEVEL="-loglevel error"
INPUT=( )


# $1 = command to test (string)
fn_need_cmd() {
	if ! command -v "$1" > /dev/null 2>&1
		then fn_err "need '$1' (command not found)" $ERR_NO_CMD
	fi
}
# $1 = message (string)
m_say() {
	echo -e "$PROGRAM_NAME: $1"
}
# $1 = error message (string), $2 = return code (int)
fn_err() {
	m_say "${FMT_BOLD}ERROR${FMT_OFF}: $1" >&2
	exit $2
}

fn_help() {
	cat << EOF
$PROGRAM_NAME v$VERSION
	Convert multiple media files at once with ffmpeg.
	In pure and secure bash.
REQUIREMENTS
	ffmpeg
USAGE
	$PROGRAM_NAME FILES... (--to|-t) EXTENSION [--args-in|-ai INPUT_ARGS] [--args-out|-ao OUTPUT_ARGS] [--force|-f] [--log-level LOG_LEVEL]
OPTIONS AND ARGUMENTS
	EXTENSION 		format of output files
	INPUT_ARGS 		ffmpeg arguments for the input file
	OUTPUT_ARGS		ffmpeg arguments for the output file
	--force			overwrite files 
	LOG_LEVEL		change ffmpeg '-loglevel'
				(default: 'error', ffmpeg default: 'info')
EXAMPLE
	Convert all flac and wav files in the current directory to opus with the specified options:
		$ $PROGRAM_NAME *.flac -t opus --args-out "-b:a 320k" *.wav
SEE ALSO
	ffmpeg(1)
AUTHOR
	Written by Sylvain Saubier
REPORTING BUGS
	Mail at: <feedback@sylsau.com>
EOF
}

fn_show_params() {
	m_say "\n input=${INPUT[*]}\n -t=$OPT_EXT\n -ai=$OPT_ARGS_IN\n -ao=$OPT_ARGS_OUT\n -f=$OPT_FORCE\n -q=$OPT_LOGLEVEL" >&2
}


fn_need_cmd "$FFMPEG"

# Check args
if [[ -z "$@" ]]; then
	fn_help
	exit
else
	while [[ $# -gt 0 ]]; do
		case "$1" in
			"--help"|"-h")
				fn_help
				exit
				;;
			"--to"|"-t")
				OPT_EXT=$2
				shift
				;;
			"--args-in"|"-ai")
				OPT_ARGS_IN=$2
				shift
				;;
			"--args-out"|"-ao")
				OPT_ARGS_OUT=$2
				shift
				;;
			"--force"|"-f")
				OPT_FORCE="-y"
				;;
			"--log-level")
				OPT_LOGLEVEL="-loglevel $2"
				shift
				;;
			*)
				[[ -e "$1" ]] || fn_err "file '$1' does not exist" 127
				INPUT+=( "$1" )
				;;
		esac	# --- end of case ---
		shift 	# delete $1
	done
fi

[[ $DEBUG ]] && fn_show_params

[[ $OPT_EXT ]] || fn_err "please specify the output extension with -t EXT" 2

# Rajoute un point à l'extension si absent
if [[ ${OPT_EXT:0:1} != '.' ]]; then
	OPT_EXT=.$OPT_EXT
fi

m_say "converting...\n---"
for F in "${INPUT[@]}"; do # Just show the commands
	echo $FFMPEG $OPT_ARGS_IN -i "$F" $OPT_ARGS_OUT $OPT_FORCE $OPT_LOGLEVEL "${F%.*}$OPT_EXT"
done ; echo "---" ; [[ $DEBUG ]] && exit
for F in "${INPUT[@]}"; do # Actually execute
	m_say "converting \"$F\"..."
	     $FFMPEG $OPT_ARGS_IN -i "$F" $OPT_ARGS_OUT $OPT_FORCE $OPT_LOGLEVEL "${F%.*}$OPT_EXT"
done

exit
