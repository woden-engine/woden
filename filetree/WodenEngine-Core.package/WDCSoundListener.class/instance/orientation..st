accessing
orientation: anObject
	orientation := anObject.
	self hasValidHandle ifTrue: [ handle orientation: anObject ].