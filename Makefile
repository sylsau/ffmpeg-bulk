readme:
	./ffmpeg-bulk.sh --help | sed 's/ffmpeg-bulk.sh v/# ffmpeg-bulk.sh - FFMPEG mass converter\nffmpeg-bulk.sh v/' > README.md
