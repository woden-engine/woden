serialization
asJsonData
	^ OrderedDictionary newFromPairs: { 
		'type' . 'behavior-class' .
		'class' . behaviorClassName
	}