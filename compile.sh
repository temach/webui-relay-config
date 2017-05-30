#!/usr/bin/bash

# clear beforehand
echo rm build/*
rm build/*

indexcss="index.css"

# filter what css you actually use. Put it in PRODUCTION
echo uncss *.html > build/${indexcss}
uncss *.html > build/${indexcss}

# BUG: minification of optimised css breaks website.
# minify the optimised css in PRODUCTION
echo java -jar ../yuicompressor-2.4.8.jar build/"${indexcss}" -o  build/"${indexcss%%.*}".min.css
java -jar ../yuicompressor-2.4.8.jar build/"${indexcss}" -o  build/"${indexcss%%.*}".min.css
# echo cp build/${indexcss} build/"${indexcss%%.*}".min.css
# cp build/${indexcss} build/"${indexcss%%.*}".min.css

# minify all the javascript, put it in PRODUCTION
for f in *.js ; do
    echo java -jar ../yuicompressor-2.4.8.jar "${f}" -o  build/"${f%%.*}".min.js
    java -jar ../yuicompressor-2.4.8.jar "${f}" -o  build/"${f%%.*}".min.js
done

# put other files in PRODUCTION
echo cp *.html build/
cp *.html build/

echo cp *.ico build/
cp *.ico build/

echo cp *.png build/
cp *.png build/

# replace all stylesheets in PRODUCTION with reference to one optimised AND minified stylesheet
echo perl -pi.bak -e "s#href=\".*[.]css\"#href=\"${indexcss%%.*}.min.css\"#g" build/*.html
perl -pi.bak -e "s#href=\".*[.]css\"#href=\"${indexcss%%.*}.min.css\"#g" build/*.html

# remove dublicate links to the same optimised stylesheet in PRODUCTION
echo gawk -i inplace '/rel="stylesheet"/ {if (!dublicates[$0]++) print; next } //' build/*.html
gawk -i inplace '/rel="stylesheet"/ {if (!dublicates[$0]++) print; next } //' build/*.html

# replace all javascript in PRODUCTION with reference to minimized version
echo perl -pi.bak -e 's#src="(.*).js"#src="\1.min.js"#g' build/*.html
perl -pi.bak -e 's#src="(.*).js"#src="\1.min.js"#g' build/*.html

# cleanup PRODUCTION
echo rm build/*.bak
rm build/*.bak

# remove the .css BUT we keep the minified version
echo rm build/"${indexcss}"
rm build/"${indexcss}"

exit 0
