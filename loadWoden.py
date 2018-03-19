#!/usr/bin/python
import sys
import os

def findPharoImage():
    return filter(lambda fn: ('Pharo' in fn) and ('.image' in fn), os.listdir('.'))[0]

def currentPharoVMExecutable():
    if sys.platform == 'win32':
        return '.\\PharoConsole.exe'
    else:
        return './woden.sh'

def loadWodenImage(baseImageName = None):
    if baseImageName is None:
        baseImageName = findPharoImage()
    pharoLoadingCommand = '%s %s st scripts/LoadRepositories.st' % (currentPharoVMExecutable(), baseImageName)
    print pharoLoadingCommand
    os.system(pharoLoadingCommand)
    print 'DONE'

if __name__ == '__main__':
    loadWodenImage()
