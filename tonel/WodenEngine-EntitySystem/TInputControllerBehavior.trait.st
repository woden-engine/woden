Trait {
	#name : #TInputControllerBehavior,
	#category : #'WodenEngine-EntitySystem-Behaviors'
}

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
