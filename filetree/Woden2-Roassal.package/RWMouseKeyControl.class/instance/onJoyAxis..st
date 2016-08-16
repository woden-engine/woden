event handling
onJoyAxis: event
	| value velocity angularVelocity |
	value := self axisMapping: event value.
	velocity := movement velocity.
	angularVelocity := movement angularVelocity.
	event isLeftX ifTrue: [
		velocity x: value asFloat.
	].
	event isLeftY ifTrue: [
		velocity z: value asFloat.
	].
	event isTriggerRight ifTrue: [
		velocity y: (self mapTrigger: event value)
	].
	event isTriggerLeft ifTrue: [
		velocity y: (self mapTrigger: event value) negated
	].

	event isRightY ifTrue: [
		angularVelocity x: value asFloat.
	].
	event isRightX ifTrue: [
		angularVelocity y: value asFloat.
	].

	movement velocity: velocity.
	movement angularVelocity: angularVelocity.
