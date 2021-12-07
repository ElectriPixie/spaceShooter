#!/bin/bash

# compile game with mtasc
# -v sets verbose mode
# -cp is the class path to find std
# -strict turns on strict mode
# -mx use precompiled mx package
# -main

swfmill simple gameAssets.xml gameAssets.swf
bin/mtasc -v -cp ./lib/std -swf gameAssets.swf -out spaceShooter.swf -main gameEngine.as
