Class {
	#name : #WDVsTkVirtualHostWindow,
	#superclass : #VsTkVirtualHostWindow,
	#traits : 'TVsTkOSWindowEventDispatcher',
	#classTraits : 'TVsTkOSWindowEventDispatcher classTrait',
	#category : #'WodenEngine-Pompeii-Vesuvius'
}

{ #category : #'oswindow event dispatching' }
WDVsTkVirtualHostWindow >> dispatchHidden: shownEvent [
	visible := false.
]

{ #category : #'oswindow event dispatching' }
WDVsTkVirtualHostWindow >> dispatchMouseEvent: event [
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
WDVsTkVirtualHostWindow >> dispatchMove: anEvent [
]

{ #category : #'oswindow event dispatching' }
WDVsTkVirtualHostWindow >> dispatchShown: shownEvent [
	visible := true.
	self changed.
]

{ #category : #initialization }
WDVsTkVirtualHostWindow >> initialize [
	super initialize.
	self autolayout: true
]
