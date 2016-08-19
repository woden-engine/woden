arithmetic
* scalarOrVector2
	^ scalarOrVector2 isNumber ifTrue: [ ^ self scale: scalarOrVector2 ] ifFalse: [ ^ self multWithVector: scalarOrVector2 ]