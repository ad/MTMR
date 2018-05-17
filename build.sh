rm -r Release 2>/dev/null

xcodebuild archive \
	-scheme "MTMR" \
	-archivePath Release/App.xcarchive

xcodebuild \
	-exportArchive \
	-archivePath Release/App.xcarchive \
	-exportOptionsPlist export-options.plist \
	-exportPath Release

cd Release
rm -r App.xcarchive

create-dmg "MTMR.app"

zip -r "MTMR.zip" "MTMR.app"

killall MTMR
rm -r "/Applications/MTMR.app"
cp -R "MTMR.app" "/Applications"
open "/Applications/MTMR.app"
