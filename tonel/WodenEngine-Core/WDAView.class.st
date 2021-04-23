"
I am a Woden application view.
"
Class {
	#name : #WDAView,
	#superclass : #WDAEventVisitor,
	#traits : 'TWDCRenderingDependencyGraphNode',
	#classTraits : 'TWDCRenderingDependencyGraphNode classTrait',
	#instVars : [
		'engine',
		'model',
		'window',
		'fullscreen',
		'subViews',
		'hasMouseCapture',
		'sampleCount',
		'eventFilter'
	],
	#pools : [
		'AGPUConstants',
		'OSKeySymbols'
	],
	#category : #'WodenEngine-Core-Application'
}

{ #category : #construction }
WDAView class >> defaultSampleCount [
	^ WDCEngine defaultSampleCount
]

{ #category : #'as yet unclassified' }
WDAView class >> engine: engine model: aModel [
	^ self new engine: engine model: aModel
]

{ #category : #adding }
WDAView >> addRenderingElementsToGraph: aRenderingGraph [
	aRenderingGraph addNodes: subViews
]

{ #category : #adding }
WDAView >> addSubView: aSubView [
	subViews := (subViews copyWithout: aSubView) copyWith: aSubView
]

{ #category : #'mouse capture' }
WDAView >> captureMouse [
	window captureMouse.
	hasMouseCapture := true.
]

{ #category : #updating }
WDAView >> changed [
	model changed
]

{ #category : #opening }
WDAView >> close [
	window ifNotNil: [ window close ]
]

{ #category : #'event processing' }
WDAView >> closeRequested [
	self close
]

{ #category : #opening }
WDAView >> closed [
	model ifNotNil: [ model removeView: self ]
]

{ #category : #'rendering process stages' }
WDAView >> commitSurfaces [
	window commitSurface
]

{ #category : #opening }
WDAView >> createWidgetInMorphic [
	window := (WDAMorphicViewWindow for: self) engine: engine; yourself.
	self openedWithWindow: window.
	^ window
]

{ #category : #accessing }
WDAView >> defaultExtent [
	^ 640@480
]

{ #category : #accessing }
WDAView >> drawingSurfaceExtent [
	^ window drawingSurfaceExtent
]

{ #category : #accessing }
WDAView >> editorViewType [
	^ nil
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

{ #category : #accessing }
WDAView >> eventFilter [
	^ eventFilter ifNil: [ eventFilter := WDADefaultEventFilter new view: self ]
]

{ #category : #accessing }
WDAView >> extent [
	^ window extent
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

{ #category : #events }
WDAView >> handleEvent: anEvent [
	^ self eventFilter handleEvent: anEvent
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
	hasMouseCapture := false.
	subViews := #().
]

{ #category : #accessing }
WDAView >> model [
	^ model
]

{ #category : #accessing }
WDAView >> model: anObject [
	model := anObject
]

{ #category : #'framebuffer description' }
WDAView >> needsDirectRenderTarget [
	^ true
]

{ #category : #testing }
WDAView >> needsToRender [
	^ false
]

{ #category : #opening }
WDAView >> openInMorphic [
	^ self createWidgetInMorphic
		openInWindow;
		yourself

]

{ #category : #opening }
WDAView >> openInOSWindow [
	window := (WDAOSWindowViewWindow for: self) engine: engine; yourself.
	window open.
	self openedWithWindow: window.
	^ window
]

{ #category : #opening }
WDAView >> openInVirtualWindow [
	window := (WDAVirtualWindowViewWindow for: self) engine: engine; yourself.
	window open.
	self openedWithWindow: window.
	^ window
]

{ #category : #opening }
WDAView >> openOnRenderTargetTexture: screenTexture [ 
	window := (WDAVirtualWindowViewWindow for: self)
		engine: engine;
		screenTargetTexture: screenTexture;
		yourself.
	window open.
	self openedWithWindow: window.
	^ window
]

{ #category : #opening }
WDAView >> openedWithWindow: aWindow [
]

{ #category : #'rendering process stages' }
WDAView >> prepareRendering [
	window prepareRendering.
]

{ #category : #'event processing' }
WDAView >> processEvents [
	window ifNotNil: #processEvents
]

{ #category : #'mouse capture' }
WDAView >> releaseMouse [
	window releaseMouse.
	hasMouseCapture := false.
]

{ #category : #adding }
WDAView >> removeSubView: aSubView [
	subViews := subViews copyWithout: aSubView
]

{ #category : #'rendering graph' }
WDAView >> renderingGraphDependencies [
	^ { model } , subViews
]

{ #category : #'framebuffer description' }
WDAView >> sampleCount [
	^ sampleCount ifNil: [sampleCount := self class defaultSampleCount]
]

{ #category : #'framebuffer description' }
WDAView >> sampleCount: aSampleCount [
	^ sampleCount := aSampleCount
]

{ #category : #path }
WDAView >> sessionChanged [
	window ifNotNil: [ window sessionChanged ].
	subViews do: [ :each | each session changed ].
]

{ #category : #'window handling' }
WDAView >> toggleFullscreen [
	self fullscreen: self fullscreen not
]

{ #category : #'mouse capture' }
WDAView >> toggleMouseCapture [
	hasMouseCapture ifTrue: [ 
		self releaseMouse
	] ifFalse: [
		self captureMouse
	]
]

{ #category : #'rendering process stages' }
WDAView >> updateForFrameDelta: delta [
	subViews do: [:sv | sv updateForFrameDelta: delta].
]

{ #category : #'event processing' }
WDAView >> visitWindowCloseEvent: event [
	self closeRequested
]

{ #category : #accessing }
WDAView >> window [
	^ window
]

{ #category : #accessing }
WDAView >> window: anObject [
	window := anObject
]

{ #category : #'framebuffer description' }
WDAView >> windowSampleCount [
	^ self sampleCount
]
