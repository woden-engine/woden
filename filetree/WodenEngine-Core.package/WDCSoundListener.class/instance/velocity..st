accessing
velocity: anObject
	velocity := anObject.
	self hasValidHandle ifTrue: [ handle position: anObject ].