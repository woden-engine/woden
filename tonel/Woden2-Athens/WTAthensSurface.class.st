Class {
	#name : #WTAthensSurface,
	#superclass : #AthensSurface,
	#instVars : [
		'engine',
		'colorBuffer',
		'frameBuffer',
		'extent',
		'colorBufferFormat',
		'synchronizationFence',
		'framebufferForm',
		'changedData',
		'depthStencilBuffer',
		'session',
		'vertexBuffer',
		'indexBuffer',
		'vertices',
		'indices',
		'commandAllocator',
		'commandList',
		'commandQueue',
		'renderPass',
		'vertexLayout',
		'shaderSignature',
		'convexColorLinePipeline',
		'convexColorTrianglePipeline',
		'stencilNonZeroPipeline',
		'stencilEvenOddPipeline',
		'coverColorPipeline',
		'textColorPipeline',
		'textSdfColorPipeline',
		'vertexBinding',
		'viewportUniformData',
		'viewportUniformBuffer',
		'viewportUniformBinding',
		'indexBufferCapacity',
		'currentColor',
		'currentShapeType',
		'currentPipelineState',
		'currentTexture',
		'currentFont',
		'deferredDrawCommands',
		'vertexBufferCapacity',
		'startIndex',
		'baseVertex',
		'pathTessellatorBackend',
		'pathTessellator',
		'pathTransform',
		'blendMode',
		'strokePathTessellatorBackend',
		'strokePathTessellator',
		'samplerBindings',
		'colorRampEntryBuffer',
		'colorRampEntryBufferCapacity',
		'colorRampEntries',
		'coverGradientPipeline',
		'currentTexcoord',
		'colorRampDictionary',
		'useOwnFramebuffer',
		'convexTexturedTrianglePipeline',
		'convexTexturedLinePipeline',
		'fenceSignaled'
	],
	#classVars : [
		'BlendVariantNames'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : 'Woden2-Athens'
}

