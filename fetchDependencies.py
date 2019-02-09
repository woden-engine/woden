#!/usr/bin/env python

import urllib
import shutil
import bintray
import tarfile
import zipfile
import os
import sys
import platform

VM_EXECUTION_SCRIPT_TEMPLATE="""
#!/bin/sh
TOP="$( cd "$( dirname "$0" )" && pwd )"

OS="$(uname)"
if test "$OS" = "Darwin"; then
    export DYLD_LIBRARY_PATH="$TOP:$DYLD_LIBRARY_PATH"
else
    export LD_LIBRARY_PATH="$TOP:$LD_LIBRARY_PATH"
fi

exec :VM_NAME: $@
"""

def downloadURLInto(uri, destination):
    def reportHook(count, blockSize, totalSize):
        downloaded = count*blockSize
        percent = int(downloaded*100/totalSize)
        sys.stdout.write('Download %s %3d%%[%d / %d KB]\r' % (destination, percent, downloaded/1024, totalSize/1024))
        sys.stdout.flush()

    urllib.urlretrieve(uri, destination, reportHook)
    sys.stdout.write('\n')
    sys.stdout.flush()

def moveAllInDirInto(directory, targetDirectory):
    for name in os.listdir(directory):
        source = os.path.join(directory, name)
        target = os.path.join(targetDirectory, name)
        shutil.move(source, target)

# I represent a combination between a platform, and architecture and a build mode.
class PlatformMode:
    def __init__(self, os, architecture, mode = 'relwithdebinfo'):
        self.os = os
        self.architecture = architecture
        self.mode = mode
        self.platformName = os + '-' + architecture

    def is64Bit(self):
        return self.architecture in ('x64', 'x86_64')

    def canonicalPharoVMOSName(self):
        return {
            'linux': 'linux',
            'windows': 'win',
            'osx': 'mac'
        } [self.os]

    def __repr__(self):
        return 'PlatformMode(os=%s, architecture=%s, mode=%s)' % (repr(self.os), repr(self.architecture), repr(self.mode))

# I represent a dependency used by Woden.
class Dependency:
    def satisfyInPlatformMode(self, platformMode):
        assert False

    def extractDependencyFromArchive(self, fileName):
        if fileName.endswith('.tar.gz') or fileName.endswith('.tar.bz2'):
            print 'Extracting tarball %s' % (fileName)
            archive = tarfile.open(fileName, 'r')
            archive.extractall()
            archive.close()
        elif fileName.endswith('.zip'):
            print 'Extracting zip %s' % (fileName)
            archive = zipfile.ZipFile(fileName, 'r')
            archive.extractall()
            archive.close()
        else:
            raise Exception('Cannot extract archive')

# I represent a dependency that is obtained by cloning a git repository.
class GitDependency(Dependency):
    def __init__(self, name, repository, subfolder=None):
        self.name = name
        self.repository = repository
        self.subfolder = ''
        if subfolder is not None:
            self.subfolder = '%s/' % subfolder

    def satisfyInPlatformMode(self, platformMode):
        print "Getting dependency %s from git" % self.name
        os.system('git clone %s %s%s' % (self.repository, self.subfolder, self.name))

# I represent a dependency that is obtained by downloading from bintray.
class BintrayDependency(Dependency):
    def __init__(self, name, user, repository, package = 'lib'):
        self.name = name
        self.user = user
        self.repository = repository
        self.package = package

    def satisfyInPlatformMode(self, platformMode):
        print "Getting dependency %s from bintray" % self.name
        fileName = bintray.downloadLatestVersionForModeAndPlatform(self.user, self.repository, self.package, platformMode.mode, platformMode.platformName)
        self.extractDependencyFromArchive(fileName)

        # Move all of the libraries into here.
        moveAllInDirInto(os.path.join(self.repository, 'lib'), '.')

