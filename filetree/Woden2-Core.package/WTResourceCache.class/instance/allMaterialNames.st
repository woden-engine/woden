thumbnails
allMaterialNames
	| result materialsSubdir |
	result := OrderedCollection new.
	engine assetSearchPaths do: [ :searchPath |
		materialsSubdir := searchPath / 'materials'.
		materialsSubdir isDirectory ifTrue: [
			result addAll: ((materialsSubdir allChildrenMatching: '*.json') collect: [ :fileRef |
				self stringifyPath: (fileRef relativeToPath: searchPath) ])
		]
	].

	^ result