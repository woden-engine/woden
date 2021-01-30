"
I am a default event filter that is used for synthesizing mouse dragging events, clicks, and double clicks.
"
Class {
	#name : #WDADefaultEventFilter,
	#superclass : #WDAEventVisitor,
	#instVars : [
		'view',
		'downMask',
		'lastPressTime',
		'lastClickTime',
		'lastPressButton',
		'lastPressPosition',
		'dragStartButton',
		'isDragging',
		'dragStartPosition'
	],
	#classVars : [
		'ClickThreshold',
		'DoubleClickThreshold',
		'DragStartMovementThreshold'
	],
	#pools : [
		'AGPUConstants',
		'OSKeySymbols'
	],
	#category : #'WodenEngine-Core-Application-Events'
}

{ #category : #'class initialization' }
WDADefaultEventFilter class >> initialize [
	DoubleClickThreshold := 600.
	ClickThreshold := 300.
	DragStartMovementThreshold := 2.
]

{ #category : #visiting }
WDADefaultEventFilter >> attemptClickWith: event [
	| timestamp cls |
	(event button = lastPressButton and: [ downMask = (1 << event button) ]) ifFalse: [ ^ self ].
	
	timestamp := Time millisecondClockValue.
	(timestamp - lastPressTime) <= ClickThreshold ifFalse: [ ^ self ].

	cls := (lastClickTime - timestamp) <= DoubleClickThreshold
		ifTrue: [ WDAClickEvent ]
		ifFalse: [ WDADoubleClickEvent ].
	lastClickTime := timestamp.

	self handleEvent: ((cls for: event window)
		button: event button;
		position: event position;
		modifiers: event modifiers;
		yourself)
]

{ #category : #visiting }
WDADefaultEventFilter >> attemptDragEndWith: event [
	isDragging ifFalse: [ ^ self ].
	event button = dragStartButton ifFalse: [ ^ self ].

	isDragging := false.
	self handleEvent: ((WDAMouseDragEndEvent for: event window)
		button: event button;
		position: event position;
		modifiers: event modifiers;
		yourself)

]

{ #category : #visiting }
WDADefaultEventFilter >> attemptDragStartWith: event [
	| delta|
	isDragging ifTrue: [ ^ self ].
	
	delta := event position - dragStartPosition.
	delta asFloat32x2 length < DragStartMovementThreshold ifTrue: [ ^ self ].
	isDragging := true.
	
	"Drag start"
	self handleEvent: ((WDAMouseDragStartEvent for: event window)
		button: dragStartButton;
		position: dragStartPosition;
		modifiers: event modifiers;
		yourself).
		
	"First drag with the threshold delta."
	self handleEvent: ((WDAMouseDragEvent for: event window)
		position: event position;
		startButton: dragStartButton;
		startPosition: dragStartPosition;
		delta: delta;
		modifiers: event modifiers;
		yourself).
]

{ #category : #events }
WDADefaultEventFilter >> handleEvent: anEvent [
	anEvent accept: self.
	anEvent accept: view.
	anEvent performDefaultAction
]

{ #category : #initialization }
WDADefaultEventFilter >> initialize [
	super initialize.
	downMask := 0.
	lastPressButton := 0.
	dragStartButton := 0.
	lastPressTime := 0.
	lastClickTime := 0.
	isDragging := false.
]

{ #category : #accessing }
WDADefaultEventFilter >> view [

	^ view
]

{ #category : #accessing }
WDADefaultEventFilter >> view: anObject [

	view := anObject
]

{ #category : #visiting }
WDADefaultEventFilter >> visitMouseButtonPressEvent: event [
	lastPressButton := event button.
	downMask = 0 ifTrue: [ 
		dragStartButton := event button.
		dragStartPosition := event position.
	].
	downMask := downMask | (1<<event button).
	lastPressTime := Time millisecondClockValue.
	lastPressPosition := event position.
]

{ #category : #visiting }
WDADefaultEventFilter >> visitMouseButtonReleaseEvent: event [
	isDragging ifTrue: [
		self attemptDragEndWith: event
	] ifFalse: [
		self attemptClickWith: event
	].

	downMask := downMask & (1 << event button) bitInvert

]

{ #category : #visiting }
WDADefaultEventFilter >> visitMouseMoveEvent: event [
	downMask = 0 ifTrue: [ ^ self ].
	
	isDragging ifTrue: [
		self handleEvent: ((WDAMouseDragEvent for: event window)
			position: event position;
			delta: event delta;
			modifiers: event modifiers;
			startButton: dragStartButton;
			startPosition: dragStartPosition;
			yourself).
	] ifFalse: [
		self attemptDragStartWith: event
	].

]
