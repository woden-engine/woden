as yet unclassified
centerElements: elements at: aPoint
	| translation |
	translation := aPoint - (self boundingBoxOfElements: elements) center.
	elements do: [ :el | el translateBy: translation ]
	