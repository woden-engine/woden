serialization
asJsonData
	^ OrderedDictionary newFromPairs: {
		'type' . 'light-source'.
		'light-type' . type .
		'intensity' . intensity asJsonData.
		'inner-spot-cutoff' . innerSpotCutoff .
		'outer-spot-cutoff' . outerSpotCutoff .
	 }