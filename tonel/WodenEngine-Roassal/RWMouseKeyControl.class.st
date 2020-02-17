Class {
	#name : #RWMouseKeyControl,
	#superclass : #RWViewInteraction,
	#instVars : [
		'movement'
	],
	#pools : [
		'OSKeySymbols'
	],
	#category : #'WodenEngine-Roassal-Interaction'
}

{ #category : #'as yet unclassified' }
RWMouseKeyControl class >> analogDeadZone [
	^ 5000
]

{ #category : #settings }
RWMouseKeyControl class >> angleDragScale [
	^ 3.14 / (180.0)
]

{ #category : #settings }
RWMouseKeyControl class >> velocityMagnitude [
	^ 2.0
]

{ #category : #'event handling' }
RWMouseKeyControl >> axisMapping: value [
	| deadZone |
	deadZone := self class analogDeadZone.
	((value > deadZone negated) and: [ value < deadZone ]) ifTrue: [ ^ 0.0 ].
	^ value / 32768.0
]

{ #category : #hooks }
RWMouseKeyControl >> initializeElement: aView [
	movement := RWForwardMovement new
		enabledWhen: [aView isInVirtualReality not];
		yourself.
	aView camera addBehavior: movement.
	
	aView when: RWKeyDown do: [ :evt |
		self onKeyDown: evt.
	].
	aView when: RWKeyUp do: [ :evt |
		self onKeyUp: evt.
	].
	aView when: RWMouseDrag do: [ :evt |
		evt isLeftButton ifTrue: [ self onMouseDrag: evt ].
	].
	aView when: RWJoyAxis do: [ :evt |
		self onJoyAxis: evt.
	].

]

{ #category : #'event handling' }
RWMouseKeyControl >> mapTrigger: value [
	| newValue |
	newValue := value / 32768.0.
	newValue < 0.2 ifTrue: [ ^ 0.0 ].
	^ newValue
]

{ #category : #'event handling' }
RWMouseKeyControl >> mapTriggerHard: value [
	^ (self mapTrigger: value) > 0.5 ifTrue: [ 1.0 ] ifFalse: [ 0.0 ].
]

{ #category : #'event handling' }
RWMouseKeyControl >> onJoyAxis: event [
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

]

{ #category : #'event handling' }
RWMouseKeyControl >> onKeyDown: event [
	| symbol velocity angularVelocity |
	symbol := event symbol.

	velocity := movement velocity.
	angularVelocity := movement angularVelocity.
	
	symbol == OSK_w ifTrue: [ velocity z: -1.0 ].
	symbol == OSK_s ifTrue: [ velocity z: 1.0 ].
	symbol == OSK_a ifTrue: [ velocity x: -1.0 ].
	symbol == OSK_d ifTrue: [ velocity x: 1.0 ].
	symbol == OSK_SPACE ifTrue: [ velocity y: 1.0 ].
	symbol = OSK_LCTRL ifTrue: [ velocity y: -1.0 ].
	symbol = OSK_LSHIFT ifTrue: [ movement speed: 3.0 ].
	
	symbol = OSK_LEFT ifTrue: [ angularVelocity y: 1.0 ].
	symbol = OSK_RIGHT ifTrue: [ angularVelocity y: -1.0 ].
	symbol = OSK_UP ifTrue: [ angularVelocity x: 1.0 ].
	symbol = OSK_DOWN ifTrue: [ angularVelocity x: -1.0 ].
	
	"Use the same magnitude for the velocity."
	velocity length2 > 0.001 ifTrue: [ velocity := velocity normalized * self class velocityMagnitude ].
	
	"Update the velocity and the angular velocity."
	movement velocity: velocity;
		angularVelocity: angularVelocity
]

{ #category : #'event handling' }
RWMouseKeyControl >> onKeyUp: event [
	| symbol velocity angularVelocity |
	symbol := event symbol.

	velocity := movement velocity.
	angularVelocity := movement angularVelocity.
	
	symbol == OSK_w ifTrue: [ velocity z < 0.0 ifTrue: [ velocity z: 0.0 ] . velocity z: 0.0 ].
	symbol == OSK_s ifTrue: [ velocity z > 0.0 ifTrue: [ velocity z: 0.0 ] . velocity z: 0.0 ].
	symbol == OSK_a ifTrue: [ velocity x < 0.0 ifTrue: [ velocity x: 0.0 ] . velocity x: 0.0 ].
	symbol == OSK_d ifTrue: [ velocity x > 0.0 ifTrue: [ velocity x: 0.0 ] . velocity x: 0.0 ].
	symbol == OSK_SPACE ifTrue: [ velocity y > 0.0 ifTrue: [ velocity y: 0.0 ] . velocity y: 0.0 ].
	symbol = OSK_LCTRL ifTrue: [ velocity y < 0.0 ifTrue: [ velocity y: 0.0 ] . velocity y: 0.0 ].
	symbol = OSK_LSHIFT ifTrue: [ movement speed: 1.0 ].
	
	symbol = OSK_LEFT ifTrue: [ angularVelocity y > 0.0 ifTrue: [ angularVelocity y: 0.0 ] ].
	symbol = OSK_RIGHT ifTrue: [ angularVelocity y < 0.0 ifTrue: [ angularVelocity y: 0.0 ] ].
	symbol = OSK_UP ifTrue: [ angularVelocity x > 0.0 ifTrue: [ angularVelocity x: 0.0 ] ].
	symbol = OSK_DOWN ifTrue: [ angularVelocity x < 0.0 ifTrue: [ angularVelocity x: 0.0 ] ].
	
	"Use the same magnitude for the velocity."
	velocity length2 > 0.001 ifTrue: [ velocity := velocity normalized * self class velocityMagnitude ].
	
	"Update the velocity and the angular velocity."
	movement velocity: velocity;
		angularVelocity: angularVelocity
]

{ #category : #'event handling' }
RWMouseKeyControl >> onMouseDrag: event [
	| angleDelta |
	angleDelta := (WMVector3F x: event delta y negated y: event delta x negated z: 0.0) * self class angleDragScale.
	movement angle: movement angle + angleDelta.
]
