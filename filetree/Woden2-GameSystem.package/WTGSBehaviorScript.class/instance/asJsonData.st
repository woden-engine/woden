serialization
asJsonData
	^ OrderedDictionary newFromPairs: { 
		'type' . 'behavior-script' .
		'spaw-code' . spawnCode
	}