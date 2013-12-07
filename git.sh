#!/bin/sh

rm ../git_bak/* -rf
mv ../wangjason.github.io/.git ../git_bak/
rm ../wangjason.github.io/* -rf
mv _site/* ../wangjason.github.io/
mv ../git_bak/.git ../wangjason.github.io/
