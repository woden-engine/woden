Class {
	#name : #WDCMorphicWindow,
	#superclass : #BorderedMorph,
	#instVars : [
		'engine',
		'renderTarget',
		'session',
		'displayForm',
		'resolveRenderTarget',
		'lastMousePosition',
		'handledHere',
		'eventQueue',
		'textureSceneGraphNode',
		'displayMutex',
		'displayTexture',
		'displayTextureExtent'
	],
	#category : #'WodenEngine-Core-Window'
}

{ #category : #'initialize-release' }
WDCMorphicWindow >> announceDeleted [
	engine renderingProcessCritical: [
		self destroyRenderingResources
	].
	^ super announceDeleted
]

{ #category : #rendering }
WDCMorphicWindow >> buildSceneGraphNodeWith: builder [
	self checkSession.
	^ displayMutex critical: [ 
		| texture textureExtent result |
		(builder isFormSGAGPUBuilder not or:
		[ displayTexture isNil or: [ displayTexture isNull ] ]) ifTrue: [ 
			^ builder rectangle: self bounds color: Color black
		].

		result := textureSceneGraphNode.
		textureExtent := displayTextureExtent.
		texture := displayTexture.
		(result isNil or: [textureSceneGraphNode texture ~= texture]) ifTrue: [
			textureSceneGraphNode := builder agpuTextureNode.
			textureSceneGraphNode
				isFullyOpaque: true;
				extent: textureExtent;
				sourceRectangle: (0@0 extent: textureExtent);
				texture: texture;
				view: (builder createViewForTexture: texture);
				rectangle: self innerBounds
		].
		result ifNil: [ result := textureSceneGraphNode ].
		result rectangle: self innerBounds.
		result
	]
]

{ #category : #'mouse capture' }
WDCMorphicWindow >> captureMouse [
]

{ #category : #initialization }
WDCMorphicWindow >> checkRenderTarget [
	| innerExtent |
	self world ifNil: [ ^ self ].

	renderTarget ifNil: [
		self createRenderTarget
	].

	innerExtent := self drawingSurfaceExtent.
	renderTarget ifNotNil: [renderTarget extent: innerExtent].
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
	displayMutex critical: [
		self isUsingAGPUWorldRenderer ifTrue: [
			| framebuffer colorAttachment |
			framebuffer := resolveRenderTarget framebuffers first.
			colorAttachment := framebuffer colorAttachments first.
			displayTexture := colorAttachment validHandle.
			displayTextureExtent := colorAttachment extent.
		] ifFalse: [ 
			self doCommitSurface
		].

		self changed
	].

]

{ #category : #initialization }
WDCMorphicWindow >> createRenderTarget [
	| gpuOnlyResolveTarget |
	renderTarget := WDCRenderTarget for: engine extent: self drawingSurfaceExtent.
	renderTarget
		hasDepth: self hasDepth;
		hasStencil: self hasStencil;
		sampleCount: self sampleCount.
	gpuOnlyResolveTarget := self isUsingAGPUWorldRenderer. 
	Transcript show: gpuOnlyResolveTarget; cr.
		
	self sampleCount > 1 ifTrue: [ 
		renderTarget createFramebuffers.
		
		resolveRenderTarget := WDCRenderTarget for: engine extent: self drawingSurfaceExtent.
		resolveRenderTarget
			hasDepth: false;
			hasStencil: false;
			sampleCount: 1;
			gpuOnly: gpuOnlyResolveTarget;
			createFramebuffers.
	] ifFalse: [
		renderTarget gpuOnly: gpuOnlyResolveTarget; createFramebuffers.
		resolveRenderTarget := renderTarget
	].
]

{ #category : #accessing }
WDCMorphicWindow >> defaultExtent [
	^ 640@480
]

{ #category : #'initialize-release' }
WDCMorphicWindow >> destroyRenderingResources [
]

{ #category : #rendering }
WDCMorphicWindow >> doCommitSurface [
	| pitch slicePitch |
	
	displayForm ifNil: [ ^ self ].
	pitch := displayForm width * 4.
	slicePitch := pitch * displayForm height.
	displayForm unhibernate.
	
	engine device finishExecution.
	resolveRenderTarget currentFramebuffer colorAttachments first validHandle
		readTextureData: 0 arrayIndex: 0 pitch: pitch slicePitch: slicePitch buffer: displayForm bits.
		
	engine hasBottomLeftTextureCoordinates ifTrue: [ 
		displayForm flipHorizontally
	].

]

{ #category : #initialization }
WDCMorphicWindow >> drawOn: aCanvas [
	engine ifNil: [ ^ self ].
	
	displayMutex critical: [
		displayForm ifNotNil: [ 
			aCanvas
				fillRectangle: self innerBounds color: Color black;
				translucentImage: displayForm at: self innerBounds origin.
		].
	]

]

{ #category : #initialization }
WDCMorphicWindow >> drawingSurfaceExtent [
	^ (self innerBounds extent * self uiScaleFactor) ceiling
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

{ #category : #'events-processing' }
WDCMorphicWindow >> enqueueEvent: anEvent [
	eventQueue nextPut: anEvent
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
	
	eventQueue := WaitfreeQueue new.
	displayMutex := Semaphore forMutualExclusion.
	self extent: self defaultExtent.
	self clipSubmorphs: true.
]

{ #category : #initialization }
WDCMorphicWindow >> initializeForNewSession [
	engine checkSession.
	renderTarget := nil.
	resolveRenderTarget := nil.
	lastMousePosition := 0@0.
	textureSceneGraphNode := nil.
	displayTexture := nil.
	displayTextureExtent := 1@1.
	self checkRenderTarget.

	session := Smalltalk session.
	
]

{ #category : #testing }
WDCMorphicWindow >> isUsingAGPUWorldRenderer [
	| world |
	world := self world.
	^ world isNotNil and: [ world worldState worldRenderer isAGPUWorldRenderer ]
]

{ #category : #'framebuffer description' }
WDCMorphicWindow >> needsDirectRenderTarget [
	^ true
]

{ #category : #'rendering process stages' }
WDCMorphicWindow >> prepareRendering [
	displayMutex critical: [
		self checkSession; checkRenderTarget
	]
]

{ #category : #'events-processing' }
WDCMorphicWindow >> processEvents [
	[eventQueue isEmpty ] whileFalse: [ 
		eventQueue nextOrNil ifNotNil: [ :event |
			self processOSWindowEvent: event
		]
	]
]

{ #category : #'events-processing' }
WDCMorphicWindow >> processOSWindowEvent: anEvent [
	handledHere := false.

]

{ #category : #'mouse capture' }
WDCMorphicWindow >> releaseMouse [
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

{ #category : #path }
WDCMorphicWindow >> sessionChanged [
	self checkSession.
]

{ #category : #initialization }
WDCMorphicWindow >> uiScaleFactor [
	^ self worldRendererScaleFactor
]

{ #category : #rendering }
WDCMorphicWindow >> validRenderTarget [
	self checkSession; checkRenderTarget.
	^ renderTarget
]

{ #category : #initialization }
WDCMorphicWindow >> worldRendererScaleFactor [
	^ self world ifNil: [ 1 ]
		ifNotNil: [ :world | world worldState worldRenderer scaleFactor]
]
