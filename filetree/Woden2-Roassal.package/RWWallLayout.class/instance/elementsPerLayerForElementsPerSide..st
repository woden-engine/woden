dimension calculation
elementsPerLayerForElementsPerSide: elementsPerSide
	^ elementsPerSide == 1
		ifTrue: [ 1 ]
		ifFalse: [ 4 * (elementsPerSide - 1) ]