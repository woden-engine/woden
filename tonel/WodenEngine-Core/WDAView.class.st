"
I am a Woden application view.
"
Class {
	#name : #WDAView,
	#superclass : #OSWindowEventVisitor,
	#instVars : [
		'engine',
		'model',
		'window',
		'fullscreen'
	],
	#pools : [
		'AGPUConstants',
		'OSKeySymbols'
	],
	#category : 'WodenEngine-Core-Application'
}

{ #category : #'as yet unclassified' }
WDAView class >> engine: engine model: aModel [
	^ self new engine: engine model: aModel
]

{ #category : #opening }
WDAView >> close [
	window ifNotNil: [ window close ]
]

{ #category : #opening }
WDAView >> closed [
	model ifNotNil: [ model removeView: self ]
]

{ #category : #'rendering process stages' }
WDAView >> commitSurfaces [
	window commitSurface
]

{ #category : #accessing }
WDAView >> engine [
	^ engine
]

{ #category : #accessing }
WDAView >> engine: anEngine model: aModel [
	engine := anEngine.
	model := aModel.
	self engineChanged.
]

{ #category : #accessing }
WDAView >> engineChanged [
	
]

{ #category : #'window handling' }
WDAView >> fullscreen [
	^ fullscreen
]

{ #category : #'window handling' }
WDAView >> fullscreen: aBoolean [
	window ifNotNil: [ window fullscreen: aBoolean ].
	fullscreen := aBoolean.

]

{ #category : #'framebuffer description' }
WDAView >> hasDepth [
	^ false
]

{ #category : #'framebuffer description' }
WDAView >> hasStencil [
	^ false
]

{ #category : #initialization }
WDAView >> initialize [
	super initialize.
	
	fullscreen := false.
]

{ #category : #accessing }
WDAView >> model [
	^ model
]

{ #category : #accessing }
WDAView >> model: anObject [
	model := anObject
]

{ #category : #opening }
WDAView >> openInMorphic [
	window := WDAMorphicViewWindow new view: self; engine: engine; yourself.
	window openInWindow.
	^ window
]

{ #category : #opening }
WDAView >> openInOSWindow [
	window := WDAOSWindowViewWindow new view: self; engine: engine; yourself.
	window open.
	^ window
]

{ #category : #'rendering process stages' }
WDAView >> prepareRendering [
]

{ #category : #'framebuffer description' }
WDAView >> sampleCount [
	^ 1
]

{ #category : #'rendering process stages' }
WDAView >> sendRenderingCommands [
]

{ #category : #'window handling' }
WDAView >> toggleFullscreen [
	self fullscreen: self fullscreen not
]

{ #category : #'rendering process stages' }
WDAView >> updateForFrameDelta: delta [
]

{ #category : #accessing }
WDAView >> window [
	^ window
]

{ #category : #accessing }
WDAView >> window: anObject [
	window := anObject
]
