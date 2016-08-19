arithmetic
/ other
	other isNumber ifTrue: [ ^ self scale: 1.0 / other ] ifFalse: [ ^ self multWithComplex: other inverse ]