#!/usr/bin/python
import urllib
import json
import sys

LATEST_VERSION_URI = 'https://api.bintray.com/packages/:user/:repository/:package/versions/_latest'
VERSION_FILE_LIST_URI = 'https://api.bintray.com/packages/:user/:repository/:package/versions/:version/files'
DOWNLOAD_URI = 'https://dl.bintray.com/:user/:repository/:file_path'

def getURL(uri):
    response = urllib.urlopen(uri)
    return response.read()

def downloadURLInto(uri, destination):
    def reportHook(count, blockSize, totalSize):
        downloaded = count*blockSize
        percent = int(downloaded*100/totalSize)
        sys.stdout.write('Download %s %3d%%[%d / %d KB]\r' % (destination, percent, downloaded/1024, totalSize/1024))
        sys.stdout.flush()

    urllib.urlretrieve(uri, destination, reportHook)
    sys.stdout.write('\n')
    sys.stdout.flush()

def requestJSON(uri):
    return json.loads(getURL(uri))

def getPackageLatestVersionInfo(user, repository, package):
    uri = LATEST_VERSION_URI \
        .replace(':user', user) \
        .replace(':repository', repository) \
        .replace(':package', package)
    return requestJSON(uri)

def getVersionFileList(user, repository, package, version):
    uri = VERSION_FILE_LIST_URI \
        .replace(':user', user) \
        .replace(':repository', repository) \
        .replace(':package', package) \
        .replace(':version', version)
    return requestJSON(uri)

def getLatestVersionFileList(user, repository, package):
    versionInfo = getPackageLatestVersionInfo(user, repository, package)
    return list(map(lambda e: e['path'], getVersionFileList(user, repository, package, versionInfo['name'])))

def getLatestVersionForModeAndPlatform(user, repository, package, mode, platform):
    fileList = getLatestVersionFileList(user, repository, package)
    return list(filter(lambda e: (mode in e) and (platform + '_' in e), fileList))

def downloadLatestVersionForModeAndPlatform(user, repository, package, mode, platform):
    fileName = getLatestVersionForModeAndPlatform(user, repository, package, mode, platform)[0]
    downloadUri = DOWNLOAD_URI \
        .replace(':user', user) \
        .replace(':repository', repository) \
        .replace(':file_path', fileName)
    downloadURLInto(downloadUri, fileName)
    return fileName
