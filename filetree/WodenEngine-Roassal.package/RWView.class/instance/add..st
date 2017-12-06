adding
add: anElement
	self assert: anElement isElement.
	elements add: anElement.
	anElement addedIn: self