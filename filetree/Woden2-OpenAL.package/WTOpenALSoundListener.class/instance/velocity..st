accessing
velocity: anObject
	velocity := anObject.
	
	(self hasValidHandle and: [ self isCurrentListener ]) ifTrue: [
		device asCurrentDo: [
			OpenAL listener3f: AL_VELOCITY value: velocity x value: velocity y value: velocity z.
		]
	]