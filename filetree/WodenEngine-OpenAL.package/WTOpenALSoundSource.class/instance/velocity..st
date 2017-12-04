accessing
velocity: anObject
	velocity := anObject.
	
	(self hasValidHandle) ifTrue: [
		device asCurrentDo: [
			OpenAL
				source3f: handle param: AL_VELOCITY value: position x value: position y value: position z.
		]
	]