Class {
	#name : #WDCOSWindow,
	#superclass : #OSWindowEventVisitor,
	#instVars : [
		'engine',
		'window',
		'renderTarget',
		'resolveRenderTarget',
		'handledHere'
	],
	#category : 'WodenEngine-Core-Window'
}

{ #category : #'instance creation' }
WDCOSWindow >> checkRenderTargets [
	| innerExtent |
	renderTarget ifNil: [
		self createRenderTarget
	].

	innerExtent := self drawingSurfaceExtent.
	renderTarget extent: innerExtent.
	resolveRenderTarget extent: innerExtent.
]

{ #category : #'instance creation' }
WDCOSWindow >> close [
	window destroy.
	resolveRenderTarget ifNotNil: [
		resolveRenderTarget release.
		renderTarget ~~ resolveRenderTarget ifTrue: [ renderTarget release ].
	].

	resolveRenderTarget := nil.
	renderTarget := nil

]

{ #category : #rendering }
WDCOSWindow >> commitSurface [
	resolveRenderTarget ifNotNil: [ resolveRenderTarget swapBuffers ]
]

{ #category : #'instance creation' }
WDCOSWindow >> createRenderTarget [
	self sampleCount > 1 ifTrue: [
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

		renderTarget := resolveRenderTarget
	].
]

{ #category : #accessing }
WDCOSWindow >> defaultExtent [
	^ 640@480
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

{ #category : #accessing }
WDCOSWindow >> fullscreen: aBoolean [
	window fullscreen: aBoolean
]

{ #category : #'event processing' }
WDCOSWindow >> handleEvent: anEvent [
	handledHere := false.
	anEvent accept: self.

]

{ #category : #'framebuffer description' }
WDCOSWindow >> hasDepth [
	^ false
]

{ #category : #'framebuffer description' }
WDCOSWindow >> hasStencil [
	^ false
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

{ #category : #'framebuffer description' }
WDCOSWindow >> sampleCount [
	^ 1
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
	anEvent suppressDefaultAction.
	self close.
	handledHere := true.
]
