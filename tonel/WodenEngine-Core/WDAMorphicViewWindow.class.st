"
I am a morphic based view window for a Woden application.
"
Class {
	#name : #WDAMorphicViewWindow,
	#superclass : #WDCMorphicWindow,
	#instVars : [
		'view'
	],
	#classVars : [
		'KeySymbolMap',
		'MouseButtonMap'
	],
	#pools : [
		'OSKeySymbols'
	],
	#category : #'WodenEngine-Core-Application'
}

{ #category : #'instance creation' }
WDAMorphicViewWindow class >> for: aView [
	^ self basicNew
		view: aView;
		initialize;
		yourself
]

{ #category : #initialization }
WDAMorphicViewWindow class >> initialize [
	"
	self initialize
	"
	
	KeySymbolMap := IdentityDictionary newFromPairs: { 
		#A . OSK_a .
		#B . OSK_b .
		#C . OSK_c .
		#D . OSK_d .
		#E . OSK_e .
		#F . OSK_f .
		#G . OSK_g .
		#H . OSK_h .
		#I . OSK_i .
		#J . OSK_j .
		#K . OSK_k .
		#L . OSK_l .
		#M . OSK_m .
		#N . OSK_n .
		#O . OSK_o .
		#P . OSK_p .
		#Q . OSK_q .
		#R . OSK_r .
		#S . OSK_s .
		#T . OSK_t .
		#U . OSK_u .
		#W . OSK_w .
		#X . OSK_x .
		#Y . OSK_y .
		#Z . OSK_z .
		#SPACE . OSK_SPACE .
		#KP_SPACE . OSK_SPACE .
		#KP_UP . OSK_UP .
		#KP_LEFT . OSK_LEFT .
		#KP_RIGHT . OSK_RIGHT .
		#KP_DOWN . OSK_DOWN .
		#CONTROL_L . OSK_LCTRL.
		#SHIFT_L . OSK_LSHIFT.
		#ALT_L . OSK_LALT.
		#META_L . OSK_LGUI.
	}.
	
	MouseButtonMap := IdentityDictionary newFromPairs: #(
		4 1 "Left"
		2 3 "Right"
		1 2 "Middle"
	)
]

{ #category : #'initialize-release' }
WDAMorphicViewWindow >> announceDeleted [
	view ifNotNil: [view closed].
	^ super announceDeleted
]

{ #category : #'rendering process stages' }
WDAMorphicViewWindow >> commitSurfaces [
]

{ #category : #accessing }
WDAMorphicViewWindow >> defaultExtent [
	^ view defaultExtent
]

{ #category : #'event handling' }
WDAMorphicViewWindow >> handleKeyDown: evt [
	| event |
	view ifNotNil: [
		event := OSKeyDownEvent new.
		event repeat: 0.
		event symbol: (self keySymbolFor: evt key).
		self mousePosition: evt putOn: event.
		self modifiers: evt putOn: event.
		self enqueueEvent: event.
	].
]

{ #category : #'event handling' }
WDAMorphicViewWindow >> handleKeyUp: evt [
	| event |
	view ifNotNil: [
		event := OSKeyUpEvent new.
		event repeat: 0.
		event symbol: (self keySymbolFor: evt key).
		self mousePosition: evt putOn: event.
		self modifiers: evt putOn: event.
		self enqueueEvent: event.
	]
]

{ #category : #'event handling' }
WDAMorphicViewWindow >> handlesKeyboard: anEvent [
	^ anEvent wasHandled not
]

{ #category : #'event handling' }
WDAMorphicViewWindow >> handlesMouseDown: anEvent [
	^ anEvent wasHandled not
]

{ #category : #'event handling' }
WDAMorphicViewWindow >> handlesMouseMove: anEvent [
	^ anEvent wasHandled not 
]

{ #category : #'event handling' }
WDAMorphicViewWindow >> handlesMouseOver: anEvent [
	^ anEvent wasHandled not 
]

{ #category : #'event handling' }
WDAMorphicViewWindow >> handlesMouseWheel: anEvent [
	^ anEvent wasHandled not 
]

{ #category : #'framebuffer description' }
WDAMorphicViewWindow >> hasDepth [
	^ view hasDepth
]

{ #category : #'framebuffer description' }
WDAMorphicViewWindow >> hasStencil [
	^ view hasStencil
]

{ #category : #'event handling' }
WDAMorphicViewWindow >> keySymbolFor: key [
	^ KeySymbolMap at: key name ifAbsent: [ OSK_UNKNOWN ]
]

{ #category : #'event handling' }
WDAMorphicViewWindow >> mapMouseButton: button [
	^ MouseButtonMap at: button
]

{ #category : #'event handling' }
WDAMorphicViewWindow >> modifiers: anEvent putOn: osEvent [
	osEvent modifiers
		leftCtrl: anEvent controlKeyPressed;
		leftAlt: anEvent altKeyPressed;
		leftCmd: anEvent commandKeyPressed;
		leftShift: anEvent shiftPressed.

]

{ #category : #'event handling' }
WDAMorphicViewWindow >> mouseDown: evt [
	| osEvent |
	
	evt hand newKeyboardFocus: self.
	view ifNotNil: [
		osEvent := OSMouseButtonPressEvent new.
		osEvent button: (self mapMouseButton: (evt whichButton bitAnd: MouseEvent anyButton)).
		self mouseEventCommon: evt putOn: osEvent.
		self enqueueEvent: osEvent.
	].
	
	evt wasHandled: true.
	^ true.
]

{ #category : #'event handling' }
WDAMorphicViewWindow >> mouseEventCommon: anEvent putOn: osEvent [
	osEvent buttons
			button1: anEvent redButtonPressed;
			button2: anEvent yellowButtonPressed;
			button3: anEvent blueButtonPressed.
	self modifiers: anEvent putOn: osEvent.
	self mousePosition: anEvent putOn: osEvent.
]

{ #category : #'event handling' }
WDAMorphicViewWindow >> mouseMove: evt [
	| osEvent |
	
	evt hand newKeyboardFocus: self.
	view ifNotNil: [
		osEvent := OSMouseMoveEvent new
			delta: evt position - evt startPoint.
		self mouseEventCommon: evt putOn: osEvent.
		self enqueueEvent: osEvent.
	].
	
	evt wasHandled: true.
	^ true.
]

{ #category : #'event handling' }
WDAMorphicViewWindow >> mousePosition: anEvent putOn: osEvent [
	osEvent position: anEvent position - self bounds origin.
	lastMousePosition := osEvent position.
]

{ #category : #'event handling' }
WDAMorphicViewWindow >> mouseUp: evt [
	| osEvent |
	view ifNotNil: [
		osEvent := OSMouseButtonReleaseEvent new.
		osEvent button: (self mapMouseButton: evt whichButton).
		self mouseEventCommon: evt putOn: osEvent.
		self enqueueEvent: osEvent.
	].

	evt wasHandled: true.

]

{ #category : #'event handling' }
WDAMorphicViewWindow >> mouseWheel: evt [
	| osEvent |
	view ifNotNil: [
		osEvent := OSMouseWheelEvent new.
		self mouseEventCommon: evt putOn: osEvent.
		evt isUp ifTrue: [ osEvent scrollVertical: 1 ].
		evt isDown ifTrue: [ osEvent scrollVertical: -1 ].
		evt isLeft ifTrue: [ osEvent scrollHorizontal: -1 ].
		evt isRight ifTrue: [ osEvent scrollHorizontal: 1 ].
		self enqueueEvent: osEvent.
	].

]

{ #category : #'framebuffer description' }
WDAMorphicViewWindow >> needsDirectRenderTarget [
	^ view needsDirectRenderTarget
]

{ #category : #'events-processing' }
WDAMorphicViewWindow >> processOSWindowEvent: anEvent [
	super processOSWindowEvent: anEvent.
	handledHere ifTrue: [ ^ self ].
	
	view ifNotNil: [ view handleEvent: anEvent ]
]

{ #category : #'framebuffer description' }
WDAMorphicViewWindow >> sampleCount [
	^ view sampleCount
]

{ #category : #accessing }
WDAMorphicViewWindow >> view [
	^ view
]

{ #category : #accessing }
WDAMorphicViewWindow >> view: anObject [
	view := anObject
]

{ #category : #visiting }
WDAMorphicViewWindow >> visitWindowCloseEvent: anEvent [
	view ifNil: [ ^ super visitWindowCloseEvent: anEvent ]
]
