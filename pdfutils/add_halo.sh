#/bin/bash
# Adds a white "halo" border (with blur) to text

FILE_NAME=$(basename $1)
EXTENSION=${FILE_NAME##*.}
FILE_NAME_NO_EXT=${FILE_NAME%.*}


convert -channel RGBA -colorspace RGB -density 300 -bordercolor none -border 20 $1 PNG32:temp_image.png

convert temp_image.png \( -clone 0 -alpha extract -threshold 0 \) \( -clone 1 -blur 6x65000 -threshold 0 \) \( -clone 2 -fill white -opaque white \) \( -clone 3 -clone 0 -clone 1 -alpha off -compose over -composite \) -delete 0,1,3 +swap -alpha off -compose copy_opacity -composite temp_image2.png

#`convert temp_image.png \( -clone 0 -alpha extract -threshold 0 \) \( -clone 1 -blur 4x32000 -threshold 0 \) \( -clone 2 -fill white -opaque white \) \( -clone 3 -clone 0 -clone 1 -alpha off -compose over -composite \) -delete 0,1,3 +swap -alpha off -compose copy_opacity -composite -channel RGBA -colorspace RGB -density 300 ${FILE_NAME_NO_EXT}_bordered.pdf `

convert temp_image2.png -bordercolor none -border 20x20 -background White -alpha background -channel A -blur 0x20 -level 0,40% ${FILE_NAME_NO_EXT}_bordered.pdf 

rm temp_image*.png
