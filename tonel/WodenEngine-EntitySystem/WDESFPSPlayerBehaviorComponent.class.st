Class {
	#name : #WDESFPSPlayerBehaviorComponent,
	#superclass : #WDESCharacterBehaviorComponent,
	#traits : 'TInputControllerBehavior',
	#classTraits : 'TInputControllerBehavior classTrait',
	#category : #'WodenEngine-EntitySystem-Behaviors'
}

{ #category : #'event handling' }
WDESFPSPlayerBehaviorComponent >> onKeyDown: event [
	event repeat > 0 ifTrue: [ ^ 0 ].

	event symbol = OSK_a ifTrue: [ linearAcceleration x: -1.0 ].
	event symbol = OSK_d ifTrue: [ linearAcceleration x: 1.0 ].
	event symbol = OSK_w ifTrue: [ linearAcceleration z: -1.0 ].
	event symbol = OSK_s ifTrue: [ linearAcceleration z: 1.0 ].

	event symbol = OSK_UP ifTrue: [ headAngularVelocity x: 1.0 ].
	event symbol = OSK_DOWN ifTrue: [ headAngularVelocity x: -1.0 ].
	event symbol = OSK_LEFT ifTrue: [ headAngularVelocity y: 1.0 ].
	event symbol = OSK_RIGHT ifTrue: [ headAngularVelocity y: -1.0 ].

	event symbol = OSK_LSHIFT ifTrue: [ self running: true ].
	event symbol = OSK_SPACE ifTrue: [
		self isCurrentlyWalking
			ifTrue: [ self jump ]
			ifFalse: [ linearAcceleration y: 2.0]
	].

]

{ #category : #'event handling' }
WDESFPSPlayerBehaviorComponent >> onKeyUp: event [
	event symbol = OSK_a ifTrue: [ linearAcceleration x < 0 ifTrue: [ linearAcceleration x: 0.0 ] ].
	event symbol = OSK_d ifTrue: [ linearAcceleration x > 0 ifTrue: [ linearAcceleration x: 0.0 ] ].
	event symbol = OSK_w ifTrue: [ linearAcceleration z < 0 ifTrue: [ linearAcceleration z: 0.0 ] ].
	event symbol = OSK_s ifTrue: [ linearAcceleration z > 0 ifTrue: [ linearAcceleration z: 0.0 ] ].
	event symbol = OSK_LSHIFT ifTrue: [ self running: false ].
	event symbol = OSK_SPACE ifTrue: [
		self isCurrentlyWalking ifFalse: [ linearAcceleration y: 0.0]
	].

	event symbol = OSK_UP ifTrue: [ headAngularVelocity x > 0 ifTrue: [ headAngularVelocity x: 0.0 ] ].
	event symbol = OSK_DOWN ifTrue: [ headAngularVelocity x < 0 ifTrue: [ headAngularVelocity x: 0.0 ] ].
	event symbol = OSK_LEFT ifTrue: [ headAngularVelocity y > 0 ifTrue: [ headAngularVelocity y: 0.0 ] ].
	event symbol = OSK_RIGHT ifTrue: [ headAngularVelocity y < 0 ifTrue: [ headAngularVelocity y: 0.0 ] ].

]
