converting
asJsonData
	^ OrderedDictionary newFromPairs: {
		'background-color' . backgroundColor asWodenJsonData .
		'entities' . entities collect: #asJsonData
	 }