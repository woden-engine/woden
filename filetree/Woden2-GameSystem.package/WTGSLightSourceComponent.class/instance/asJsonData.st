serialization
asJsonData
	^ OrderedDictionary newFromPairs: {
		'type' . 'light-source'.
		'intensity' . intensity asJsonData. 
	 }