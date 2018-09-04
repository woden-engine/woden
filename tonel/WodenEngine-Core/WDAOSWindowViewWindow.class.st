"
I am an OSWindow based view window for a Woden application.
"
Class {
	#name : #WDAOSWindowViewWindow,
	#superclass : #WDCOSWindow,
	#instVars : [
		'view'
	],
	#category : 'WodenEngine-Core-Application'
}

{ #category : #'instance creation' }
WDAOSWindowViewWindow class >> for: aView [
	^ self basicNew
		view: aView;
		initialize;
		yourself
]

{ #category : #'instance creation' }
WDAOSWindowViewWindow >> close [
	view ifNotNil: [view closed].
	super close
]

{ #category : #accessing }
WDAOSWindowViewWindow >> defaultExtent [
	^ view defaultExtent
]

{ #category : #'framebuffer description' }
WDAOSWindowViewWindow >> hasDepth [
	^ view hasDepth
]

{ #category : #'framebuffer description' }
WDAOSWindowViewWindow >> hasStencil [
	^ view hasStencil
]

{ #category : #'event processing' }
WDAOSWindowViewWindow >> processEvent: anEvent [
	super processEvent: anEvent.
	handledHere ifTrue: [ ^ self ].
	
	view ifNotNil: [ view handleEvent: anEvent ]
]

{ #category : #'framebuffer description' }
WDAOSWindowViewWindow >> sampleCount [
	^ view sampleCount
]

{ #category : #accessing }
WDAOSWindowViewWindow >> view [
	^ view
]

{ #category : #accessing }
WDAOSWindowViewWindow >> view: anObject [
	view := anObject
]
