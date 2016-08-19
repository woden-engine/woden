arithmetic
/ scalarOrVector2
	^ scalarOrVector2 isNumber ifTrue: [ ^ self scale: 1.0 / scalarOrVector2 ] ifFalse: [ ^ self divideWithVector: scalarOrVector2 ]