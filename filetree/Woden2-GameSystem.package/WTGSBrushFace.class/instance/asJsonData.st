serialization
asJsonData
	^ OrderedDictionary newFromPairs: {
		'plane' . plane asJsonData .
		'material' . material .
		'texture-transform' . textureTransform asJsonData.
	}