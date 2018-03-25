Class {
	#name : #RWSceneView,
	#superclass : #WDASceneView,
	#instVars : [
		'dragElement',
		'mouseFocusElement'
	],
	#category : 'WodenEngine-Roassal-Core'
}

{ #category : #selection }
RWSceneView >> elementInPosition: aPoint [
	^ self elementInPositionWithRayPicking: aPoint

]

{ #category : #selection }
RWSceneView >> elementInPositionWithRayPicking: aPoint [
	| nx ny extent |
	extent := window drawingSurfaceExtent.
	nx := aPoint x / extent x asFloat.
	ny := 1.0 - (aPoint y / extent y).
	^ model rayPickNormalizedPosition: nx @ ny.

]

{ #category : #visiting }
RWSceneView >> mouseFocusElement [
	^ mouseFocusElement ifNil: [ mouseFocusElement := model ]
]

{ #category : #visiting }
RWSceneView >> onMouseDrag: event [
	| r3Event |
	r3Event := RWMouseDrag new buttons: event buttons;
		position: event position asWMVector2F;
		delta: event delta asWMVector2F;
		"element: dragElement."
		element: model.
	r3Event sendToElement.
	model signalUpdate

]

{ #category : #visiting }
RWSceneView >> onMouseOverElements: event [
	| elementBeingPointed leave enter move |
	elementBeingPointed := self elementInPosition: event position.
	self mouseFocusElement ~~ elementBeingPointed ifTrue: [
		leave := RWMouseLeave new.
		leave element: self mouseFocusElement;
			position: event position;
			sendToElement.

		enter := RWMouseEnter new.
		enter element: elementBeingPointed;
			position: event position;
			sendToElement.
		mouseFocusElement := elementBeingPointed.
	] ifFalse: [
		move := RWMouseMove new.
		move element: self mouseFocusElement;
			position: event position;
			delta: event delta;
			sendToElement.
	].
	model signalUpdate
]

{ #category : #visiting }
RWSceneView >> sendMouseEvent: event [
	model announce: event
]

{ #category : #visiting }
RWSceneView >> visitJoyAxisEvent: event [
	| r3Event |
	event isPreferredEvent ifFalse: [ ^ self ].
	r3Event := RWJoyAxis new.
	r3Event which: event which;
		axis: event axis;
		value: event value.
	model announce: r3Event.

]

{ #category : #visiting }
RWSceneView >> visitJoyButtonDownEvent: event [
	| r3Event |
	event isPreferredEvent ifFalse: [ ^ self ].
	r3Event := RWJoyButtonDown new.
	r3Event which: event which;
		button: event button.
	model announce: r3Event.

]

{ #category : #visiting }
RWSceneView >> visitJoyButtonUpEvent: event [
	| r3Event |
	event isPreferredEvent ifFalse: [ ^ self ].
	r3Event := RWJoyButtonUp new.
	r3Event which: event which;
		button: event button.
	model announce: r3Event.

]

{ #category : #visiting }
RWSceneView >> visitKeyDownEvent: event [
	| r3Event |
	r3Event := RWKeyDown new symbol: event symbol.
	model announce: r3Event.
	model signalUpdate

]

{ #category : #visiting }
RWSceneView >> visitKeyUpEvent: event [
	| r3Event |
	r3Event := RWKeyUp new symbol: event symbol.
	model announce: r3Event.
	model signalUpdate
]

{ #category : #visiting }
RWSceneView >> visitMouseButtonPressEvent: event [
	"event is an OSMouseButtonPressEvent"
	| r3Event cls |
	cls := RWMouseButtonDown.
	
	"Is left button"
	event 	buttons button1 ifTrue: [ cls := RWMouseLeftButtonDown ].
	event 	buttons button2 ifTrue: [ cls := RWMouseRightButtonDown ].

	r3Event := cls new 
		buttons: event buttons;
		button: event button;
		position: event position;
		element: (self elementInPosition: event position).
	dragElement := r3Event element.
	r3Event sendToElement.
	
	model signalUpdate
]

{ #category : #visiting }
RWSceneView >> visitMouseButtonReleaseEvent: event [
	| r3Event |
	r3Event := RWMouseButtonUp new buttons: event buttons;
		position: event position asWMVector2F;
		button: event button.
	r3Event element: (self elementInPosition: event position).
	dragElement := nil.
	self sendMouseEvent: r3Event.
	model signalUpdate
]

{ #category : #visiting }
RWSceneView >> visitMouseMoveEvent: event [
	dragElement ifNotNil: [ self onMouseDrag: event ]
		ifNil: [ self onMouseOverElements: event ]
]
