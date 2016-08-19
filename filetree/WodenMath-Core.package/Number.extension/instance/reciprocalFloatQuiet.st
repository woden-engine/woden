*WodenMath-Core
reciprocalFloatQuiet
	self = 0 ifTrue: [ ^ self sign < 0 ifTrue: [ Float negativeInfinity ] ifFalse: [ Float infinity ] ].
	^ 1.0 / self