arithmetic
* scalarOrVector4
	^ scalarOrVector4 isNumber ifTrue: [ ^ self scale: scalarOrVector4 ] ifFalse: [ ^ self multWithVector: scalarOrVector4 ]