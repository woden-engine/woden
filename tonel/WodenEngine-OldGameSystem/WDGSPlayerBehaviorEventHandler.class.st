Class {
	#name : #WDGSPlayerBehaviorEventHandler,
	#superclass : #OSWindowEventVisitor,
	#instVars : [
		'behavior'
	],
	#category : #'WodenEngine-OldGameSystem-Player'
}

{ #category : #accessing }
WDGSPlayerBehaviorEventHandler >> behavior [
	^ behavior
]

{ #category : #accessing }
WDGSPlayerBehaviorEventHandler >> behavior: anObject [
	behavior := anObject
]

{ #category : #'as yet unclassified' }
WDGSPlayerBehaviorEventHandler >> visitJoyAxisEvent: anEvent [
	behavior onJoyAxis: anEvent
]

{ #category : #'as yet unclassified' }
WDGSPlayerBehaviorEventHandler >> visitJoyButtonDownEvent: anEvent [
	behavior onJoyButtonDown: anEvent
]

{ #category : #'as yet unclassified' }
WDGSPlayerBehaviorEventHandler >> visitJoyButtonUpEvent: anEvent [
	behavior onJoyButtonUp: anEvent
]

{ #category : #'as yet unclassified' }
WDGSPlayerBehaviorEventHandler >> visitKeyDownEvent: anEvent [
	behavior onKeyDown: anEvent
]

{ #category : #'as yet unclassified' }
WDGSPlayerBehaviorEventHandler >> visitKeyUpEvent: anEvent [
	behavior onKeyUp: anEvent
]

{ #category : #'as yet unclassified' }
WDGSPlayerBehaviorEventHandler >> visitMouseButtonPressEvent: anEvent [
	behavior onMouseButtonDown: anEvent
]

{ #category : #'as yet unclassified' }
WDGSPlayerBehaviorEventHandler >> visitMouseButtonReleaseEvent: anEvent [
	behavior onMouseButtonUp: anEvent
]

{ #category : #'as yet unclassified' }
WDGSPlayerBehaviorEventHandler >> visitMouseMoveEvent: anEvent [
	behavior onMouseMove: anEvent
]
