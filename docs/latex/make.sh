#!/bin/bash

echo $(which pdflatex)
echo $(which convert)
echo $(pwd)

# Make latex tikz images
for FILE in ./img/*.tex; do
	echo $FILE
	pdflatex -output-directory `dirname $FILE` $FILE #> /dev/null 2>&1
	PDFFILE="${FILE%.tex}.pdf"
	if [ ! -f "$PDFFILE" ]; then
		echo "PDF output $PDFFILE does not exist. Quitting"
		exit 1
	fi
	#convert -density 600 "${FILE%.tex}.pdf" "${FILE%.tex}.png" #> /dev/null 2>&1
	PNGFILE="${FILE%.tex}.png"
	gs -dSAFER -r600 -sDEVICE=pngalpha -o "$PNGFILE" "$PDFFILE"
	if [ ! -f "$PNGFILE" ]; then
		echo "PNG output $PNGFILE does not exist. Quitting"
		exit 1
	fi
	mv "${FILE%.tex}.png" ../src/assets/img
        rm "${FILE%.tex}.aux" "${FILE%.tex}.log" "${FILE%.tex}.pdf" #> /dev/null 2>&1
done