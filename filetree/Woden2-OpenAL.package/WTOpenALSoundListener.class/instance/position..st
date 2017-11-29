accessing
position: anObject
	position := anObject.
	
	(self hasValidHandle and: [ self isCurrentListener ]) ifTrue: [
		device asCurrentDo: [
			OpenAL listener3f: AL_POSITION value: position x value: position y value: position z.
		]
	]