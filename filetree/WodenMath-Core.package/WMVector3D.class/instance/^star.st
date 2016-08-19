arithmetic
* scalarOrVector3
	^ scalarOrVector3 isNumber ifTrue: [ ^ self scale: scalarOrVector3 ] ifFalse: [ ^ self multWithVector: scalarOrVector3 ]