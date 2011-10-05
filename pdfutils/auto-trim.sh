#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"
FILE_NAME=$(basename $1)
EXTENSION=${FILE_NAME##*.}
FILE_NAME_NO_EXT=${FILE_NAME%.*}

echo "Auto-trimming image..."
if [ "${EXTENSION}" != ".pdf" ]
then
    echo "(Warning! Converting from ${EXTENSION} to pdf format)"
fi

# Trims the sides and converts to PDF
convert  -density 300 -trim +repage ${FILE_NAME} tmp_out.pdf
# Trims the top and bottom
convert  -density 300 -trim +repage tmp_out.pdf trimmed_${FILE_NAME_NO_EXT}.pdf

echo "Compressing trimmed image..."
# Make sure we have the quartz filter in the current dir (for automator workflow)
cat > "COMPRESS_PDF.qfilter" <<STOP
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Domains</key>
	<dict>
		<key>Applications</key>
		<true/>
		<key>Printing</key>
		<true/>
	</dict>
	<key>FilterData</key>
	<dict>
		<key>ColorSettings</key>
		<dict>
			<key>ImageSettings</key>
			<dict>
				<key>ImageScaleSettings</key>
				<dict>
					<key>ImageResolution</key>
					<integer>200</integer>
					<key>ImageScaleFactor</key>
					<real>0.0</real>
					<key>ImageScaleInterpolate</key>
					<integer>3</integer>
					<key>ImageSizeMax</key>
					<integer>0</integer>
					<key>ImageSizeMin</key>
					<integer>0</integer>
				</dict>
			</dict>
		</dict>
	</dict>
	<key>FilterType</key>
	<integer>1</integer>
	<key>Name</key>
	<string>Reduce File Size (Scale 75%)</string>
</dict>
</plist>
STOP

# Sleep to make sure the disk is written
sleep 1 

# Now use the filter. 
# ONLY WORKS ON OSX, BUT IT WORKS REALLY REALLY WELL. 
automator -v -i trimmed_${FILE_NAME_NO_EXT}.pdf $SCRIPT_DIR/CompressPDF.workflow

# Again, make sure the disk is written
sleep 1 

# The automator script does not give proper perms
chmod 644 trimmed_${FILE_NAME_NO_EXT}.pdf

# Cleanup: 
rm COMPRESS_PDF.qfilter
#rm tmp_out.pdf
