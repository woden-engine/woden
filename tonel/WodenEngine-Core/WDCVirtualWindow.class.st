Class {
	#name : #WDCVirtualWindow,
	#superclass : #Object,
	#instVars : [
		'engine',
		'extent',
		'renderTarget',
		'resolveRenderTarget',
		'session',
		'eventQueue'
	],
	#category : #'WodenEngine-Core-Window'
}

{ #category : #'mouse capture' }
WDCVirtualWindow >> captureMouse [
]

{ #category : #initialization }
WDCVirtualWindow >> checkRenderTarget [
	renderTarget ifNil: [
		self createRenderTarget
	].

	renderTarget extent: extent.
	resolveRenderTarget extent: extent
]

{ #category : #'session management' }
WDCVirtualWindow >> checkSession [
	engine checkSession.
	session ~~ Smalltalk session ifTrue: [
		self initializeForNewSession.
	].
]

{ #category : #'initialize-release' }
WDCVirtualWindow >> close [
	resolveRenderTarget ifNotNil: [
		resolveRenderTarget release.
		renderTarget ~~ resolveRenderTarget ifTrue: [ renderTarget release ].
	].
]

{ #category : #rendering }
WDCVirtualWindow >> commitSurface [
	"Nothing required here"
]

{ #category : #'instance creation' }
WDCVirtualWindow >> createRenderTarget [
	renderTarget := WDCRenderTarget for: engine extent: self drawingSurfaceExtent.
	renderTarget
		hasDepth: self hasDepth;
		hasStencil: self hasStencil;
		sampleCount: self sampleCount.
		
	self sampleCount > 1 ifTrue: [ 
		renderTarget createFramebuffers.
		
		resolveRenderTarget := WDCRenderTarget for: engine extent: self drawingSurfaceExtent.
		resolveRenderTarget
			hasDepth: false;
			hasStencil: false;
			sampleCount: 1;
			createFramebuffers.
	] ifFalse: [
		renderTarget createFramebuffers.
		resolveRenderTarget := renderTarget
	].
]

{ #category : #accessing }
WDCVirtualWindow >> defaultExtent [
	^ 640@480
]

{ #category : #'instance creation' }
WDCVirtualWindow >> drawingSurfaceExtent [
	^ extent
]

{ #category : #accessing }
WDCVirtualWindow >> engine [
	^ engine
]

{ #category : #accessing }
WDCVirtualWindow >> engine: anObject [
	engine := anObject
]

{ #category : #'event processing' }
WDCVirtualWindow >> enqueueEvent: anEvent [
	eventQueue nextPut: anEvent
]

{ #category : #accessing }
WDCVirtualWindow >> extent [
	^ extent
]

{ #category : #accessing }
WDCVirtualWindow >> extent: anObject [
	extent := anObject
]

{ #category : #'event processing' }
WDCVirtualWindow >> handleEvent: anEvent [
	self enqueueEvent: anEvent.

]

{ #category : #'framebuffer description' }
WDCVirtualWindow >> hasDepth [
	^ false
]

{ #category : #'framebuffer description' }
WDCVirtualWindow >> hasStencil [
	^ false
]

{ #category : #initialization }
WDCVirtualWindow >> initialize [
	super initialize.
	
	eventQueue := WaitfreeQueue new.
	self extent: self defaultExtent.
]

{ #category : #initialization }
WDCVirtualWindow >> initializeForNewSession [
	engine checkSession.
	renderTarget := nil.
	self checkRenderTarget.

	session := Smalltalk session.
	
]

{ #category : #'instance creation' }
WDCVirtualWindow >> open [
]

{ #category : #'event processing' }
WDCVirtualWindow >> processEvent: anEvent [
]

{ #category : #'event processing' }
WDCVirtualWindow >> processEvents [
	[eventQueue isEmpty ] whileFalse: [ 
		eventQueue nextOrNil ifNotNil: [ :event |
			self processEvent: event
		]
	]
]

{ #category : #'mouse capture' }
WDCVirtualWindow >> releaseMouse [
]

{ #category : #'framebuffer description' }
WDCVirtualWindow >> sampleCount [
	^ 1
]

{ #category : #accessing }
WDCVirtualWindow >> surfaceDrawingExtent [
	^ extent
]

{ #category : #rendering }
WDCVirtualWindow >> validRenderTarget [
	self checkSession; checkRenderTarget.
	^ renderTarget
]

{ #category : #rendering }
WDCVirtualWindow >> validResolveRenderTarget [
	self checkSession; checkRenderTarget.
	^ resolveRenderTarget
]
