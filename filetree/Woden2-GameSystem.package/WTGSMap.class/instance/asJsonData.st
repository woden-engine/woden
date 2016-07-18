converting
asJsonData
	^ OrderedDictionary newFromPairs: {
		'entities' . entities collect: #asJsonData
	 }