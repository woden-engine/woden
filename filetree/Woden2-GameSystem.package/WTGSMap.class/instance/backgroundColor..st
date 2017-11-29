accessing
backgroundColor: anObject
	backgroundColor := anObject.
	scene ifNotNil: [ 
		scene backgroundColor: backgroundColor.
	]
	