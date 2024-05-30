#!/bin/bash

REPO="/root/files/"
TEMPOUTPUT=$(mktemp)


echo "Starting download of Tines of India"
/root/toi.sh | tee "$TEMPOUTPUT"
/root/hindu.sh | tee "$TEMPOUTPUT"

echo "starting git push"
cd "$REPO"
git add .
git commit -m "new newspapers"
git push | tee "$TEMPOUTPUT"

