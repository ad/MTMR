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

hdiutil create -fs HFS+ -srcfolder ./MTMR.app -volname MTMR ./MTMR.dmg


DATE=`date +"%a, %d %b %Y %H:%M:%S %z"`
BUILD=`/usr/libexec/PlistBuddy -c "Print CFBundleVersion" MTMR.app/Contents/Info.plist`
VERSION=`/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" MTMR.app/Contents/Info.plist`
MINIMUM=`/usr/libexec/PlistBuddy -c "Print LSMinimumSystemVersion" MTMR.app/Contents/Info.plist`
SIZE=`stat -f%z MTMR.dmg`
SIGN=`~/Sparkle/bin/sign_update MTMR.dmg | awk '{printf "%s",$0} END {print ""}'`
SHA256=`shasum -a 256 MTMR.dmg | awk '{print $1}'`

# ditto -c -k --sequesterRsrc --keepParent "${NAME}.app" "${NAME}v${VERSION}.zip"

echo DATE $DATE
echo VERSION $VERSION
echo BUILD $BUILD
echo MINIMUM $MINIMUM
echo SIZE $SIZE
echo SIGN ${SIGN}

echo "<?xml version=\"1.0\" standalone=\"yes\"?>
<rss xmlns:sparkle=\"http://www.andymatuschak.org/xml-namespaces/sparkle\" version=\"2.0\">
    <channel>
        <item>
            <title>${VERSION}</title>
            <pubDate>${DATE}</pubDate>
            <description>
                ${1}
            </description>
            <sparkle:minimumSystemVersion>${MINIMUM}</sparkle:minimumSystemVersion>
            <enclosure url=\"https://github.com/ad/MTMR/releases/download/latest/MTMR.dmg\"
                sparkle:version=\"${BUILD}\"
                sparkle:shortVersionString=\"${VERSION}\"
                length=\"${SIZE}\"
                type=\"application/octet-stream\"
                ${SIGN}
            />
        </item>
    </channel>
</rss>" > ../appcast.xml
