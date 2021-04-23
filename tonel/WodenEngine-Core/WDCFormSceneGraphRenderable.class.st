Class {
	#name : #WDCFormSceneGraphRenderable,
	#superclass : #WDCMutableRenderable,
	#instVars : [
		'drawingSurfaceExtent',
		'engine',
		'scaleFactor',
		'logicalHeight',
		'mesh',
		'material',
		'sceneGraph',
		'hasValidSurfaceContent',
		'drawingSurface',
		'drawCommandProcessor',
		'formSceneGraphRenderTarget'
	],
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #'as yet unclassified' }
WDCFormSceneGraphRenderable class >> defaultDrawingSurfaceExtent [
	^ 256@256
]

{ #category : #'instance creation' }
WDCFormSceneGraphRenderable class >> for: anEngine [
	^ self new engine: anEngine
]

{ #category : #'as yet unclassified' }
WDCFormSceneGraphRenderable class >> logicalHeight [
	^ 480
]

{ #category : #'as yet unclassified' }
WDCFormSceneGraphRenderable >> buildSceneGraphWith: aBlock [
	self sceneGraph: (aBlock cull: self newSceneGraphBuilder cull: self)
]

{ #category : #accessing }
WDCFormSceneGraphRenderable >> changed [
	hasValidSurfaceContent := false.
]

{ #category : #accessing }
WDCFormSceneGraphRenderable >> drawingSurfaceExtent [

	^ drawingSurfaceExtent
]

{ #category : #accessing }
WDCFormSceneGraphRenderable >> drawingSurfaceExtent: newExtent [
	hasValidSurfaceContent := hasValidSurfaceContent and: [drawingSurfaceExtent = newExtent].
	drawingSurfaceExtent := newExtent
]

{ #category : #accessing }
WDCFormSceneGraphRenderable >> engine [
	^ engine
]

{ #category : #accessing }
WDCFormSceneGraphRenderable >> engine: anObject [

	engine := anObject
]

{ #category : #accessing }
WDCFormSceneGraphRenderable >> initialize [
	super initialize.
	hasValidSurfaceContent := false.
	drawingSurfaceExtent := self class defaultDrawingSurfaceExtent.
]

{ #category : #accessing }
WDCFormSceneGraphRenderable >> material [
	material ifNil: [ 
		material := (WDCUnlitMaterial for: engine)
			useDepth: false;
			writeDepth: false;
			hasPremultipliedAlpha: true;
			yourself
	].
	^ material
]

{ #category : #accessing }
WDCFormSceneGraphRenderable >> mesh [
	mesh ifNil: [ mesh := engine resourceCache billboardQuadMesh copyWithMaterial: self material
	].
	^ mesh
]

{ #category : #'as yet unclassified' }
WDCFormSceneGraphRenderable >> newSceneGraphBuilder [
	^ (FormSGAGPUBuilder extent: self drawingSurfaceExtent)
		device: engine device;
		drawCommandProcessor: self validDrawCommandProcessor;
		yourself
]

{ #category : #'as yet unclassified' }
WDCFormSceneGraphRenderable >> renderDrawingSurfaceContentWithStateTracker: stateTracker [
	| sgCommandList |
	sgCommandList := FormSGAGPUCommandListBuilder new.
	
	FormSGAGPUCommandListRenderer new
		surfaceScaleFactor: self validScaleFactor;
		fontTextureAtlasCache: self validDrawCommandProcessor fontTextureAtlasCache;
		hasDirectSubpixelBlending: self validDrawCommandProcessor hasDirectSubpixelBlending;
		render: sceneGraph with: sgCommandList transform: FormSGAffineTransform identity clippingBounds: (0@0 extent: self drawingSurfaceExtent).

	self validDrawCommandProcessor
		commandList: stateTracker commandList validHandle;
		processCommandListWithDependencies: sgCommandList mainRenderTarget: self validFormSceneGraphRenderTarget
]

{ #category : #rendering }
WDCFormSceneGraphRenderable >> renderOn: stateTracker instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex [ 
	^ self mesh renderOn: stateTracker instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex 
]

{ #category : #accessing }
WDCFormSceneGraphRenderable >> scaleFactor [
	^ scaleFactor
]

{ #category : #accessing }
WDCFormSceneGraphRenderable >> scaleFactor: newScaleFactor [
	hasValidSurfaceContent := hasValidSurfaceContent and: [scaleFactor = newScaleFactor].
	scaleFactor := newScaleFactor
]

{ #category : #accessing }
WDCFormSceneGraphRenderable >> sceneGraph [

	^ sceneGraph
]

{ #category : #accessing }
WDCFormSceneGraphRenderable >> sceneGraph: anObject [
	sceneGraph := anObject.
	hasValidSurfaceContent := false.
]

{ #category : #'as yet unclassified' }
WDCFormSceneGraphRenderable >> validDrawCommandProcessor [
	(drawCommandProcessor isNotNil and: [
	drawCommandProcessor context == engine formSceneGraphDrawCommandProcessorContext ]) ifTrue: [
		^ drawCommandProcessor
	].

	formSceneGraphRenderTarget := nil.
	^ drawCommandProcessor := FormSGExternallySynchronizedAGPUDrawCommandProcessor forContext: engine formSceneGraphDrawCommandProcessorContext withFrameBufferingCount: engine frameBufferingCount.
]

{ #category : #'as yet unclassified' }
WDCFormSceneGraphRenderable >> validFormSceneGraphRenderTarget [
	^ formSceneGraphRenderTarget ifNil: [
		| surfaceFramebuffer colorBuffer colorBufferView |
		surfaceFramebuffer := drawingSurface framebuffers first.
		colorBuffer := nil.
		colorBufferView := nil.
		surfaceFramebuffer colorAttachments ifNotEmpty: [
			colorBuffer := surfaceFramebuffer colorAttachments first validHandle.
			colorBufferView := surfaceFramebuffer colorAttachmentViews first asValidTextureViewHandle.
		].
	
		formSceneGraphRenderTarget := self validDrawCommandProcessor
			createRenderTargetWithExtent: self drawingSurfaceExtent
			colorBuffer: colorBuffer
			colorBufferView: colorBufferView
			framebuffer: surfaceFramebuffer validHandle
	]
]

{ #category : #accessing }
WDCFormSceneGraphRenderable >> validLogicalHeight [
	^ logicalHeight ifNil: [ self class logicalHeight ]
]

{ #category : #accessing }
WDCFormSceneGraphRenderable >> validScaleFactor [
	^ scaleFactor ifNil: [ (drawingSurfaceExtent y / self validLogicalHeight roundTo: 0.05) max: 0.25 ]
]

{ #category : #'as yet unclassified' }
WDCFormSceneGraphRenderable >> validateDrawingSurfaceExtent [
	(drawingSurface isNotNil and: [ drawingSurface extent = drawingSurfaceExtent ]) ifTrue: [ ^ self ].
	drawingSurface := (WDCRenderTarget for: engine extent: drawingSurfaceExtent)
		colorAttachmentFormats: {engine formSceneGraphDrawCommandProcessorContext colorBufferFormat};
		hasDepth: false;
		hasStencil: false;
		sampleCount: 1;
		createFramebuffers.
	self material colorTexture: drawingSurface framebuffers first colorAttachments first.
	formSceneGraphRenderTarget := nil.
]

{ #category : #'as yet unclassified' }
WDCFormSceneGraphRenderable >> validateSurfaceContentWithStateTracker: stateTracker [
	hasValidSurfaceContent ifTrue: [ ^ self ].
	self
		validateDrawingSurfaceExtent;
		renderDrawingSurfaceContentWithStateTracker: stateTracker.
	hasValidSurfaceContent := false.
]
