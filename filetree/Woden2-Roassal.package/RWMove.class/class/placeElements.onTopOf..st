as yet unclassified
placeElements: aCollection onTopOf: aPoint

	| translation |
	self centerElements: aCollection at: aPoint.
	
	translation := aPoint y - (self boundingBoxOfElements: aCollection) bottom.
	aCollection do: [ :el | el translateByY: translation  ]