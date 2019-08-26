Trait {
	#name : #TInputControllerBehavior,
	#category : #'WodenEngine-EntitySystem-Behaviors'
}

{ #category : #'as yet unclassified' }
TInputControllerBehavior classSide >> analogDeadZone [
	^ 8000
]

{ #category : #'as yet unclassified' }
TInputControllerBehavior >> gamepadMapAxis: value [
	| deadZone |
	deadZone := self class analogDeadZone.
	((value > deadZone negated) and: [ value < deadZone ]) ifTrue: [ ^ 0.0 ].
	^ value / 32768.0
]

{ #category : #'as yet unclassified' }
TInputControllerBehavior >> gamepadMapTrigger: value [
	| newValue |
	newValue := value / 32768.0.
	newValue < 0.2 ifTrue: [ ^ 0.0 ].
	^ newValue
]

{ #category : #'as yet unclassified' }
TInputControllerBehavior >> gamepadMapTriggerBinary: value [
	^ value > 16384 ifTrue: [ 1.0 ] ifFalse: [ 0.0 ]
]

{ #category : #'event handling' }
TInputControllerBehavior >> onJoyAxis: event [
]

{ #category : #'event handling' }
TInputControllerBehavior >> onJoyButtonDown: event [
]

{ #category : #'event handling' }
TInputControllerBehavior >> onJoyButtonUp: event [
]

{ #category : #'event handling' }
TInputControllerBehavior >> onKeyDown: event [
]

{ #category : #'event handling' }
TInputControllerBehavior >> onKeyUp: event [
]

{ #category : #'event handling' }
TInputControllerBehavior >> onMouseButtonDown: event [
]

{ #category : #'event handling' }
TInputControllerBehavior >> onMouseButtonUp: event [
]

{ #category : #'event handling' }
TInputControllerBehavior >> onMouseEnter: event [
]

{ #category : #'event handling' }
TInputControllerBehavior >> onMouseLeave: event [
]

{ #category : #'event handling' }
TInputControllerBehavior >> onMouseMotion: event [
]

{ #category : #'actor messages' }
TInputControllerBehavior >> sendInputEvent: inputEventSelector with: anEvent [
	^ self perform: inputEventSelector with: anEvent
]
