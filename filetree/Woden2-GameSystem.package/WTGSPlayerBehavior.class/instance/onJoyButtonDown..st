event handling
onJoyButtonDown: event
	event isPreferredEvent ifFalse: [ ^ self ].
	event isButtonX ifTrue: [ 
		self shoot
	]