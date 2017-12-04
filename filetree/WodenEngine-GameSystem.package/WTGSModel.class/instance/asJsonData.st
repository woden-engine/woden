serialization
asJsonData
	^ OrderedDictionary newFromPairs: {
		'type' . 'model'.
		'name' . modelName .
	 }