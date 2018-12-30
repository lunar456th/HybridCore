#!/bin/bash

branch=@mips

git add *
git commit -m "."
git push origin ${branch}

