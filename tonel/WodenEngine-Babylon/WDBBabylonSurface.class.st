Class {
	#name : #WDBBabylonSurface,
	#superclass : #BabylonSurface,
	#instVars : [
		'driver',
		'extent',
		'isInRenderPass',
		'commandAllocator',
		'commandList',
		'fence',
		'renderTarget',
		'sampleCount',
		'gpuOnly',
		'cpuForm',
		'resolveRenderTarget',
		'solidRenderPass',
		'stateTracker',
		'shaderSignature',
		'currentTransform',
		'transform',
		'meshesInMemory',
		'meshesToSend',
		'drawingCommands',
		'meshMemoryMap',
		'vertexBufferCapacity',
		'vertexBuffer',
		'indexBufferCapacity',
		'indexBuffer',
		'activeMaterial',
		'vertexBinding',
		'matrices',
		'matrixBuffer',
		'matrixBufferCapacity',
		'matrixBufferBinding',
		'hasValidQuickState',
		'quickState',
		'quickStateBuffer',
		'currentWindow',
		'hasSubmittedFence',
		'destroyed',
		'clipRectangleStack',
		'currentClipRectangle'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Babylon'
}

{ #category : #construction }
WDBBabylonSurface class >> defaultSampleCount [
	^ 4
]

{ #category : #construction }
WDBBabylonSurface class >> extent: anExtent driver: aDriver [
	^ self extent: anExtent driver: aDriver sampleCount: self defaultSampleCount
	
]

{ #category : #construction }
WDBBabylonSurface class >> extent: anExtent driver: aDriver sampleCount: aSampleCount [
	^ self basicNew initializeWithExtent: anExtent driver: aDriver sampleCount: aSampleCount
	
]

{ #category : #'material activation' }
WDBBabylonSurface >> activateFontMaterial: fontMaterial [
	fontMaterial validTexture.
	stateTracker
		vertexShader: driver vertexShader;
		fragmentShader: driver colorFontShader;
		useShaderResources: fontMaterial validShaderBinding
]

{ #category : #commands }
WDBBabylonSurface >> activateMaterial: aMaterial [
	activeMaterial == aMaterial ifTrue: [ ^ self ].
	
	aMaterial ifNil: [
		self activateNullMaterial
	] ifNotNil: [
		aMaterial activateMaterialIn: self
	].
	activeMaterial := aMaterial.
	
]

{ #category : #drawing }
WDBBabylonSurface >> activateNullMaterial [
	stateTracker
		vertexShader: driver vertexShader;
		fragmentShader: driver colorShader.
	activeMaterial := nil.
]

{ #category : #'material activation' }
WDBBabylonSurface >> activateTextureArrayElementMaterial: textureArrayMaterial [
	textureArrayMaterial validTexture.
	stateTracker
		vertexShader: driver vertexShader;
		fragmentShader: (textureArrayMaterial grayscaleTexture
			ifFalse: [driver textureArrayColorShader]
			ifTrue: [driver grayTextureArrayColorShader]);
		useShaderResources: textureArrayMaterial validShaderBinding;
		pushConstants: 16 size: 4 values: ((ByteArray new: 4)
			unsignedLongAt: 1 put: textureArrayMaterial elementIndex;
			yourself)
]

{ #category : #'material activation' }
WDBBabylonSurface >> activateTextureMaterial: textureMaterial [
	textureMaterial validTexture.
	stateTracker
		vertexShader: driver vertexShader;
		fragmentShader: (textureMaterial grayscaleTexture
			ifFalse: [driver textureColorShader]
			ifTrue: [driver grayTextureColorShader]);
		useShaderResources: textureMaterial validShaderBinding
]

{ #category : #adding }
WDBBabylonSurface >> addCommand: aCommand [
	drawingCommands add: aCommand
]

{ #category : #adding }
WDBBabylonSurface >> addDrawingCommandMesh: mesh submesh: submesh [
	self
		flushTransforms;
		flushClippingRectangles.
	meshesToSend add: mesh.
	drawingCommands add: (WDBBabylonDrawCommand new
		mesh: mesh;
		submesh: submesh;
		yourself)
]

{ #category : #drawing }
WDBBabylonSurface >> allocateCommandList [
	commandAllocator ifNil: [
		commandAllocator := driver engine createGraphicsDirectCommandListAllocator.
		commandList := commandAllocator createListNow 
	] ifNotNil: [ 
		commandAllocator reset.
	].

]

{ #category : #drawing }
WDBBabylonSurface >> allocateDrawingResources [
	self createFenceIfNeeded.
	self allocateRenderTarget.
	isInRenderPass := false.

]

{ #category : #drawing }
WDBBabylonSurface >> allocateRenderTarget [
	(renderTarget isNotNil and: [renderTarget extent = extent]) ifTrue: [ ^ self ].
	
	renderTarget := WDCRenderTarget for: driver engine extent: extent.
	renderTarget
		hasDepth: false;
		hasStencil: false;
		explicitSynchronization: true;
		sampleCount: sampleCount.
	
	self sampleCount > 1 ifTrue: [ 
		renderTarget createFramebuffers.
		
		resolveRenderTarget := WDCRenderTarget for: driver engine extent: extent.
		resolveRenderTarget
			hasDepth: false;
			hasStencil: false;
			sampleCount: 1;
			explicitSynchronization: true;
			gpuOnly: gpuOnly;
			createFramebuffers.

	] ifFalse: [ 
		renderTarget
			explicitSynchronization: true;
			gpuOnly: gpuOnly; createFramebuffers.
		resolveRenderTarget := renderTarget
	]
]

{ #category : #converting }
WDBBabylonSurface >> asForm [
	| pitch slicePitch |
	gpuOnly ifTrue: [ self error: 'Cannot get a cpuForm from a GPU only surface.' ].
	fence ifNil: [ self error: 'Cannot get a cpuForm from a surface that has not been drawn.' ].
	
	(fence isNotNil and: [hasSubmittedFence]) ifTrue: [
		fence waitOnClient.
		hasSubmittedFence := false.
	].
	
	cpuForm ifNil: [
		cpuForm := Form extent: extent depth: 32.
	].

	pitch := cpuForm width * 4.
	slicePitch := pitch * cpuForm height.

	cpuForm unhibernate.
	resolveRenderTarget currentFramebuffer colorAttachments first validHandle
		readTextureData: 0 arrayIndex: 0 pitch: pitch slicePitch: slicePitch buffer: cpuForm bits.

	driver engine hasBottomLeftTextureCoordinates ifTrue: [ 
		cpuForm flipHorizontally
	].

	^ cpuForm
]

{ #category : #drawing }
WDBBabylonSurface >> beginRenderPassWithColor: aColor [
	| pass |
	renderTarget ifNil: [ ^ self ].
	isInRenderPass ifTrue: [ self finishCurrentRenderPass ].
	
	pass := self solidRenderPass.
	pass setColorClearValue: 0 value: aColor asWMVector4F asAGPUColor4f.
	
	stateTracker
		beginRenderPass: pass renderTarget: renderTarget.
	isInRenderPass := true
]

{ #category : #resources }
WDBBabylonSurface >> createFenceIfNeeded [
	fence ifNil: [
		fence := driver engine device createFence.
		hasSubmittedFence := false.
	] ifNotNil: [
		hasSubmittedFence ifTrue: [ 
			fence waitOnClient.
			hasSubmittedFence := false.
		].
	].
]

{ #category : #clipping }
WDBBabylonSurface >> currentClipRectangle [
	^ clipRectangleStack
		ifEmpty: [ 0@0 extent: extent ]
		ifNotEmpty: [ clipRectangleStack top ]
]

{ #category : #initialize }
WDBBabylonSurface >> destroy [
	driver critical: [ 
		destroyed := true.
		self forcedSynchronization.
	].

]

{ #category : #drawing }
WDBBabylonSurface >> doDrawBlock: aBlock [
	| canvas |
	self
		setupStateTracker;
		setupCommonState.
	canvas := WDBBabylonCanvas new
		surface: self;
		yourself.
	aBlock value: canvas.
	self recordDrawingCommands
]

{ #category : #drawing }
WDBBabylonSurface >> doDrawDuring: aBlock [
	self
		allocateDrawingResources;
		allocateCommandList.

	self stateTracker commandList: commandList rebuildWith: [
		stateTracker reset.
		self
			doDrawBlock: aBlock.
		renderTarget ~~ resolveRenderTarget ifTrue: [
			stateTracker
				resolveRenderTarget: renderTarget into: resolveRenderTarget
		]
	].

]

{ #category : #drawing }
WDBBabylonSurface >> drawDuring: aBlock [
	destroyed ifTrue: [ ^ self ].
	driver critical: [
		self
			doDrawDuring: aBlock;
			submitDrawingCommands
		
	]
]

{ #category : #drawing }
WDBBabylonSurface >> drawToOSWindow: anOSWindow during: aBlock [
	destroyed ifTrue: [ ^ self ].
	driver critical: [
		self
			setupRenderTargetsForOSWindow: anOSWindow;
			doDrawDuring: aBlock;
			submitDrawingCommands.
		resolveRenderTarget swapBuffers
	]
]

{ #category : #drawing }
WDBBabylonSurface >> drawToWodenWindow: aWodenWindow during: aBlock [
	destroyed ifTrue: [ ^ self ].
	driver critical: [
		self
			setupRenderTargetsForWodenWindow: aWodenWindow;
			doDrawDuring: aBlock.
	].

	^ commandList
]

{ #category : #accessing }
WDBBabylonSurface >> driver [
	^ driver
]

{ #category : #drawing }
WDBBabylonSurface >> ensureIndexBufferCapacity: requiredSize [
	| newCapacity |
	(indexBuffer isNotNil and: [ requiredSize <= indexBufferCapacity ]) ifTrue: [ ^ self ].

	"Destroy the old index buffer"
	indexBuffer ifNotNil: [
		self forcedSynchronization.
		indexBuffer destroy.
		indexBuffer := nil.
	].
	
	"Compute the new capacity"
	newCapacity := 1 << requiredSize highBit max: 256.
	self assert: newCapacity >= requiredSize.	
	indexBufferCapacity := indexBufferCapacity max: newCapacity.
	indexBuffer := driver engine createIndex: 4 streamingElements: indexBufferCapacity.
]

{ #category : #drawing }
WDBBabylonSurface >> ensureMatrixBufferCapacity: requiredSize [
	| newCapacity engine |
	(matrixBuffer isNotNil and: [ requiredSize <= matrixBufferCapacity ]) ifTrue: [ ^ self ].
	engine := driver engine.

	"Destroy the old matrix buffer"
	matrixBuffer ifNotNil: [
		self forcedSynchronization.
		matrixBuffer destroy.
		matrixBuffer := nil.
	].
	
	"Compute the new capacity"
	newCapacity := 1 << requiredSize highBit max: 256.
	self assert: newCapacity >= requiredSize.	
	matrixBufferCapacity := matrixBufferCapacity max: newCapacity.
	matrixBuffer := engine createStreamingStorageBuffer: matrixBufferCapacity * WMMatrix4F structureSize.
	
	"Bind the new buffer"
	matrixBufferBinding ifNil: [ matrixBufferBinding := self shaderSignature newCanvasViewport ].
	matrixBufferBinding bind: 0 storageBuffer: matrixBuffer.

]

{ #category : #drawing }
WDBBabylonSurface >> ensureVertexBufferCapacity: requiredSize [
	| newCapacity engine |
	(vertexBuffer isNotNil and: [ requiredSize <= vertexBufferCapacity ]) ifTrue: [ ^ self ].
	engine := driver engine.

	"Destroy the old vertex buffer"
	vertexBuffer ifNotNil: [
		self forcedSynchronization.
		vertexBuffer destroy.
		vertexBuffer := nil.
	].
	
	"Compute the new capacity"
	newCapacity := 1 << requiredSize highBit max: 256.
	self assert: newCapacity >= requiredSize.	
	vertexBufferCapacity := vertexBufferCapacity max: newCapacity.
	vertexBuffer := engine createVertex: WDPCanvasVertex2D structureSize streamingElements: vertexBufferCapacity.
	
	"Create the vertex binding"
	vertexBinding ifNil: [vertexBinding := engine createVertexBindingForLayout: (engine vertexLayoutFor: WDPCanvasVertex2D)].
	vertexBinding vertexBuffers: { vertexBuffer }; offsets: { 0 }
]

{ #category : #accessing }
WDBBabylonSurface >> extent [
	^ extent
]

{ #category : #accessing }
WDBBabylonSurface >> extent: aNewExtent [
	driver critical: [ 
		extent := aNewExtent.
		cpuForm := nil.
	]

]

{ #category : #drawing }
WDBBabylonSurface >> finishCurrentRenderPass [
	renderTarget ifNil: [ ^ self ].
	isInRenderPass ifFalse: [ ^ self ].
	
	stateTracker endRenderPass.
	isInRenderPass := false.
]

{ #category : #'as yet unclassified' }
WDBBabylonSurface >> flushClippingRectangles [
	| clipRectangleToUse |
	clipRectangleToUse := self currentClipRectangle.
	currentClipRectangle ~= clipRectangleToUse ifTrue: [
		self addCommand: (WDBBabylonSetClipRectangleCommand new
			rectangle: clipRectangleToUse).
		currentClipRectangle := clipRectangleToUse.
	]
]

{ #category : #'as yet unclassified' }
WDBBabylonSurface >> flushTransforms [
	currentTransform ~= transform ifTrue: [
		self addCommand: (WDBBabylonSetModelViewMatrixCommand new
			matrix: (self pushMatrix: transform asWMMatrix4F)).
		currentTransform := transform copy.
	]
]

{ #category : #'as yet unclassified' }
WDBBabylonSurface >> forcedSynchronization [
	fence ifNil: [
		driver engine device finishExecution
	] ifNotNil: [
		self waitFence
	]
]

{ #category : #formatting }
WDBBabylonSurface >> format [
	^ self class defaultSurfaceFormat
]

{ #category : #'as yet unclassified' }
WDBBabylonSurface >> getMeshBaseIndex: mesh [
	^ (meshMemoryMap at: mesh) baseIndex
]

{ #category : #'as yet unclassified' }
WDBBabylonSurface >> getMeshBaseVertex: mesh [
	^ (meshMemoryMap at: mesh) baseVertex
]

{ #category : #accessing }
WDBBabylonSurface >> gpuOnly [
	^ gpuOnly
]

{ #category : #accessing }
WDBBabylonSurface >> gpuOnly: anObject [
	gpuOnly := anObject
]

{ #category : #initialization }
WDBBabylonSurface >> initialize [
	super initialize.
	gpuOnly := false.
	transform := BabylonGenericTransform new.
	currentTransform := nil.
	currentClipRectangle := nil.
	
	meshesInMemory := IdentitySet new.
	meshesToSend := IdentitySet new.
	drawingCommands := OrderedCollection new.
	meshMemoryMap := IdentityDictionary new.
	clipRectangleStack := Stack new.
	
	vertexBufferCapacity := 0.
	vertexBuffer := nil.
	indexBufferCapacity := 0.
	indexBuffer := nil.
	matrixBufferCapacity := 0.
	matrixBuffer := nil.
	
	matrices := SLVMNativeOrderedCollection for: WMMatrix4F.
	quickStateBuffer := ByteArray new: WDPQuickState structureSize.
	
	destroyed := false.
]

{ #category : #initialization }
WDBBabylonSurface >> initializeWithExtent: anExtent driver: aDriver sampleCount: aSampleCount [
	extent := anExtent.
	sampleCount := aSampleCount.
	driver := aDriver.
	self initialize
	
]

{ #category : #drawing }
WDBBabylonSurface >> isInRenderPass [
	^ isInRenderPass
]

{ #category : #drawing }
WDBBabylonSurface >> modelViewMatrixIndex: aMatrixIndex [
	quickState modelViewMatrixIndex: aMatrixIndex.
	hasValidQuickState := false.
]

{ #category : #clipping }
WDBBabylonSurface >> popClipRectangle [
	clipRectangleStack pop
]

{ #category : #accessing }
WDBBabylonSurface >> projectionMatrix [
	^ WMMatrix4F
		orthoLeft: 0.0 right: extent x asFloat
		bottom: extent y asFloat top: 0.0
		near: -1.0 far: 1.0
		invertedY: (driver engine projectionInvertedY)
]

{ #category : #drawing }
WDBBabylonSurface >> projectionMatrixIndex: aMatrixIndex [
	quickState projectionMatrixIndex: aMatrixIndex.
	hasValidQuickState := false.
]

{ #category : #clipping }
WDBBabylonSurface >> pushClipRectangle: aRectangle [
	| newClipRectangle |
	newClipRectangle := self currentClipRectangle intersect: (self transformClipRectangle: aRectangle).
	clipRectangleStack push: newClipRectangle
]

{ #category : #initialization }
WDBBabylonSurface >> pushMatrix: aMatrix [
	matrices add: aMatrix.
	^ matrices size - 1
]

{ #category : #drawing }
WDBBabylonSurface >> recordDrawingCommands [
	meshesToSend ~= meshesInMemory ifTrue: [
		self sendMeshesToMemory
	].
	self sendMatricesToMemory.

	self activateNullMaterial.
	stateTracker useShaderResources: matrixBufferBinding.
	
	vertexBinding ifNotNil: [ 
		stateTracker useVertexBinding: vertexBinding
	].
	indexBuffer ifNotNil: [ 
		stateTracker useIndexBuffer: indexBuffer
	].

	drawingCommands do: [ :command |
		command executeWith: stateTracker on: self
	].

	isInRenderPass ifTrue: [ self finishCurrentRenderPass ].
]

{ #category : #accessing }
WDBBabylonSurface >> sampleCount [
	^ sampleCount
]

{ #category : #accessing }
WDBBabylonSurface >> sampleCount: anObject [
	sampleCount := anObject
]

{ #category : #drawing }
WDBBabylonSurface >> sendMatricesToMemory [
	self ensureMatrixBufferCapacity: matrices size.
	LibC memCopy: matrices rawData to: matrixBuffer validPointer size: matrices rawDataSize
]

{ #category : #drawing }
WDBBabylonSurface >> sendMeshesToMemory [
	| tmp vertexBufferSize indexBufferSize vertexMemory indexMemory nextVertexOffset nextIndexOffset map |
	meshesInMemory removeAll.
	meshMemoryMap removeAll.

	"Swap the mesh sets."
	tmp := meshesInMemory.
	meshesInMemory := meshesToSend.
	meshesToSend := tmp.
	
	"Compute the total memory requirement."	
	vertexBufferSize := 0.
	indexBufferSize := 0.
	meshesInMemory do: [ :mesh |
		vertexBufferSize := vertexBufferSize + mesh vertices size.
		indexBufferSize := indexBufferSize + mesh indices size.
	].

	self ensureVertexBufferCapacity: vertexBufferSize.
	self ensureIndexBufferCapacity: indexBufferSize.

	vertexMemory := vertexBuffer validPointer.
	indexMemory := indexBuffer validPointer.
	nextVertexOffset := 0.
	nextIndexOffset := 0.

	meshesInMemory do: [ :mesh |
		self assert: mesh vertices size % BabylonMesh2DVertex structureSize = 0.
		map := WDBBabylonMeshMemoryMap new
				baseVertex: nextVertexOffset // BabylonMesh2DVertex structureSize;
				baseIndex: nextIndexOffset // 4;
				yourself.
		meshMemoryMap at: mesh put: map.
				
		LibC memCopy: mesh vertices to: vertexMemory + nextVertexOffset size: mesh vertices size.
		LibC memCopy: mesh indices to: indexMemory + nextIndexOffset size: mesh indices size.				
	
		nextVertexOffset := nextVertexOffset + mesh vertices size.
		nextIndexOffset := nextIndexOffset + mesh indices size.
	]
]

{ #category : #initialization }
WDBBabylonSurface >> setupCommonState [
	transform := BabylonGenericTransform new.
	currentTransform := nil.
	currentClipRectangle := nil.

	drawingCommands removeAll.
	matrices removeAll.
	clipRectangleStack removeAll.
	quickState := WDPQuickState new.
	self
		projectionMatrixIndex: (self pushMatrix: self projectionMatrix);
		modelViewMatrixIndex: (self pushMatrix: WMMatrix4F identity).
]

{ #category : #drawing }
WDBBabylonSurface >> setupRenderTargetsForOSWindow: anOSWindow [
	| engine |
	(renderTarget isNotNil and:
	 [currentWindow == anOSWindow and:
	 [renderTarget extent = extent ] ]) ifTrue: [ ^ self ].

	engine := driver engine.
	self sampleCount > 1 ifTrue: [
		renderTarget := WDCRenderTarget for: engine extent: extent.
		renderTarget
			hasDepth: false;
			hasStencil: false;
			sampleCount: self sampleCount;
			createFramebuffers.

		resolveRenderTarget := WDCSwapChainRenderTarget for: engine extent: extent windowHandle: anOSWindow platformSpecificHandle.
		resolveRenderTarget
			hasDepth: false;
			hasStencil: false;
			sampleCount: 1;
			createFramebuffers.
	] ifFalse: [
		resolveRenderTarget := WDCSwapChainRenderTarget for: engine extent: extent windowHandle: anOSWindow platformSpecificHandle.
		resolveRenderTarget
			hasDepth: false;
			hasStencil: false;
			sampleCount: 1;
			createFramebuffers.

		renderTarget := resolveRenderTarget
	].

	currentWindow := anOSWindow.
]

{ #category : #drawing }
WDBBabylonSurface >> setupRenderTargetsForWodenWindow: aWodenWindow [
	sampleCount := aWodenWindow sampleCount.
	extent := aWodenWindow drawingSurfaceExtent.
	renderTarget := aWodenWindow validRenderTarget.
	resolveRenderTarget := aWodenWindow validResolveRenderTarget.
]

{ #category : #drawing }
WDBBabylonSurface >> setupStateTracker [
	stateTracker
		mode: WDCStateTrackerPompeiiRenderMode uniqueInstance;
		shaderSignature: self shaderSignature;
		useShaderResources: self shaderSignature defaultSamplers;
		
		frontFaceWinding: AGPU_COUNTER_CLOCKWISE;
		cullMode: AGPU_CULL_MODE_NONE;
		depthEnabled: false;
		depthWriteMask: false;

		blendingAllMode: WDCBlendingMode alphaOverCompose.

]

{ #category : #drawing }
WDBBabylonSurface >> shaderSignature [
	^ shaderSignature ifNil: [ WDBBabylonShaderSignature for: driver engine ]
]

{ #category : #accessing }
WDBBabylonSurface >> solidRenderPass [
	^ solidRenderPass ifNil: [ solidRenderPass := renderTarget createRenderPassWithColor: Color white ].
]

{ #category : #accessing }
WDBBabylonSurface >> stateTracker [
	^ stateTracker ifNil: [ stateTracker := WDCStateTracker for: driver engine ].
]

{ #category : #drawing }
WDBBabylonSurface >> submitDrawingCommands [
	| queue |
	queue := driver engine graphicsQueue.
	queue addCommandList: commandList validHandle.
	
	fence ifNotNil: [
		queue signalFence: fence.
		hasSubmittedFence := true
	]
]

{ #category : #accessing }
WDBBabylonSurface >> transform [
	^ transform
]

{ #category : #clipping }
WDBBabylonSurface >> transformClipRectangle: aRectangle [
	^ (transform transform: aRectangle origin) corner: (transform transform: aRectangle corner)
]

{ #category : #drawing }
WDBBabylonSurface >> validateQuickState [
	hasValidQuickState ifTrue: [ ^ self ].
	quickState storeBytesIn: quickStateBuffer.
	stateTracker pushConstants: 0 size: WDPQuickState structureSize values: quickStateBuffer.
	hasValidQuickState := true.
]

{ #category : #'as yet unclassified' }
WDBBabylonSurface >> waitFence [
	fence ifNil: [ ^ self ].
	hasSubmittedFence ifTrue: [ fence waitOnClient ].
	hasSubmittedFence := false
]

{ #category : #drawing }
WDBBabylonSurface >> withStateTracker: aStateTracker drawDuring: aBlock [
	stateTracker := aStateTracker.
	driver critical: [
		isInRenderPass := true.
		self
			doDrawBlock: aBlock.
	]
]

{ #category : #drawing }
WDBBabylonSurface >> withStateTracker: aStateTracker drawToRenderTarget: theRenderTarget during: aBlock [
	destroyed ifTrue: [ ^ self ].
	stateTracker := aStateTracker.
	driver critical: [
		extent := theRenderTarget extent.
		renderTarget := theRenderTarget.
		resolveRenderTarget := theRenderTarget.
		isInRenderPass := false.
	
		self doDrawBlock: aBlock
	].

]
