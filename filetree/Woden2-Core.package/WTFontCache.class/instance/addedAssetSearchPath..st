as yet unclassified
addedAssetSearchPath: searchPathReference
	| fontsFile |
	fontsFile := searchPathReference / 'fonts' / 'fonts.json'.
	fontsFile exists ifTrue: [
		self loadFontsFromFile: fontsFile
	]
	