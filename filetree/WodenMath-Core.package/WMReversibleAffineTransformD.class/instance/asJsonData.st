converting
asJsonData
	^ OrderedDictionary newFromPairs: { 
		'matrix' . matrix asJsonData .
		'translation' . self translation asJsonData .
		'inverse-matrix' . inverseMatrix asJsonData .
		'inverse-translation' . self inverseTranslation asJsonData .
	}