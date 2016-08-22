accessing
position: anObject
	position := anObject.
	self hasValidHandle ifTrue: [
		handle position: position
	]