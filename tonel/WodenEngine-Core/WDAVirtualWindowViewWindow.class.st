"
I am a virtual window based view window for a Woden application.
"
Class {
	#name : #WDAVirtualWindowViewWindow,
	#superclass : #WDCVirtualWindow,
	#instVars : [
		'view'
	],
	#category : #'WodenEngine-Core-Application'
}

{ #category : #'instance creation' }
WDAVirtualWindowViewWindow class >> for: aView [
	^ self basicNew
		view: aView;
		initialize;
		yourself
]

{ #category : #'initialize-release' }
WDAVirtualWindowViewWindow >> close [
	view ifNotNil: [view closed].
	super close
]

{ #category : #accessing }
WDAVirtualWindowViewWindow >> defaultExtent [
	^ view defaultExtent
]

{ #category : #testing }
WDAVirtualWindowViewWindow >> hasDepth [
	^ view hasDepth
]

{ #category : #testing }
WDAVirtualWindowViewWindow >> hasStencil [
	^ view hasStencil
]

{ #category : #events }
WDAVirtualWindowViewWindow >> processEvent: anEvent [
	view ifNotNil: [ view handleEvent: anEvent ]
]

{ #category : #'framebuffer description' }
WDAVirtualWindowViewWindow >> sampleCount [
	^ view sampleCount
]

{ #category : #accessing }
WDAVirtualWindowViewWindow >> view [
	^ view
]

{ #category : #accessing }
WDAVirtualWindowViewWindow >> view: anObject [
	view := anObject
]
