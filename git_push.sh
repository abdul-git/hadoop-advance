export COMMIT_TMP=`date +"%m-%d-%y-%H:%M:%S"`
git add .
git commit -m "Repo Commit at COMMIT_$COMMIT_TMP"
git push -u origin master