class PharoVMDependency(Dependency):
    def __init__(self, name, baseURL, versionString):
        self.name = name
        self.baseURL = baseURL
        self.versionString = versionString

    def satisfyInPlatformMode(self, platformMode):
        fileName = 'pharo'
        if platformMode.is64Bit():
            fileName += '64'
        fileName += '-' + platformMode.canonicalPharoVMOSName() + '-stable.zip'

        print "Getting dependency %s" % self.name
        # HACK: Use the Zeroconf scripts on linux, and os x
        if platformMode.os in ['linux', 'osx']:
            zeroconfScript = 'https://get.pharo.org/'
            if platformMode.is64Bit():
                zeroconfScript += '64/'
            zeroconfScript += 'vm' + self.versionString
            os.system('wget -O- %s | bash' % (zeroconfScript,))
            self.createVMExecutionScript()
            return

        print "Download PharoVM"
        downloadURLInto(self.baseURL + fileName, fileName)

        print "Extract PharoVM"
        self.extractDependencyFromArchive(fileName)

        # Create a script for executing the VM on non-windows platforms.
        if platformMode.os != 'windows':
            self.createVMExecutionScript()

    def createVMExecutionScript(self):
        vmName = '$TOP/pharo-ui'
        with open('woden.sh', 'w') as out:
            out.write(VM_EXECUTION_SCRIPT_TEMPLATE.replace(':VM_NAME:', vmName))
        os.system('chmod +x woden.sh')

class PharoImageDependency(Dependency):
    def __init__(self, name, baseURL):
        self.name = name
        self.baseURL = baseURL

    def satisfyInPlatformMode(self, platformMode):
        fileName = 'pharo'
        if platformMode.is64Bit():
            fileName += '64'
        fileName += '.zip'

        print "Getting dependency %s" % self.name
        print "Download Pharo image"
        downloadURLInto(self.baseURL + fileName, fileName)

        print "Extract Pharo image"
        self.extractDependencyFromArchive(fileName)

# All of the external dependencies required by Woden
AbstractGpu = BintrayDependency('abstract-gpu', user='ronsaldo', repository='abstract-gpu')
AbstractPhysics = BintrayDependency('abstract-physics', user='ronsaldo', repository='abstract-physics')
CoreAssets = GitDependency('core-assets', 'https://github.com/ronsaldo/wloden-core-assets.git')

if '-pharo80' in sys.argv:
    PharoVM = PharoVMDependency('pharo-vm', 'https://files.pharo.org/get-files/80/', '80')
    PharoImage = PharoImageDependency('pharo-image', 'https://files.pharo.org/get-files/80/')
else:
    PharoVM = PharoVMDependency('pharo-vm', 'https://files.pharo.org/get-files/70/', '70')
    PharoImage = PharoImageDependency('pharo-image', 'https://files.pharo.org/get-files/70/')

dependencies = [
    AbstractGpu,
    AbstractPhysics,
    CoreAssets,
    PharoVM,
    PharoImage
]

# Utilities for getting all of the dependencies
def satisfyDependenciesInPlatformMode(platformMode):
    for dep in dependencies:
        dep.satisfyInPlatformMode(platformMode)

# The default platform modes
Windows_X86 = PlatformMode('windows', 'x86')
Windows_X64 = PlatformMode('windows', 'x64')
Linux_X86_64 = PlatformMode('linux', 'x86_64')
OSX_X86_64 = PlatformMode('osx', 'x86_64')

def getCurrentPlatformMode(mode='relwithdebinfo'):
    arch = platform.machine()
    if sys.platform.startswith('linux'):
        return PlatformMode('linux', arch)
    elif sys.platform == 'darwin':
        return PlatformMode('osx', arch)
    elif sys.platform == 'win32':
        if arch == 'AMD64':
            arch = 'x64'
        else:
            #TODO:
            arch = 'x86'
        return PlatformMode('windows', arch, mode)
    else:
        raise Exception('Unsupported platform')

def getCurrentPlatform32BitMode(mode='relwithdebinfo'):
    arch = 'x86'
    if sys.platform.startswith('linux'):
        return PlatformMode('linux', arch)
    elif sys.platform == 'darwin':
        return PlatformMode('osx', arch)
    elif sys.platform == 'win32':
        return PlatformMode('windows', arch, mode)

def getCurrentPlatform64BitMode(mode='relwithdebinfo'):
    arch = 'x86_64'
    if sys.platform.startswith('linux'):
        return PlatformMode('linux', arch)
    elif sys.platform == 'darwin':
        return PlatformMode('osx', arch)
    elif sys.platform == 'win32':
        arch = 'x64'
        return PlatformMode('windows', arch, mode)

def satisfyDependencies(mode='relwithdebinfo'):
    satisfyDependenciesInPlatformMode(getCurrentPlatformMode(mode))

def satisfy32BitDependencies(mode='relwithdebinfo'):
    satisfyDependenciesInPlatformMode(getCurrentPlatform32BitMode(mode))

def satisfy64BitDependencies(mode='relwithdebinfo'):
    satisfyDependenciesInPlatformMode(getCurrentPlatform64BitMode(mode))
