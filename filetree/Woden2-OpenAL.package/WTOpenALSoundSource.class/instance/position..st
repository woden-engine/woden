accessing
position: anObject
	position := anObject.
	
	(self hasValidHandle) ifTrue: [
		device asCurrentDo: [
			OpenAL
				source3f: handle param: AL_POSITION value: position x value: position y value: position z.
		]
	]