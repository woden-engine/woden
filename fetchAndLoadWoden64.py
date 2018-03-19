#!/usr/bin/python
from fetchDependencies import *
from loadWoden import *

# Satisfy the dependencies
satisfy64BitDependencies()

# Load the current version of Woden
loadWodenImage()
