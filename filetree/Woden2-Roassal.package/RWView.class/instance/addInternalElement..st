adding
addInternalElement: anElement
	self assert: anElement isElement.
	internalElements add: anElement.
	anElement addedIn: self