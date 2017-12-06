as yet unclassified
addElementOn: anObject
	| element |
	element := self elementOn: anObject.
	view add: element.
	^ element