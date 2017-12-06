event handling
mapTriggerHard: value
	^ (self mapTrigger: value) > 0.5 ifTrue: [ 1.0 ] ifFalse: [ 0.0 ].