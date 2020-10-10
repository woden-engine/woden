Class {
	#name : #WDCOSWindow,
	#superclass : #OSWindowEventVisitor,
	#instVars : [
		'engine',
		'window',
		'renderTarget',
		'resolveRenderTarget',
		'handledHere',
		'eventQueue'
	],
	#category : #'WodenEngine-Core-Window'
}

{ #category : #'mouse capture' }
WDCOSWindow >> captureMouse [
	window captureMouse
]

{ #category : #'instance creation' }
WDCOSWindow >> checkRenderTargets [
	| innerExtent |
	resolveRenderTarget ifNil: [
		self createRenderTarget
	].

	innerExtent := self drawingSurfaceExtent.
	renderTarget ifNotNil: [renderTarget extent: innerExtent].
	resolveRenderTarget extent: innerExtent.
]

{ #category : #'instance creation' }
WDCOSWindow >> close [
	engine renderingProcessCritical: [ 
		"Destroy the swap chain before destroying the window. Otherwise, we can get a deadlock."
		self destroySwapChainSafely.

		"Destroy the window."
		window destroy.
	].

]

{ #category : #rendering }
WDCOSWindow >> commitSurface [
	resolveRenderTarget ifNotNil: [ resolveRenderTarget swapBuffers ]
]

{ #category : #'instance creation' }
WDCOSWindow >> createRenderTarget [
	(self sampleCount > 1 and: [self needsDirectRenderTarget]) ifTrue: [
		renderTarget := WDCRenderTarget for: engine extent: self drawingSurfaceExtent.
		renderTarget
			hasDepth: self hasDepth;
			hasStencil: self hasStencil;
			sampleCount: self sampleCount;
			createFramebuffers.

		resolveRenderTarget := WDCSwapChainRenderTarget for: engine extent: self drawingSurfaceExtent windowHandle: window platformSpecificHandle.
		resolveRenderTarget
			hasDepth: false;
			hasStencil: false;
			sampleCount: 1;
			createFramebuffers.
	] ifFalse: [
		resolveRenderTarget := WDCSwapChainRenderTarget for: engine extent: self drawingSurfaceExtent windowHandle: window platformSpecificHandle.
		resolveRenderTarget
			hasDepth: self hasDepth;
			hasStencil: self hasStencil;
			sampleCount: 1;
			createFramebuffers.

		renderTarget := self needsDirectRenderTarget ifTrue: [ resolveRenderTarget ] ifFalse: [ nil ] 
	].
]

{ #category : #accessing }
WDCOSWindow >> defaultExtent [
	^ 640@480
]

{ #category : #accessing }
WDCOSWindow >> destroySwapChainSafely [
	resolveRenderTarget ifNotNil: [
		engine device finishExecution.
		resolveRenderTarget release.
		renderTarget ~~ resolveRenderTarget ifTrue: [ renderTarget release ].
				
		resolveRenderTarget := nil.
		renderTarget := nil.
	].
]

{ #category : #'instance creation' }
WDCOSWindow >> drawingSurfaceExtent [
	^ window extent
]

{ #category : #accessing }
WDCOSWindow >> engine [
	^ engine
]

{ #category : #accessing }
WDCOSWindow >> engine: anObject [
	engine := anObject
]

{ #category : #'event processing' }
WDCOSWindow >> enqueueEvent: anEvent [
	eventQueue nextPut: anEvent
]

{ #category : #accessing }
WDCOSWindow >> fullscreen: aBoolean [
	window fullscreen: aBoolean
]

{ #category : #'event processing' }
WDCOSWindow >> handleEvent: anEvent [
	anEvent suppressDefaultAction.
	self enqueueEvent: anEvent.

]

{ #category : #'framebuffer description' }
WDCOSWindow >> hasDepth [
	^ false
]

{ #category : #'framebuffer description' }
WDCOSWindow >> hasStencil [
	^ false
]

{ #category : #initialization }
WDCOSWindow >> initialize [
	super initialize.
	eventQueue := WaitfreeQueue new.
]

{ #category : #'framebuffer description' }
WDCOSWindow >> needsDirectRenderTarget [
	^ true
]

{ #category : #'instance creation' }
WDCOSWindow >> open [
	| attrs |
	attrs := OSWindowAttributes new.
	attrs 
		extent: self defaultExtent;
		visible: false;
		windowCentered: true.
		
	window := OSWindow createWithAttributes: attrs.
	window eventHandler: self;
		show.
	
	self createRenderTarget.

]

{ #category : #rendering }
WDCOSWindow >> prepareRendering [
]

{ #category : #'event processing' }
WDCOSWindow >> processEvent: anEvent [
	handledHere := false.
	anEvent accept: self.

]

{ #category : #'event processing' }
WDCOSWindow >> processEvents [
	[eventQueue isEmpty ] whileFalse: [ 
		eventQueue nextOrNil ifNotNil: [ :event |
			self processEvent: event
		]
	]
]

{ #category : #'mouse capture' }
WDCOSWindow >> releaseMouse [
	window releaseMouse
]

{ #category : #'framebuffer description' }
WDCOSWindow >> sampleCount [
	^ 1
]

{ #category : #path }
WDCOSWindow >> sessionChanged [
	window := nil.
	resolveRenderTarget := nil.
	renderTarget := nil.
	self open
]

{ #category : #rendering }
WDCOSWindow >> validRenderTarget [
	self checkRenderTargets.
	^ renderTarget
]

{ #category : #rendering }
WDCOSWindow >> validResolveRenderTarget [
	self checkRenderTargets.
	^ resolveRenderTarget
]

{ #category : #'event processing' }
WDCOSWindow >> visitWindowCloseEvent: anEvent [
	self close.
	handledHere := true.
]
