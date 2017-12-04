parsing
parse: materialFileReference data: aDictionary
	useDepth := aDictionary at: 'use-depth' ifAbsent: [ true ].
	writeDepth := aDictionary at: 'write-depth' ifAbsent: [ true ].
	stipple := aDictionary at: 'stipple' ifAbsent: [ false ].
	thumbnailType := (aDictionary at: 'thumbnail-type' ifAbsent: [ #color ]) asSymbol.