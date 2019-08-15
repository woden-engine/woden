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

	event symbol = OSK_a ifTrue: [ leftStickDirection x: -1.0 ].
	event symbol = OSK_d ifTrue: [ leftStickDirection x: 1.0 ].
	event symbol = OSK_s ifTrue: [ leftStickDirection y: -1.0 ].
	event symbol = OSK_w ifTrue: [ leftStickDirection y: 1.0 ].

	event symbol = OSK_UP ifTrue: [ rightStickDirection y: 1.0 ].
	event symbol = OSK_DOWN ifTrue: [ rightStickDirection y: -1.0 ].
	event symbol = OSK_LEFT ifTrue: [ rightStickDirection x: -1.0 ].
	event symbol = OSK_RIGHT ifTrue: [ rightStickDirection x: 1.0 ].

	event symbol = OSK_e ifTrue: [ displacementStrategy activateUseCommand ].
	event symbol = OSK_LSHIFT ifTrue: [ self running: true ].
	event symbol = OSK_SPACE ifTrue: [
		self isCurrentlyWalking
			ifTrue: [ self jump ]
			ifFalse: [ linearAcceleration y: 2.0]
	].

	(event symbol = OSK_i and: [ event modifiers ctrl ]) ifTrue: [ self inspect ].
]

{ #category : #'event handling' }
WDESFPSPlayerBehaviorComponent >> onKeyUp: event [
	event symbol = OSK_a ifTrue: [ leftStickDirection x < 0 ifTrue: [ leftStickDirection x: 0.0 ] ].
	event symbol = OSK_d ifTrue: [ leftStickDirection x > 0 ifTrue: [ leftStickDirection x: 0.0 ] ].
	event symbol = OSK_s ifTrue: [ leftStickDirection y < 0 ifTrue: [ leftStickDirection y: 0.0 ] ].
	event symbol = OSK_w ifTrue: [ leftStickDirection y > 0 ifTrue: [ leftStickDirection y: 0.0 ] ].

	event symbol = OSK_LEFT ifTrue: [ rightStickDirection x < 0 ifTrue: [ rightStickDirection x: 0.0 ] ].
	event symbol = OSK_RIGHT ifTrue: [ rightStickDirection x > 0 ifTrue: [ rightStickDirection x: 0.0 ] ].
	event symbol = OSK_UP ifTrue: [ rightStickDirection y > 0 ifTrue: [ rightStickDirection y: 0.0 ] ].
	event symbol = OSK_DOWN ifTrue: [ rightStickDirection y < 0 ifTrue: [ rightStickDirection y: 0.0 ] ].

	event symbol = OSK_LSHIFT ifTrue: [ self running: false ].
	event symbol = OSK_SPACE ifTrue: [
		self isCurrentlyWalking ifFalse: [ linearAcceleration y: 0.0]
	].


]

{ #category : #'event handling' }
WDESFPSPlayerBehaviorComponent >> onMouseMotion: event [
	| angleScale |
	angleScale := Float pi / 180.0 * 0.25.
	headAngle := headAngle + (WMVector3F x: event delta y * angleScale negated y: event delta x * angleScale negated z: 0.0)
]
