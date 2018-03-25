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
WDAOSWindowViewWindow >> close [
	view ifNotNil: [view closed].
	super close
]

{ #category : #'event processing' }
WDAOSWindowViewWindow >> handleEvent: anEvent [
	super handleEvent: anEvent.
	handledHere ifTrue: [ ^ self ].
	
	view ifNotNil: [ view handleEvent: anEvent ]
]

{ #category : #'framebuffer description' }
WDAOSWindowViewWindow >> hasDepth [
	^ view hasDepth
]

{ #category : #'framebuffer description' }
WDAOSWindowViewWindow >> hasStencil [
	^ view hasStencil
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
