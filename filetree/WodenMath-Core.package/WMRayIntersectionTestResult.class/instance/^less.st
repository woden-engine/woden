comparing
< other
	priority = other priority ifTrue: [
		^ distance < other distance
	] ifFalse: [ 
		^ priority < other priority
	]