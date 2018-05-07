Class {
	#name : #WDCMorphicWindow,
	#superclass : #BorderedMorph,
	#instVars : [
		'engine',
		'renderTarget',
		'session',
		'framebuffer',
		'displayForm',
		'resolveRenderTarget',
		'lastMousePosition'
	],
	#category : 'WodenEngine-Core-Window'
}

{ #category : #initialization }
WDCMorphicWindow >> checkRenderTarget [
	| innerExtent |
	renderTarget ifNil: [
		self createRenderTarget
	].

	innerExtent := self drawingSurfaceExtent.
	renderTarget extent: innerExtent.
	resolveRenderTarget extent: innerExtent.
	(displayForm isNil or: [ displayForm extent ~= innerExtent ]) ifTrue: [
		displayForm := Form extent: innerExtent depth: 32
	]
]

{ #category : #initialization }
WDCMorphicWindow >> checkSession [
	engine checkSession.
	session ~~ Smalltalk session ifTrue: [
		self initializeForNewSession.
	].
]

{ #category : #'initialize-release' }
WDCMorphicWindow >> close [
	^ self owner delete
]

{ #category : #rendering }
WDCMorphicWindow >> commitSurface [
	| pitch slicePitch |
	pitch := displayForm width * 4.
	slicePitch := pitch * displayForm height.
	displayForm unhibernate.
	
	engine graphicsQueue finishExecution.
	resolveRenderTarget currentFramebuffer colorAttachments first validHandle
		readTextureData: 0 arrayIndex: 0 pitch: pitch slicePitch: slicePitch buffer: displayForm bits.
		
	engine device hasBottomLeftTextureCoordinates ~= 0 ifTrue: [ 
		displayForm flipHorizontally
	].

	self changed
]

{ #category : #initialization }
WDCMorphicWindow >> createRenderTarget [
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
			gpuOnly: false;
			createFramebuffers.
	] ifFalse: [
		renderTarget gpuOnly: false; createFramebuffers.
		resolveRenderTarget := renderTarget
	].
]

{ #category : #initialization }
WDCMorphicWindow >> drawOn: aCanvas [
	engine ifNil: [ ^ self ].
	
	self checkSession.
	self checkRenderTarget.
	
	aCanvas translucentImage: displayForm at: self bounds origin.
]

{ #category : #initialization }
WDCMorphicWindow >> drawingSurfaceExtent [
	^ self innerBounds extent asIntegerPoint
]

{ #category : #accessing }
WDCMorphicWindow >> engine [
	^ engine
]

{ #category : #accessing }
WDCMorphicWindow >> engine: anObject [
	engine := anObject.
	session := nil.
	self changed.
]

{ #category : #accessing }
WDCMorphicWindow >> fullscreen: aBoolean [
]

{ #category : #'framebuffer description' }
WDCMorphicWindow >> hasDepth [
	^ false
]

{ #category : #'framebuffer description' }
WDCMorphicWindow >> hasStencil [
	^ false
]

{ #category : #initialization }
WDCMorphicWindow >> initialize [
	super initialize.
	
	self extent: 640@480.
	self clipSubmorphs: true.
]

{ #category : #initialization }
WDCMorphicWindow >> initializeForNewSession [
	engine checkSession.
	renderTarget := nil.
	lastMousePosition := 0@0.
	self checkRenderTarget.

	session := Smalltalk session.
	
]

{ #category : #rendering }
WDCMorphicWindow >> renderTarget [
	^ renderTarget
]

{ #category : #rendering }
WDCMorphicWindow >> resolveRenderTarget [
	^ resolveRenderTarget
]

{ #category : #'framebuffer description' }
WDCMorphicWindow >> sampleCount [
	^ 1
]

{ #category : #rendering }
WDCMorphicWindow >> validRenderTarget [
	self checkSession; checkRenderTarget.
	^ renderTarget
]

{ #category : #rendering }
WDCMorphicWindow >> validResolveRenderTarget [
	self checkSession; checkRenderTarget.
	^ resolveRenderTarget
]
