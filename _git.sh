#!/bin/bash

branch=@mips

git rm -r $(git ls-files --deleted)
git add *
git commit -m "."
git push origin ${branch}

