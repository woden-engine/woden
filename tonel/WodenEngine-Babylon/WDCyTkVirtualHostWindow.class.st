Class {
	#name : #WDCyTkVirtualHostWindow,
	#superclass : #CyTkVirtualHostWindow,
	#traits : 'TCyTkOSWindowEventDispatcher',
	#classTraits : 'TCyTkOSWindowEventDispatcher classTrait',
	#category : #'WodenEngine-Babylon-Cyrus'
}

{ #category : #'oswindow event dispatching' }
WDCyTkVirtualHostWindow >> dispatchHidden: shownEvent [
	visible := false.
]

{ #category : #'oswindow event dispatching' }
WDCyTkVirtualHostWindow >> dispatchKeyDownEvent: osEvent [
	| event |
	event := CyTkKeyDownEvent new
		symbol: osEvent symbol;
		scanCode: osEvent scanCode;
		repeat: osEvent repeat;
		modifiers: (self translateModifiers: osEvent modifiers);
		yourself.
	self dispatchKeyboardEvent: event
]

{ #category : #'oswindow event dispatching' }
WDCyTkVirtualHostWindow >> dispatchKeyUpEvent: osEvent [
	| event |
	event := CyTkKeyUpEvent new
		symbol: osEvent symbol;
		scanCode: osEvent scanCode;
		repeat: osEvent repeat;
		modifiers: (self translateModifiers: osEvent modifiers);
		yourself.
	self dispatchKeyboardEvent: event
]

{ #category : #'oswindow event dispatching' }
WDCyTkVirtualHostWindow >> dispatchMouseButtonPressEvent: osEvent [
	| event |
	event := CyTkMouseButtonDownEvent new
		position: osEvent position;
		button: (self translateMouseButton: osEvent button);
		buttonState: (self translateMouseButtonState: osEvent modifiers);
		modifiers: (self translateModifiers: osEvent modifiers);
		yourself.
	
	osEvent button = 1 ifTrue: [ self beginClickAt: osEvent position ].
	self dispatchMouseEvent: event.
]

{ #category : #'oswindow event dispatching' }
WDCyTkVirtualHostWindow >> dispatchMouseButtonReleaseEvent: osEvent [
	| event |
	event := CyTkMouseButtonUpEvent new
		position: osEvent position;
		button: (self translateMouseButton: osEvent button);
		buttonState: (self translateMouseButtonState: osEvent modifiers);
		modifiers: (self translateModifiers: osEvent modifiers);
		yourself.
		
	self dispatchMouseEvent: event.
	
	osEvent button = 1 ifTrue: [ self endClickAt: osEvent position withModifiers: osEvent modifiers ].
]

{ #category : #'oswindow event dispatching' }
WDCyTkVirtualHostWindow >> dispatchMouseEvent: event [
	| oldMouseCapture result |
	[
		oldMouseCapture := self mouseCaptureOwner.

		self mouseCaptureOwner ifNil: [
			result := self processEvent: event
		] ifNotNil: [
			result := self mouseCaptureOwner processEvent: (event toLocalOrigin: self mouseCaptureOwner hostPosition) 
		]
	] doWhileTrue: [ oldMouseCapture ~~ self mouseCaptureOwner and: [ oldMouseCapture isNotNil ]].

	^ result
]

{ #category : #'oswindow event dispatching' }
WDCyTkVirtualHostWindow >> dispatchMouseMoveEvent: osEvent [
	| event |
	event := CyTkMouseMoveEvent new
		position: osEvent position;
		delta: osEvent delta;
		buttonState: (self translateMouseButtonState: osEvent modifiers);
		modifiers: (self translateModifiers: osEvent modifiers);
		yourself.
		
	self dispatchMouseEvent: event
	
]

{ #category : #'oswindow event dispatching' }
WDCyTkVirtualHostWindow >> dispatchMouseWheelEvent: osEvent [
	| event |
	event := CyTkMouseWheelEvent new
		position: osEvent position;
		scrollHorizontal: osEvent scrollHorizontal;
		scrollVertical: osEvent scrollVertical;
		buttonState: (self translateMouseButtonState: osEvent modifiers);
		modifiers: (self translateModifiers: osEvent modifiers);
		yourself.
		
	self dispatchMouseEvent: event
	
]

{ #category : #'oswindow event dispatching' }
WDCyTkVirtualHostWindow >> dispatchMove: anEvent [
]

{ #category : #'oswindow event dispatching' }
WDCyTkVirtualHostWindow >> dispatchShown: shownEvent [
	visible := true.
	self changed.
]

{ #category : #'oswindow event dispatching' }
WDCyTkVirtualHostWindow >> dispatchTextInputEvent: osEvent [
	| event |
	event := CyTkTextInputEvent new
		text: osEvent text;
		yourself.
	self dispatchKeyboardEvent: event
]

{ #category : #initialization }
WDCyTkVirtualHostWindow >> initialize [
	super initialize.
	self autolayout: true
]
