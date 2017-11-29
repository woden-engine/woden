initialization
loadCoreStates
	engine assetSearchPaths do: [ :searchPath |
		self addedAssetSearchPath: searchPath
	]
	