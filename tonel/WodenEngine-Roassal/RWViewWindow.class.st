Class {
	#name : #RWViewWindow,
	#superclass : #WTAnimatedApplication,
	#instVars : [
		'view',
		'fpsCount',
		'lastFpsDisplay',
		'lastUpdateTime',
		'mouseFocusElement',
		'keyboardFocusElement',
		'dragElement',
		'morphicWindow',
		'athensSurfaces',
		'lastRenderTime'
	],
	#pools : [
		'OSKeySymbols'
	],
	#category : 'WodenEngine-Roassal-Core'
}

{ #category : #selection }
RWViewWindow >> elementInPosition: aPoint [
	^ self elementInPositionWithRayPicking: aPoint

]

{ #category : #selection }
RWViewWindow >> elementInPositionWithRayPicking: aPoint [
	| nx ny |
	nx := aPoint x / window screenWidth.
	ny := 1.0 - (aPoint y / window screenHeight).
	^ view rayPickNormalizedPosition: nx @ ny.

]

{ #category : #initialization }
RWViewWindow >> initializeApplication [
	super initializeApplication.
	
	"Athens surfaces"
	athensSurfaces := engine frameBufferingCollect: [ :i | WTAthensSurface engine: engine ].

	"Fps counter"
	fpsCount := 0.
	lastFpsDisplay := Time millisecondClockValue * 0.001.
	dragElement := nil.
	mouseFocusElement := nil.
	keyboardFocusElement := nil.

]

{ #category : #'event handling' }
RWViewWindow >> onMouseDrag: event [
	| r3Event |
	r3Event := RWMouseDrag new buttons: event buttons;
		position: event position asWMVector2F;
		delta: event delta asWMVector2F;
		"element: dragElement."
		element: view.
	r3Event sendToElement.
	view signalUpdate

]

{ #category : #'event handling' }
RWViewWindow >> onMouseOverElements: event [
	| elementBeingPointed leave enter move |
	elementBeingPointed := self elementInPosition: event position.
	mouseFocusElement ~~ elementBeingPointed ifTrue: [
		leave := RWMouseLeave new.
		leave element: mouseFocusElement;
			position: event position;
			sendToElement.

		enter := RWMouseEnter new.
		enter element: elementBeingPointed;
			position: event position;
			sendToElement.
		mouseFocusElement := elementBeingPointed.
	] ifFalse: [
		move := RWMouseMove new.
		move element: mouseFocusElement;
			position: event position;
			delta: event delta;
			sendToElement.
	].
	view signalUpdate
]

{ #category : #drawing }
RWViewWindow >> renderFramesPerSecondOn: surface canvas: canvas [
	| font newRenderTime renderTime fps |
	newRenderTime := DateAndTime millisecondClockValue * 0.001.
	lastRenderTime ifNil: [ lastRenderTime := newRenderTime ].
	renderTime := newRenderTime - lastRenderTime.
	lastRenderTime := newRenderTime.
	(renderTime closeTo: 0.0) ifTrue: [ fps := 0.0 ] ifFalse: [ fps := 1.0 / renderTime ].
	font := engine fontCache default normal pointSize: 14.
	
	canvas setFont: font.
	canvas setPaint: (Color r: 0.0 g: 0.4 b: 0.0).
		
	canvas pathTransform restoreAfter: [
		canvas pathTransform translateX: 10 Y: (font getPreciseAscent).
		canvas drawString: (fps printShowingDecimalPlaces: 3) , ' FPS'.
	]
]

{ #category : #drawing }
RWViewWindow >> renderNoViewOnWindow: aWindow onAthensSurface: athensSurface [
	| font |
	font := engine fontCache default normal pointSize: 14.
	
	athensSurface drawDuring: [:canvas |
		athensSurface clear: Color red.
		
		canvas setFont: font.
		canvas setPaint: (Color r: 0.0 g: 0.4 b: 0.0).
		
		canvas pathTransform restoreAfter: [
			canvas pathTransform translateX: 10 Y: (font getPreciseAscent).
			canvas drawString: 'ERROR: Roassal View Window without a view'.
		]
	]
]

{ #category : #drawing }
RWViewWindow >> renderOnWindow: aWindow [
	| frameIndex framebuffer extent surface |
	frameIndex := engine newFrame.
	framebuffer := aWindow currentFramebuffer.
	extent := aWindow screenExtent.
	surface := athensSurfaces at: frameIndex.
	surface framebuffer: framebuffer extent: extent.

	view ifNil: [ ^ self renderNoViewOnWindow: aWindow onAthensSurface: surface].
	
	view render3DOnWindow: aWindow extraRenderTime: accumulatedUpdateTime.
	
	surface drawDuring: [:canvas |
		view render2DOnSurface: surface canvas: canvas.
		self renderFramesPerSecondOn: surface canvas: canvas
	].

]

{ #category : #'event handling' }
RWViewWindow >> sendMouseEvent: event [
	view announce: event
]

{ #category : #updating }
RWViewWindow >> simulateTime: delta [
	view ifNotNil: [ view simulateTime: delta ]
]

{ #category : #accessing }
RWViewWindow >> view [
	^ view
]

{ #category : #accessing }
RWViewWindow >> view: anObject [
	view := anObject.
	mouseFocusElement := view
]

{ #category : #'event handling' }
RWViewWindow >> visitJoyAxisEvent: event [
	| r3Event |
	event isPreferredEvent ifFalse: [ ^ self ].
	r3Event := RWJoyAxis new.
	r3Event which: event which;
		axis: event axis;
		value: event value.
	view announce: r3Event.

]

{ #category : #'event handling' }
RWViewWindow >> visitJoyButtonDownEvent: event [
	| r3Event |
	event isPreferredEvent ifFalse: [ ^ self ].
	r3Event := RWJoyButtonDown new.
	r3Event which: event which;
		button: event button.
	view announce: r3Event.

]

{ #category : #'event handling' }
RWViewWindow >> visitJoyButtonUpEvent: event [
	| r3Event |
	event isPreferredEvent ifFalse: [ ^ self ].
	r3Event := RWJoyButtonUp new.
	r3Event which: event which;
		button: event button.
	view announce: r3Event.

]

{ #category : #'event handling' }
RWViewWindow >> visitKeyDownEvent: event [
	| r3Event |
	r3Event := RWKeyDown new symbol: event symbol.
	view announce: r3Event.
	view signalUpdate

]

{ #category : #'event handling' }
RWViewWindow >> visitKeyUpEvent: event [
	| r3Event |
	r3Event := RWKeyUp new symbol: event symbol.
	view announce: r3Event.
	view signalUpdate
]

{ #category : #'event handling' }
RWViewWindow >> visitMouseButtonPressEvent: event [
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
	
	view signalUpdate
]

{ #category : #'event handling' }
RWViewWindow >> visitMouseButtonReleaseEvent: event [
	| r3Event |
	r3Event := RWMouseButtonUp new buttons: event buttons;
		position: event position asWMVector2F;
		button: event button.
	r3Event element: (self elementInPosition: event position).
	dragElement := nil.
	self sendMouseEvent: r3Event.
	view signalUpdate
]

{ #category : #'event handling' }
RWViewWindow >> visitMouseMoveEvent: event [
	dragElement ifNotNil: [ self onMouseDrag: event ]
		ifNil: [ self onMouseOverElements: event ]
]
