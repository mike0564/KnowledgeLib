rm -rf "$1"
git rm "$1"
git commit -m "remove $1"
git push -u origin master