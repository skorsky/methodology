gitbook build . /tmp/heads
git add -A
git commit -m 'update sources'
git push
mv _book /tmp/heads
git checkout gh-pages
rm -rf *
mv -f /tmp/heads/* .
git add -A
git commit -m 'update website'
git push
#rm -rf /tmp/heads
git checkout master
