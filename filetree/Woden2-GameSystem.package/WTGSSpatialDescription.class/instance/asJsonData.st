serialization
asJsonData
	^ OrderedDictionary newFromPairs: {
		'type' . 'spatial-description'.
		'transform' . transform asJsonData. 
		'bounding-box' . localBoundingBox asJsonData. 
	 }