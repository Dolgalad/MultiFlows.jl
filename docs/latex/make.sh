#!/bin/bash

echo $(which pdflatex)
echo $(which convert)
echo $(pwd)

# Make latex tikz images
for FILE in ./img/*.tex; do
	echo $FILE
	pdflatex -output-directory `dirname $FILE` $FILE > /dev/null 2>&1
	PDFFILE="${FILE%.tex}.png"
	if [ ! -f "$PDFFILE" ]; then
		echo "PDF output $PDFFILE does not exist. Quitting"
		break
	fi
	convert -density 600 "${FILE%.tex}.pdf" "${FILE%.tex}.png" #> /dev/null 2>&1
	PNGFILE="${FILE%.tex}.png"
	if [ ! -f "$PNGFILE" ]; then
		echo "PNG output $PNGFILE does not exist. Quitting"
		break
	fi
	mv "${FILE%.tex}.png" ../src/assets/img
        rm "${FILE%.tex}.aux" "${FILE%.tex}.log" "${FILE%.tex}.pdf" #> /dev/null 2>&1
done
