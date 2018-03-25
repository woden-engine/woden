Class {
	#name : #WTGSPlayerBehaviorEventHandler,
	#superclass : #OSWindowEventVisitor,
	#instVars : [
		'behavior'
	],
	#category : 'WodenEngine-GameSystem-Player'
}

{ #category : #accessing }
WTGSPlayerBehaviorEventHandler >> behavior [
	^ behavior
]

{ #category : #accessing }
WTGSPlayerBehaviorEventHandler >> behavior: anObject [
	behavior := anObject
]

{ #category : #'as yet unclassified' }
WTGSPlayerBehaviorEventHandler >> visitJoyAxisEvent: anEvent [
	behavior onJoyAxis: anEvent
]

{ #category : #'as yet unclassified' }
WTGSPlayerBehaviorEventHandler >> visitJoyButtonDownEvent: anEvent [
	behavior onJoyButtonDown: anEvent
]

{ #category : #'as yet unclassified' }
WTGSPlayerBehaviorEventHandler >> visitJoyButtonUpEvent: anEvent [
	behavior onJoyButtonUp: anEvent
]

{ #category : #'as yet unclassified' }
WTGSPlayerBehaviorEventHandler >> visitKeyDownEvent: anEvent [
	behavior onKeyDown: anEvent
]

{ #category : #'as yet unclassified' }
WTGSPlayerBehaviorEventHandler >> visitKeyUpEvent: anEvent [
	behavior onKeyUp: anEvent
]

{ #category : #'as yet unclassified' }
WTGSPlayerBehaviorEventHandler >> visitMouseButtonPressEvent: anEvent [
	behavior onMouseButtonDown: anEvent
]

{ #category : #'as yet unclassified' }
WTGSPlayerBehaviorEventHandler >> visitMouseButtonReleaseEvent: anEvent [
	behavior onMouseButtonUp: anEvent
]

{ #category : #'as yet unclassified' }
WTGSPlayerBehaviorEventHandler >> visitMouseMoveEvent: anEvent [
	behavior onMouseMove: anEvent
]
