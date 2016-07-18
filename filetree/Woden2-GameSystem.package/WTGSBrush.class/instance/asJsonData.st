serialization
asJsonData
	^ OrderedDictionary newFromPairs: { 
		'type' . 'brush' .
		'color' . color asWodenJsonData .
		'faces' . faces collect: #asJsonData
	}