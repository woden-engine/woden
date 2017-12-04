converting
asJsonData
	^ OrderedDictionary newFromPairs: { 
		'scale' . scale asJsonData . 
		'offset' . offset asJsonData .
		'rotation' . rotation .
		'lock' . lock .
	}