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
rm -r MTMR.dmg

zip -r "MTMR.zip" "MTMR.app"

killall MTMR
rm -r "/Applications/MTMR.app"
cp -R "MTMR.app" "/Applications"
open "/Applications/MTMR.app"

echo $VERSION

hdiutil create -fs HFS+ -srcfolder ./MTMR.app -volname MTMR ./MTMR.dmg

ditto -c -k --sequesterRsrc --keepParent "MTMR.app" "MTMR.zip"
