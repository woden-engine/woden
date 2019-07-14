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
	event symbol = OSK_SPACE ifTrue: [ self jump ].

]

{ #category : #'event handling' }
WDESFPSPlayerBehaviorComponent >> onKeyUp: event [
	event symbol = OSK_a ifTrue: [ linearAcceleration x < 0 ifTrue: [ linearAcceleration x: 0.0 ] ].
	event symbol = OSK_d ifTrue: [ linearAcceleration x > 0 ifTrue: [ linearAcceleration x: 0.0 ] ].
	event symbol = OSK_w ifTrue: [ linearAcceleration z < 0 ifTrue: [ linearAcceleration z: 0.0 ] ].
	event symbol = OSK_s ifTrue: [ linearAcceleration z > 0 ifTrue: [ linearAcceleration z: 0.0 ] ].

]
