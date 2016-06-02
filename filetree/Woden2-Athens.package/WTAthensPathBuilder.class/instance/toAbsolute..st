private
toAbsolute: aPoint
	^ absolute ifTrue: [aPoint] ifFalse: [ aPoint + lastPoint ]