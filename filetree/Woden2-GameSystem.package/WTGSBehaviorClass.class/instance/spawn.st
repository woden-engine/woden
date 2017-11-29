map events
spawn
	| behaviorClass behavior |
	behaviorClass := Smalltalk at: behaviorClassName ifAbsent: [ ^ self ].
	behavior := behaviorClass new.
	entity addComponent: behavior.
	behavior spawn.