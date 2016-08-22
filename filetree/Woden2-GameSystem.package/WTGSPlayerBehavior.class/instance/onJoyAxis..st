event handling
onJoyAxis: event
	| value |
	event isPreferredEvent ifFalse: [ ^ self ].
	
	value := self axisMapping: event value.
	event isLeftX ifTrue: [ 
		velocityDirection x: value
	].

	event isLeftY ifTrue: [
		velocityDirection z: value
	].

	event isRightX ifTrue: [ 
		angularVelocity y: value negated
	].

	event isRightY ifTrue: [ 
		angularVelocity x: value negated
	].

	event isTriggerRight ifTrue: [
		speed := 3.0 * (self mapTrigger: event value)
	]
