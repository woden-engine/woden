accessing
gain: anObject
	gain := anObject.
	self hasValidHandle ifTrue: [
		handle gain: gain
	]