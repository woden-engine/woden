arithmetic
/ scalarOrVector3
	^ scalarOrVector3 isNumber ifTrue: [ ^ self scale: 1.0 / scalarOrVector3 ] ifFalse: [ ^ self divideWithVector: scalarOrVector3 ]