assets
addAssetSearchPath: aSearchPath
	| searchPathReference |
	searchPathReference := aSearchPath.
	assetSearchPaths add: aSearchPath asFileReference.
	resourceCache addedAssetSearchPath: searchPathReference.