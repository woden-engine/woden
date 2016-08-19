arithmetic
/ scalarOrVector4
	^ scalarOrVector4 isNumber ifTrue: [ ^ self scale: 1.0 / scalarOrVector4 ] ifFalse: [ ^ self divideWithVector: scalarOrVector4 ]