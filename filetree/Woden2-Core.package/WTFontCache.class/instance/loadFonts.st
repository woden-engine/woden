as yet unclassified
loadFonts
	engine assetSearchPaths do: [ :searchPath |
		self addedAssetSearchPath: searchPath
	]