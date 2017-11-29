as yet unclassified
addAssetSearchPath: aSearchPath
	| searchPathReference |
	searchPathReference := aSearchPath.
	assetSearchPaths add: aSearchPath asFileReference.
	pipelineStateCache addedAssetSearchPath: searchPathReference.
	fontCache addedAssetSearchPath: searchPathReference.
	resourceCache addedAssetSearchPath: searchPathReference.