{ #category : #'as yet unclassified' }
WTAthensSurface class >> engine: aWTEngine [
	^ self engine: aWTEngine format: AGPU_TEXTURE_FORMAT_B8G8R8A8_UNORM_SRGB.

]

{ #category : #'as yet unclassified' }
WTAthensSurface class >> engine: aWTEngine extent: anExtent [
	^ self engine: aWTEngine extent: anExtent format: AGPU_TEXTURE_FORMAT_B8G8R8A8_UNORM_SRGB.

]

{ #category : #'as yet unclassified' }
WTAthensSurface class >> engine: aWTEngine extent: anExtent format: aTextureFormat [
	^ self new engine: aWTEngine extent: anExtent format: aTextureFormat

]

{ #category : #'as yet unclassified' }
WTAthensSurface class >> engine: aWTEngine format: aTextureFormat [
	^ self new engine: aWTEngine format: aTextureFormat

]

{ #category : #'as yet unclassified' }
WTAthensSurface class >> initialize [
	"
	self initialize.
	"
	super initialize.
	BlendVariantNames := OrderedCollection newFrom: #(
		('.blend.add' add)
		('.blend.clear' clear)
		('.blend.dest' dest)
		('.blend.dest-over' destOver)
		('.blend.multiply' multiply)
		('.blend.over' over)
		('.blend.source' source)
	).
]

{ #category : #'as yet unclassified' }
WTAthensSurface >> addBoundingBox: boundingBox [
	self
		beginWithNewBaseVertex;
		addVertex: boundingBox bottomLeft;
		addVertex: boundingBox bottomRight;
		addVertex: boundingBox topRight;
		addVertex: boundingBox topLeft;
		addIndex: 0;
		addIndex: 1;
		addIndex: 2;
		addIndex: 2;
		addIndex: 3;
		addIndex: 0.
]

{ #category : #public }
WTAthensSurface >> addIndex: index [
	indices add: index + baseVertex.
]

{ #category : #'as yet unclassified' }
WTAthensSurface >> addPathStencilMask: aPath [
	self
		beginWithNewBaseVertex;
		beginShape: AGPU_TRIANGLES pipeline: stencilNonZeroPipeline. 
	pathTessellator reset.
	aPath sendCommandsTo: pathTessellator.
]

{ #category : #'as yet unclassified' }
WTAthensSurface >> addTransformingBoundingBox: boundingBox [
	self
		beginWithNewBaseVertex;
		addTransformingVertex: boundingBox bottomLeft;
		addTransformingVertex: boundingBox bottomRight;
		addTransformingVertex: boundingBox topRight;
		addTransformingVertex: boundingBox topLeft;
		addIndex: 0;
		addIndex: 1;
		addIndex: 2;
		addIndex: 2;
		addIndex: 3;
		addIndex: 0.
]

{ #category : #'as yet unclassified' }
WTAthensSurface >> addTransformingVertex: position [
	vertices add: (WTCanvasVertex2D new
		position: (pathTransform transformPosition2: position);
		texcoord: currentTexcoord;
		color: currentColor)
]

{ #category : #'as yet unclassified' }
WTAthensSurface >> addTransformingVertex: position texcoord: texcoord [
	vertices add: (WTCanvasVertex2D new
		position: (pathTransform transformPosition2: position);
		texcoord: texcoord;
		color: currentColor)
]

{ #category : #public }
WTAthensSurface >> addVertex: position [
	vertices add: (WTCanvasVertex2D new
		position: position;
		texcoord: currentTexcoord;
		color: currentColor)
]

{ #category : #public }
WTAthensSurface >> addVertex: position color: color [
	vertices add: (WTCanvasVertex2D new
		position: position;
		texcoord: currentTexcoord;
		color: color)
]

{ #category : #initialization }
WTAthensSurface >> asForm [
	framebufferForm ifNil: [
		framebufferForm := Form extent: extent depth: 32.
		changedData := true.
	].

	changedData ifTrue: [ self readColorBufferToForm ].
	changedData := false.
	^ framebufferForm
]

{ #category : #public }
WTAthensSurface >> beginShape: newShapeType pipeline: newPipelineState [
	self beginShape: newShapeType pipeline: newPipelineState texture: nil font: nil
]

{ #category : #public }
WTAthensSurface >> beginShape: newShapeType pipeline: newPipelineState texture: newTexture font: newFont [
	(currentShapeType ~= newShapeType or: [
		currentPipelineState ~= newPipelineState or: [
				currentTexture ~= newTexture or: [
					currentFont ~= newFont ] ] ]) ifTrue: [ 
		self endSubmesh.
	].

	newPipelineState ~= currentPipelineState ifTrue: [ 
		self deferDrawCommand: [ commandList usePipelineState: newPipelineState handle ].
		currentPipelineState := newPipelineState.
	].

	(newTexture ~= currentTexture and: [newTexture isNotNil ]) ifTrue: [
		self deferDrawCommand: [ commandList useShaderResources: newTexture validHandle ].
		currentTexture := newTexture.
	].

	(newFont ~= currentFont and: [newFont isNotNil ]) ifTrue: [
		self deferDrawCommand: [ commandList useShaderResources: newFont validHandle ].
		currentFont := newFont.
	].
 
	currentShapeType := newShapeType.
]

{ #category : #public }
WTAthensSurface >> beginWithNewBaseVertex [
	baseVertex := vertices size.
]

{ #category : #accessing }
WTAthensSurface >> blendMode [
	^ blendMode
]

{ #category : #accessing }
WTAthensSurface >> blendMode: aBlendMode [
	blendMode := aBlendMode
]

{ #category : #'as yet unclassified' }
WTAthensSurface >> cacheAt: anObject ifAbsentPut: aBlock [
	^ engine resourceCache athensCache at: anObject ifAbsentPut: aBlock
]

{ #category : #'session management' }
WTAthensSurface >> checkSession [
	session ~~ Smalltalk session ifTrue: [
		self initializeForNewSession
	]
]

{ #category : #public }
WTAthensSurface >> clear [
	self clear: Color transparent
]

{ #category : #public }
WTAthensSurface >> clear: clearColor [
	| color w h |
	color := clearColor asWMVector4F.
	w := extent x asFloat.
	h := extent y asFloat.
	self
		beginShape: AGPU_TRIANGLES pipeline: (convexColorTrianglePipeline at: #source);
		beginWithNewBaseVertex;
		addVertex: (WMVector2F x: 0.0 y: 0.0) color: color;
		addVertex: (WMVector2F x: w y: 0.0) color: color;
		addVertex: (WMVector2F x: w y: h) color: color;
		addVertex: (WMVector2F x: 0.0 y: h) color: color;
		addIndex: 0;
		addIndex: 1;
		addIndex: 2;
		addIndex: 2;
		addIndex: 3;
		addIndex: 0
]

{ #category : #accessing }
WTAthensSurface >> colorBuffer [
	^ colorBuffer
]

{ #category : #private }
WTAthensSurface >> computeProjectionMatrix [
	| w h |
	extent ifNil: [ ^ self ].
	w := extent x asFloat.
	h := extent y asFloat.
	viewportUniformData projectionMatrix: (
		WMMatrix4F
			reverseDepthOrthoLeft: 0.0 right: w
			bottom: h top: 0.0
			near: -10.0 far: 10.0
			invertedY: engine projectionInvertedY)
]

{ #category : #'as yet unclassified' }
WTAthensSurface >> createColorRampDescription: aColorRamp [
	| description |
	description := WTColorRampDescription new
		firstIndex: colorRampEntries size;
		count: aColorRamp size;
		yourself.
	colorRampEntries addAll: aColorRamp.
	colorRampDictionary at: aColorRamp put: description.
	^ description
		
]

{ #category : #private }
WTAthensSurface >> createColorRampEntryBuffer [
	colorRampEntryBufferCapacity := colorRampEntries capacity max: 16.
	colorRampEntryBuffer := engine createStreamingStorageBuffer: WTColorRampEntry structureSize* colorRampEntryBufferCapacity.
	
	viewportUniformBinding bind: 1 storageBuffer: colorRampEntryBuffer

]

{ #category : #initialization }
WTAthensSurface >> createFrameBuffer [
	| width height device colorBufferDesc colorBufferView depthStencilDesc depthStencilBufferView |
	useOwnFramebuffer ifFalse: [ ^ self ].
	width := extent x.
	height := extent y.
	device := engine device.
	colorBufferDesc := AGPUTextureDescription new
		type: AGPU_TEXTURE_2D;
		width: width;
		height: height;
		depthOrArraySize: 1;
		miplevels: 1;
		format: colorBufferFormat;
		flags: AGPU_TEXTURE_FLAG_RENDER_TARGET | AGPU_TEXTURE_FLAG_READED_BACK;
		sample_count: 1.
	colorBuffer := device createTexture: colorBufferDesc.
	
	colorBufferView := AGPUTextureViewDescription new.
	colorBuffer getFullViewDescription: colorBufferView.
	
	depthStencilDesc := AGPUTextureDescription new
		type: AGPU_TEXTURE_2D;
		width: width;
		height: height;
		depthOrArraySize: 1;
		miplevels: 1;
		format: engine preferredDepthStencilFormat;
		flags: AGPU_TEXTURE_FLAG_DEPTH | AGPU_TEXTURE_FLAG_STENCIL | AGPU_TEXTURE_FLAG_RENDERBUFFER_ONLY;
		sample_count: 1.
	depthStencilBuffer := device createTexture: depthStencilDesc.
	depthStencilBufferView := AGPUTextureViewDescription new.
	depthStencilBuffer getFullViewDescription: depthStencilBufferView.
	
	frameBuffer := device createFrameBuffer: width height: height colorCount: 1 colorViews: colorBufferView depthStencilView: depthStencilBufferView.
	changedData := true.
]

{ #category : #private }
WTAthensSurface >> createIndexBuffer [
	indexBufferCapacity := indices capacity.
	indexBuffer := engine createIndex: indices elementSize streamingElements: indexBufferCapacity.
	
]

{ #category : #'as yet unclassified' }
WTAthensSurface >> createLinearGradient: aColorRamp start: aStartPoint stop: aStopPoint [
	^ WTAthensLinearGradientPaint 
		colorRamp: aColorRamp 
		start: aStartPoint 
		stop: aStopPoint
	
]

{ #category : #paths }
WTAthensSurface >> createPath: aPathCreatingBlock [
	^ WTAthensPath new firstSegment: (WTAthensSimplePathBuilder createPath: aPathCreatingBlock )
]

{ #category : #'as yet unclassified' }
WTAthensSurface >> createRadialGradient: colorRamp center: aCenter radius: aRadius focalPoint: focalPoint [
	^ WTAthensRadialGradientPaint 
		colorRamp: colorRamp 
		center: aCenter 
		focalPoint: focalPoint
		radius: aRadius
	
]

{ #category : #initialization }
WTAthensSurface >> createRenderPass [
	| colorAttachments depthStencilAttachment |
	colorAttachments := {
		AGPURenderpassColorAttachmentDescription new
			format: colorBufferFormat;
			begin_action: AGPU_ATTACHMENT_KEEP;
			end_action: AGPU_ATTACHMENT_KEEP;
			yourself
	}.
	
	depthStencilAttachment := AGPURenderpassDepthStencilDescription new
		format: engine preferredDepthStencilFormat;
		begin_action: AGPU_ATTACHMENT_CLEAR;
		end_action: AGPU_ATTACHMENT_KEEP;
		clear_value: (AGPUDepthStencilValue new depth: 0.0; stencil: 0; yourself);
		yourself.
			
	renderPass := (WTRenderPass for: engine)
		colorAttachments: colorAttachments;
		depthStencilAttachment: depthStencilAttachment;
		validHandle
]

{ #category : #initialization }
WTAthensSurface >> createSamplers [
	| samplerDesc |
	samplerDesc := AGPUSamplerDescription new
		filter: AGPU_FILTER_MIN_LINEAR_MAG_LINEAR_MIPMAP_NEAREST;
		address_u: AGPU_TEXTURE_ADDRESS_MODE_WRAP;
		address_v: AGPU_TEXTURE_ADDRESS_MODE_WRAP;
		address_w: AGPU_TEXTURE_ADDRESS_MODE_WRAP;
		max_lod: 10000.0;
		yourself.
	samplerBindings := engine createShaderSignature: shaderSignature resourceBinding: 3.
	samplerBindings
		createSampler: 0 description: samplerDesc;
		createSampler: 1 description: samplerDesc.
]

{ #category : #paints }
WTAthensSurface >> createSolidColorPaint: aColor [
	^ WTAthensSolidPaint new color: aColor asWMVector4F
]

{ #category : #paints }
WTAthensSurface >> createStrokePaintFor: aPaint [
	^ WTAthensStrokePaint new fillPaint: aPaint
]

{ #category : #private }
WTAthensSurface >> createVertexBuffer [
	| pointerSize vertexBufferHandles |
	vertexBufferCapacity := indices capacity.
	vertexBuffer := engine createVertex: WTCanvasVertex2D structureSize streamingElements: vertexBufferCapacity.
	
	pointerSize := FFIExternalType pointerSize.
	vertexBufferHandles := ExternalAddress allocate: pointerSize.
	[
		vertexBufferHandles pointerAt: 1 put: vertexBuffer validHandle validHandle getHandle.
		vertexBinding bindVertexBuffers: 1 vertex_buffers: vertexBufferHandles.
	] ensure: [ vertexBufferHandles free ]
]

{ #category : #private }
WTAthensSurface >> deferDrawCommand: aBlock [
	deferredDrawCommands add: aBlock
]

{ #category : #private }
WTAthensSurface >> dispatchRenderingCommands [
	| w h |
	self endSubmesh.
	viewportUniformData storeBytesIn: viewportUniformBuffer validPointer getHandle position: 1.
	self updateIndexBuffer.
	self updateVertexBuffer.
	self updateColorRampBuffer.
	
	w := extent x.
	h := extent y.
	
	commandAllocator reset.
	commandList reset: commandAllocator initial_pipeline_state: nil.
	[
		commandList
			setShaderSignature: shaderSignature handle;
			beginRenderPass: renderPass framebuffer: frameBuffer bundle_content: false asBit;	
			setViewport: 0 y: 0 w: w h: h;
			setScissor: 0 y: 0 w: w h: h;
			setStencilReference: 0;
			
			useVertexBinding: vertexBinding;
			useIndexBuffer: indexBuffer validHandle;
			useShaderResources: viewportUniformBinding validHandle;
			useShaderResources: samplerBindings validHandle.
		
		deferredDrawCommands do: #value.
	
		commandList endRenderPass.
	] ensure: [ commandList close ].

	commandQueue addCommandList: commandList.
]

{ #category : #public }
WTAthensSurface >> drawDuring: aBlock [
	self checkSession.
	currentCanvas ifNotNil: [ ^ self attemptToRecurseDrawing ].
	changedData := true.
	self waitFence.
	self resetDrawState.
	[
		currentCanvas := self newCanvas.
		aBlock value: currentCanvas.
	] ensure: [
		self releaseCanvas.
		currentCanvas := nil.
	].

]

{ #category : #public }
WTAthensSurface >> endSubmesh [
	| start count |
	start := startIndex.
	count := indices size - startIndex.
	count = 0 ifTrue: [ ^ self ].

	self deferDrawCommand: [
		commandList drawElements: count instance_count: 1 first_index: start base_vertex: 0 base_instance: 0
	].

	startIndex := indices size.

]

{ #category : #accessing }
WTAthensSurface >> engine [
	^ engine
]

{ #category : #initialization }
WTAthensSurface >> engine: aWTEngine extent: anExtent format: aTextureFormat [
	engine := aWTEngine.
	extent := anExtent asIntegerPoint.
	colorBufferFormat := aTextureFormat.
	useOwnFramebuffer := true.
	self initializeForNewSession.
]

{ #category : #initialization }
WTAthensSurface >> engine: aWTEngine format: aTextureFormat [
	engine := aWTEngine.
	colorBufferFormat := aTextureFormat.
	useOwnFramebuffer := false.
	self initializeForNewSession.
]

{ #category : #accessing }
WTAthensSurface >> extent [
	^ extent
]

{ #category : #'rendering dispatch' }
WTAthensSurface >> fillPath: aPath withLinearGradient: linearGradient [
	| start stop |
	start := pathTransform transform: linearGradient start.
	stop := pathTransform transform: linearGradient stop.
	currentTexcoord := WMVector2F new.
	currentColor := WMVector4F x: start x asFloat y: start y asFloat z: stop x asFloat w: stop y asFloat.
	self
		addPathStencilMask: aPath;
		beginShape: AGPU_TRIANGLES pipeline: (coverGradientPipeline at: blendMode);
		useColorRamp: linearGradient rawColorRamp;
		addBoundingBox: pathTessellatorBackend boundingBox

]

{ #category : #'rendering dispatch' }
WTAthensSurface >> fillPath: aPath withRadialGradient: radialGradient [
	| center focalPoint |
	center := pathTransform transform: radialGradient center.
	focalPoint := pathTransform transform: radialGradient focalPoint.
	currentTexcoord := WMVector2F x: 1.0 y: radialGradient radius asFloat.
	currentColor := WMVector4F x: center x asFloat y: center y asFloat z: focalPoint x asFloat w: focalPoint y asFloat.
	self
		addPathStencilMask: aPath;
		beginShape: AGPU_TRIANGLES pipeline: (coverGradientPipeline at: blendMode);
		useColorRamp: radialGradient rawColorRamp;
		addBoundingBox: pathTessellatorBackend boundingBox

]

{ #category : #'rendering dispatch' }
WTAthensSurface >> fillPath: aPath withSolidColor: aColor [
	aPath isJustText ifTrue: [
		^ self fillTextSegments: aPath firstSegment withSolidColor: aColor.
	].

	currentColor := aColor asWMVector4F.
	self
		addPathStencilMask: aPath;
		beginShape: AGPU_TRIANGLES pipeline: (coverColorPipeline at: blendMode);
		addBoundingBox: pathTessellatorBackend boundingBox

]

{ #category : #'rendering dispatch' }
WTAthensSurface >> fillRectangle: aRectangle withSolidColor: aColor [
	currentColor := aColor asWMVector4F.
	self
		beginShape: AGPU_TRIANGLES pipeline: (convexColorTrianglePipeline at: blendMode);
		addTransformingBoundingBox: aRectangle asWMBox2DF

]

{ #category : #'rendering dispatch' }
WTAthensSurface >> fillRectangle: aRectangle withTexture: aTexture [
	| boundingBox |
	currentColor := Color white asWMVector4F.
	boundingBox := aRectangle asWMBox2DF.
	self
		beginShape: AGPU_TRIANGLES pipeline: (convexTexturedTrianglePipeline at: blendMode) texture: aTexture binding font: nil;
		beginWithNewBaseVertex;
		addTransformingVertex: boundingBox bottomLeft texcoord: (WMVector2F x: 0.0 y: 0.0);
		addTransformingVertex: boundingBox bottomRight texcoord: (WMVector2F x: 1.0 y: 0.0);
		addTransformingVertex: boundingBox topRight texcoord: (WMVector2F x: 1.0 y: 1.0);
		addTransformingVertex: boundingBox topLeft texcoord: (WMVector2F x: 0.0 y: 1.0);
		addIndex: 0;
		addIndex: 1;
		addIndex: 2;
		addIndex: 2;
		addIndex: 3;
		addIndex: 0.
]

{ #category : #'rendering dispatch' }
WTAthensSurface >> fillTextSegments: firstSegment withSolidColor: aColor [
	| currentSegment font string |
	currentSegment := firstSegment.
	[ currentSegment isNotNil ] whileTrue: [
		currentSegment isTextSegment ifTrue: [
			font := currentSegment font asLodenFontFor: engine.
			string := currentSegment string.
			pathTransform restoreAfter: [
				pathTransform translateBy: currentSegment endPoint.
				self renderLodenFont: font color: aColor characters: string from: 1 to: string size
			]
		].
	 
		currentSegment := currentSegment next
	]
]

{ #category : #accessing }
WTAthensSurface >> frameBuffer [
	^ frameBuffer
]

{ #category : #accessing }
WTAthensSurface >> framebuffer: newFramebuffer extent: newExtent [
	frameBuffer := newFramebuffer.
	extent := newExtent.
	self computeProjectionMatrix.
]

{ #category : #'as yet unclassified' }
WTAthensSurface >> getFreetypeFontRendererFor: aFreeTypeFont [
	self flag: 'Implement this properly.'.
	
	^ WTAthensLodentFontGlyphRenderer new
		font: (engine fontCache default default pointSize: aFreeTypeFont pointSize);
		surface: self;
		yourself
]

{ #category : #testing }
WTAthensSurface >> hasBeenFreed [
	^ false
]

{ #category : #accessing }
WTAthensSurface >> indices [
	^ indices
]

{ #category : #initialization }
WTAthensSurface >> initialize [
	super initialize.
	vertices := SLVMNativeOrderedCollection for: WTCanvasVertex2D.
	indices := SLVMNativeOrderedCollection for: #int.
	colorRampEntries := SLVMNativeOrderedCollection for: WTColorRampEntry.
	colorRampDictionary := Dictionary new.
	viewportUniformData := WTCanvasViewportUniformData new
		viewMatrix: WMMatrix4F identity;
		projectionMatrix: WMMatrix4F identity;
		yourself.
	deferredDrawCommands := OrderedCollection new.
	pathTransform := WTAthensTransform new loadIdentity.
	pathTessellatorBackend := WTAthensSurfaceMeshPathBuilderBackend new surface: self.
	pathTessellator := WTAthensSoftwareTessellatedPathBuilder new
		transformation: pathTransform;
		backend: pathTessellatorBackend;
		yourself.
	strokePathTessellatorBackend := WTAthensSurfaceThinLinePathBuilderBackend new surface: self.
	strokePathTessellator := WTAthensSoftwareTessellatedPathBuilder new
		transformation: pathTransform;
		backend: strokePathTessellatorBackend;
		yourself.
	blendMode := #alphaOver.
	
]

{ #category : #initialization }
WTAthensSurface >> initializeForNewSession [
	| device stateManager canvasViewportSize |
	engine checkSession.
	device := engine device.
	stateManager := engine pipelineStateCache.
	vertexLayout := stateManager vertexLayoutNamed: #CanvasVertex2D.
	shaderSignature := stateManager shaderSignatureNamed: #GUI.
	convexColorLinePipeline := self loadStateWithBlendVariants: #'canvas2d.polygon.convex.color.lines'.
	convexColorTrianglePipeline := self loadStateWithBlendVariants: #'canvas2d.polygon.convex.color.triangles'.
	convexTexturedLinePipeline := self loadStateWithBlendVariants: #'canvas2d.polygon.convex.textured.lines'.
	convexTexturedTrianglePipeline := self loadStateWithBlendVariants: #'canvas2d.polygon.convex.textured.triangles'.
	
	stencilNonZeroPipeline := stateManager pipelineStateNamed: #'canvas2d.polygon.stencil.non-zero'.
	stencilEvenOddPipeline := stateManager pipelineStateNamed: #'canvas2d.polygon.stencil.even-odd'.
	coverColorPipeline := self loadStateWithBlendVariants: #'canvas2d.polygon.cover.color'.
	coverGradientPipeline := self loadStateWithBlendVariants: #'canvas2d.polygon.cover.gradient'.
	
	textColorPipeline := stateManager pipelineStateNamed: #'canvas2d.text.color'.
	textSdfColorPipeline := stateManager pipelineStateNamed: #'canvas2d.textsdf.color'.
	
	vertexBinding := device createVertexBinding: vertexLayout handle.
	
	synchronizationFence := nil.
	fenceSignaled := false.
	commandQueue := engine graphicsQueue.
	commandAllocator := device createCommandAllocator: AGPU_COMMAND_LIST_TYPE_DIRECT queue: commandQueue.
	commandList := device createCommandList: AGPU_COMMAND_LIST_TYPE_DIRECT allocator: commandAllocator initial_pipeline_state: nil.
	commandList close.
	
	canvasViewportSize := WTCanvasViewportUniformData structureSize alignedTo: 256.
	viewportUniformBuffer := engine createStreamingUniformBuffer: canvasViewportSize * 3.
	viewportUniformBinding := (engine createShaderSignature: shaderSignature resourceBinding: 0)
			bind: 0 uniformBuffer: viewportUniformBuffer offset: 0 size: canvasViewportSize;
			yourself.
	
	vertexBuffer := nil.
	indexBuffer := nil.
	self createSamplers.
	self createFrameBuffer.
	self createRenderPass.
	self computeProjectionMatrix.
	session := Smalltalk session.

]

{ #category : #initialization }
WTAthensSurface >> loadStateWithBlendVariants: prefix [
	| result fullName |
	result := IdentityDictionary new.
	BlendVariantNames do: [ :variant |
		fullName := (prefix , variant first) asSymbol.
		result at: variant second put: (engine pipelineStateCache pipelineStateNamed: fullName)
	].
	^ result.
	
]

{ #category : #'instance creation' }
WTAthensSurface >> newCanvas [
	"Answer a preinitialized instance of AthensCanvas.
	Private to receiver and its subclasses, override seldom"
	^ WTAthensCanvas on: self

]

{ #category : #accessing }
WTAthensSurface >> pathTransform [
	^ pathTransform
]

{ #category : #private }
WTAthensSurface >> readColorBufferToForm [
	| pitch slicePitch |
	pitch := framebufferForm width * 4.
	slicePitch := pitch * framebufferForm height.
	framebufferForm unhibernate.
	self waitFence.
	colorBuffer readTextureData: 0 arrayIndex: 0 pitch: pitch slicePitch: slicePitch buffer: framebufferForm bits.

]

{ #category : #private }
WTAthensSurface >> releaseCanvas [
	currentCanvas := nil.
	(vertices isNotEmpty and: [indices isNotEmpty]) ifTrue: [
		self dispatchRenderingCommands.
	].
	useOwnFramebuffer ifTrue: [
		self signalFence
	]
]

{ #category : #'rendering dispatch' }
WTAthensSurface >> renderLodenFont: font characters: aString from: start to: end [
	| color |
	color := currentCanvas paint isColor ifTrue: [ currentCanvas paint ] ifFalse: [ Color black ].
	^ self renderLodenFont: font color: color characters: aString from: start to: end
]

{ #category : #'rendering dispatch' }
WTAthensSurface >> renderLodenFont: font color: aColor characters: aString from: start to: end [
	| originalFace pipelineState scaleFactor currentPosition |
	originalFace := font originalFace.
	currentColor := aColor asWMVector4F.
	pipelineState := originalFace sdfFont ifTrue: [ textSdfColorPipeline ] ifFalse: [ textColorPipeline ].
	scaleFactor := font scaleFactor.
	self
		beginShape: AGPU_TRIANGLES pipeline: pipelineState texture: nil font: originalFace texture.
	
	currentPosition := WMVector2F new.
	start to: end do: [ :i |
		currentPosition := self renderLodenFont: originalFace scaleFactor: scaleFactor character: (aString at: i) position: currentPosition
	]
]

{ #category : #'rendering dispatch' }
WTAthensSurface >> renderLodenFont: face scaleFactor: scaleFactor character: character position: position [
	| glyphIndex glyph texcoordScale margin sourceRect destRect |
	glyphIndex := (face characterMap at: character ifAbsent: [ 0 ]) + 1.
	glyph := face glyphs at: glyphIndex.
	texcoordScale := face texcoordScaleFactor.
	margin := (0.0 max: face cellMargin - 1) asFloat.
	sourceRect := glyph computeSourceRectangleWithTexcoordScale: texcoordScale margin: margin.
	destRect := glyph computeDestinationRectangleWithScale: scaleFactor margin: margin position: position.
	
	self
		beginWithNewBaseVertex;
		addTransformingVertex: destRect bottomLeft texcoord: sourceRect bottomLeft;
		addTransformingVertex: destRect bottomRight texcoord: sourceRect bottomRight;
		addTransformingVertex: destRect topRight texcoord: sourceRect topRight;
		addTransformingVertex: destRect topLeft texcoord: sourceRect topLeft;
		addIndex: 0;
		addIndex: 1;
		addIndex: 2;
		addIndex: 2;
		addIndex: 3;
		addIndex: 0.

	^ position + (WMVector2F x: glyph advance x * scaleFactor)
]

{ #category : #private }
WTAthensSurface >> resetDrawState [
	deferredDrawCommands removeAll.
	pathTransform loadIdentity.
	vertices removeAll.
	indices removeAll.
	colorRampEntries removeAll.
	colorRampDictionary removeAll.
	startIndex := 0.
	baseVertex := 0.
	
	currentShapeType := nil.
	currentPipelineState := nil.
	currentTexture := nil.
	currentFont := nil.
	currentTexcoord := WMVector2F new.
	
]

{ #category : #private }
WTAthensSurface >> signalFence [
	synchronizationFence ifNil: [ synchronizationFence := engine device createFence ].
	commandQueue signalFence: synchronizationFence.
	fenceSignaled := true.
]

{ #category : #'rendering dispatch' }
WTAthensSurface >> strokePath: aPath withStrokePaint: aStrokePaint [
	| pixelScaleFactors lineWidth pixelScaleFactor |
	pixelScaleFactors := pathTransform matrix topLeft2x2 eigenValues collect: #abs.
	pixelScaleFactor := pixelScaleFactors first max: pixelScaleFactors second.
	lineWidth := aStrokePaint width * pixelScaleFactor.
	lineWidth < 0.6 ifTrue: [ ^ self ].
	lineWidth < 1.5 ifTrue: [
		self strokeThinPath: aPath withStrokePaint: aStrokePaint
	] ifFalse: [
		"Transcript show: 'Stroke non thin-path: ', lineWidth printString; cr."
		self strokeThinPath: aPath withStrokePaint: aStrokePaint
	]
	
]

{ #category : #'rendering dispatch' }
WTAthensSurface >> strokeThinPath: aPath withStrokePaint: aStrokePaint. [
	currentColor := aStrokePaint fillPaint asColor asWMVector4F.
	self
		beginShape: AGPU_LINES pipeline: (convexColorLinePipeline at: blendMode);
		beginWithNewBaseVertex.
	strokePathTessellator reset.
	aPath sendCommandsTo: strokePathTessellator

]

{ #category : #private }
WTAthensSurface >> updateColorRampBuffer [
	(colorRampEntryBuffer isNil or: [colorRampEntryBufferCapacity < colorRampEntries capacity]) ifTrue: [ self createColorRampEntryBuffer. ].
	LibC memCopy: colorRampEntries rawData to: colorRampEntryBuffer validPointer size: colorRampEntries rawDataSize
]

{ #category : #private }
WTAthensSurface >> updateIndexBuffer [
	(indexBuffer isNil or: [indexBufferCapacity < indices capacity]) ifTrue: [ self createIndexBuffer. ].
	LibC memCopy: indices rawData to: indexBuffer validPointer size: indices rawDataSize
]

{ #category : #private }
WTAthensSurface >> updateVertexBuffer [
	(vertexBuffer isNil or: [vertexBufferCapacity < vertices capacity]) ifTrue: [ self createVertexBuffer. ].
	LibC memCopy: vertices rawData to: vertexBuffer validPointer size: vertices rawDataSize
]

{ #category : #public }
WTAthensSurface >> useColorRamp: aColorRamp [
	| colorRampDescription |
	colorRampDescription := colorRampDictionary at: aColorRamp ifAbsentPut: [ self createColorRampDescription: aColorRamp ].
	self deferDrawCommand: [ commandList pushConstants: 0 size: WTColorRampDescription structureSize values: colorRampDescription asByteArray ].
]

{ #category : #accessing }
WTAthensSurface >> vertices [
	^ vertices
]

{ #category : #private }
WTAthensSurface >> waitFence [
	(synchronizationFence isNotNil and: [ fenceSignaled ]) ifTrue: [
		synchronizationFence waitOnClient
	].
	fenceSignaled := false
]
