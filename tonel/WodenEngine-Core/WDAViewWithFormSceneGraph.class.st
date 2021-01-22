Class {
	#name : #WDAViewWithFormSceneGraph,
	#superclass : #WDAView,
	#instVars : [
		'drawCommandProcessor',
		'renderTarget',
		'resolveTarget',
		'sceneGraph',
		'perFrameCommandLists',
		'currentCommandList',
		'sceneGraphCommandList',
		'sceneGraphRenderTarget'
	],
	#category : #'WodenEngine-Core-Application'
}

{ #category : #'rendering process stages' }
WDAViewWithFormSceneGraph >> buildUISceneGraphWith: builder [
	^ builder null
]

{ #category : #'rendering process stages' }
WDAViewWithFormSceneGraph >> constructRenderingCommandLists [
	| currentCommandLists |
	super constructRenderingCommandLists.
	perFrameCommandLists ifNil: [ perFrameCommandLists := WDCPerFrameSimpleCommandList for: engine ].
	currentCommandLists := perFrameCommandLists currentList.

	currentCommandLists validCommandAllocator reset.
	
	currentCommandList := currentCommandLists validCommandList.
	currentCommandList withPipelineState: nil rebuild: [ :builder |
		self validDrawCommandProcessor
			commandList: builder;
			processCommandListWithDependencies: sceneGraphCommandList mainRenderTarget: sceneGraphRenderTarget.
		
		renderTarget ~~ resolveTarget ifTrue: [ 
			builder resolveFramebuffer: resolveTarget currentFramebuffer validHandle
				sourceFramebuffer: renderTarget currentFramebuffer validHandle
		]
	].
]

{ #category : #'instance creation' }
WDAViewWithFormSceneGraph >> newSceneGraphBuilder [
	^ (FormSGAGPUBuilder extent: self drawingSurfaceExtent)
		device: engine device;
		drawCommandProcessor: self validDrawCommandProcessor;
		yourself
]

{ #category : #'rendering process stages' }
WDAViewWithFormSceneGraph >> prepareRendering [
	renderTarget := window validRenderTarget.
	resolveTarget := window validResolveRenderTarget.
	sceneGraph := self buildUISceneGraphWith: self newSceneGraphBuilder.

	sceneGraphCommandList := FormSGAGPUCommandListBuilder new.
	FormSGAGPUCommandListRenderer new
		surfaceScaleFactor: self validScaleFactor;
		fontTextureAtlasCache: self validDrawCommandProcessor fontTextureAtlasCache;
		hasDirectSubpixelBlending: true;
		render: sceneGraph with: sceneGraphCommandList transform: FormSGAffineTransform identity clippingBounds: (0@0 extent: self drawingSurfaceExtent).
	
	self validateSceneGraphRenderTarget	
]

{ #category : #'framebuffer description' }
WDAViewWithFormSceneGraph >> sampleCount [
	^ 1
]

{ #category : #'rendering process stages' }
WDAViewWithFormSceneGraph >> sendRenderingCommands [
	super sendRenderingCommands.
	currentCommandList ifNil: [ ^ self ].
	engine graphicsQueue
		addCommandList: currentCommandList validHandle.
]

{ #category : #'instance creation' }
WDAViewWithFormSceneGraph >> validDrawCommandProcessor [
	(drawCommandProcessor isNotNil and: [
	drawCommandProcessor context == engine formSceneGraphDrawCommandProcessorContext ]) ifTrue: [
		^ drawCommandProcessor
	].

	^ drawCommandProcessor := FormSGExternallySynchronizedAGPUDrawCommandProcessor forContext: engine formSceneGraphDrawCommandProcessorContext withFrameBufferingCount: engine frameBufferingCount.
]

{ #category : #accessing }
WDAViewWithFormSceneGraph >> validScaleFactor [
	^ 1.0
]

{ #category : #'rendering process stages' }
WDAViewWithFormSceneGraph >> validateSceneGraphRenderTarget [
	| renderFramebuffer colorBuffer colorBufferView |
	renderFramebuffer := renderTarget currentFramebuffer.

	(sceneGraphRenderTarget isNotNil and: [
	sceneGraphRenderTarget extent = self drawingSurfaceExtent and: [
	sceneGraphRenderTarget framebuffer = renderFramebuffer validHandle ]]) ifTrue: [ ^ self ].

	colorBuffer := nil.
	colorBufferView := nil.
	renderFramebuffer colorAttachments ifNotEmpty: [
		colorBuffer := renderFramebuffer colorAttachments first validHandle.
		colorBufferView := renderFramebuffer colorAttachmentViews first asValidTextureViewHandle.
	].

	sceneGraphRenderTarget := self validDrawCommandProcessor
		createRenderTargetWithExtent: self drawingSurfaceExtent
		colorBuffer: colorBuffer
		colorBufferView: colorBufferView
		framebuffer: renderFramebuffer validHandle
	
]
