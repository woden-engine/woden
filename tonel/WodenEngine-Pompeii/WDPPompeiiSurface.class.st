Class {
	#name : #WDPPompeiiSurface,
	#superclass : #PompeiiSurface,
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
		'flipY',
		'hasValidQuickState',
		'quickState',
		'quickStateBuffer'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Pompeii'
}

{ #category : #construction }
WDPPompeiiSurface class >> defaultSampleCount [
	^ 4
]

{ #category : #construction }
WDPPompeiiSurface class >> extent: anExtent driver: aDriver [
	^ self extent: anExtent driver: aDriver sampleCount: self defaultSampleCount
	
]

{ #category : #construction }
WDPPompeiiSurface class >> extent: anExtent driver: aDriver sampleCount: aSampleCount [
	^ self basicNew initializeWithExtent: anExtent driver: aDriver sampleCount: aSampleCount
	
]

{ #category : #commands }
WDPPompeiiSurface >> activateMaterial: aMaterial [
	activeMaterial == aMaterial ifTrue: [ ^ self ].
	
	aMaterial ifNil: [
		self activateNullMaterial
	] ifNotNil: [
		aMaterial activateMaterialIn: self
	].
	activeMaterial := aMaterial.
	
]

{ #category : #drawing }
WDPPompeiiSurface >> activateNullMaterial [
	stateTracker
		vertexShader: driver vertexShader;
		fragmentShader: driver colorShader.
	activeMaterial := nil.
]

{ #category : #adding }
WDPPompeiiSurface >> addCommand: aCommand [
	drawingCommands add: aCommand
]

{ #category : #adding }
WDPPompeiiSurface >> addDrawingCommandMesh: mesh submesh: submesh [
	self flushTransforms.
	meshesToSend add: mesh.
	drawingCommands add: (WDPPompeiiDrawCommand new
		mesh: mesh;
		submesh: submesh;
		yourself)
]

{ #category : #drawing }
WDPPompeiiSurface >> allocateCommandList [
	commandAllocator ifNil: [
		commandAllocator := driver engine createGraphicsDirectCommandListAllocator.
		commandList := commandAllocator createListNow 
	] ifNotNil: [ 
		commandAllocator reset.
	].

]

{ #category : #drawing }
WDPPompeiiSurface >> allocateDrawingResources [
	self createFenceIfNeeded.
	self allocateRenderTarget.
	isInRenderPass := false.

]

{ #category : #drawing }
WDPPompeiiSurface >> allocateRenderTarget [
	renderTarget ifNotNil: [ ^ self ].
	
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
WDPPompeiiSurface >> asForm [
	| pitch slicePitch |
	gpuOnly ifTrue: [ self error: 'Cannot get a cpuForm from a GPU only surface.' ].
	fence ifNil: [ self error: 'Cannot get a cpuForm from a surface that has not been drawn.' ].
	
	fence ifNotNil: [ fence waitOnClient ].
	
	cpuForm ifNil: [
		cpuForm := Form extent: extent depth: 32.
	].

	pitch := cpuForm width * 4.
	slicePitch := pitch * cpuForm height.

	cpuForm unhibernate.
	resolveRenderTarget currentFramebuffer colorAttachments first validHandle
		readTextureData: 0 arrayIndex: 0 pitch: pitch slicePitch: slicePitch buffer: cpuForm bits.

	^ cpuForm
]

{ #category : #drawing }
WDPPompeiiSurface >> beginRenderPassWithColor: aColor [
	| pass |
	isInRenderPass ifTrue: [ self finishCurrentRenderPass ].
	
	pass := self solidRenderPass.
	pass setColorClearValue: 0 value: aColor asAGPUColor4f.
	
	stateTracker
		beginRenderPass: pass renderTarget: renderTarget.
	isInRenderPass := true
]

{ #category : #resources }
WDPPompeiiSurface >> createFenceIfNeeded [
	fence ifNil: [
		fence := driver engine device createFence.
	] ifNotNil: [
		fence waitOnClient
	].
]

{ #category : #drawing }
WDPPompeiiSurface >> doDrawBlock: aBlock [
	| canvas |
	self
		allocateDrawingResources;
		setupStateTracker;
		setupCommonState.
	canvas := WDPPompeiiCanvas new
		surface: self;
		yourself.
	aBlock value: canvas.
	self recordDrawingCommands
]

{ #category : #drawing }
WDPPompeiiSurface >> drawDuring: aBlock [
	driver critical: [ 
		flipY := true.
		self
			allocateDrawingResources;
			allocateCommandList.

		self stateTracker commandList: commandList rebuildWith: [
			self
				doDrawBlock: aBlock.
			renderTarget ~~ resolveRenderTarget ifTrue: [
				stateTracker
					resolveRenderTarget: renderTarget into: resolveRenderTarget
			]
		].
	
		self submitDrawingCommands
	]
]

{ #category : #accessing }
WDPPompeiiSurface >> driver [
	^ driver
]

{ #category : #drawing }
WDPPompeiiSurface >> ensureIndexBufferCapacity: requiredSize [
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
WDPPompeiiSurface >> ensureMatrixBufferCapacity: requiredSize [
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
WDPPompeiiSurface >> ensureVertexBufferCapacity: requiredSize [
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
	vertexBinding vertexBuffers: { vertexBuffer }
]

{ #category : #accessing }
WDPPompeiiSurface >> extent [
	^ extent
]

{ #category : #drawing }
WDPPompeiiSurface >> finishCurrentRenderPass [
	isInRenderPass ifFalse: [ ^ self ].
	
	stateTracker endRenderPass.
	isInRenderPass := false.
]

{ #category : #'as yet unclassified' }
WDPPompeiiSurface >> flushTransforms [
	currentTransform ~= transform ifTrue: [
		self addCommand: (WDPPompeiiSetModelViewMatrixCommand new
			matrix: (self pushMatrix: transform asWMMatrix4F)).
		currentTransform := transform copy.
	]
]

{ #category : #'as yet unclassified' }
WDPPompeiiSurface >> forcedSynchronization [
	fence ifNil: [ driver engine graphicsQueue finishExecution ]
]

{ #category : #formatting }
WDPPompeiiSurface >> format [
	^ self class defaultSurfaceFormat
]

{ #category : #'as yet unclassified' }
WDPPompeiiSurface >> getMeshBaseIndex: mesh [
	^ (meshMemoryMap at: mesh) baseIndex
]

{ #category : #'as yet unclassified' }
WDPPompeiiSurface >> getMeshBaseVertex: mesh [
	^ (meshMemoryMap at: mesh) baseVertex
]

{ #category : #accessing }
WDPPompeiiSurface >> gpuOnly [
	^ gpuOnly
]

{ #category : #accessing }
WDPPompeiiSurface >> gpuOnly: anObject [
	gpuOnly := anObject
]

{ #category : #initialization }
WDPPompeiiSurface >> initialize [
	super initialize.
	gpuOnly := false.
	transform := PompeiiGenericTransform new.
	currentTransform := nil.
	
	meshesInMemory := IdentitySet new.
	meshesToSend := IdentitySet new.
	drawingCommands := OrderedCollection new.
	meshMemoryMap := IdentityDictionary new.
	
	vertexBufferCapacity := 0.
	vertexBuffer := nil.
	indexBufferCapacity := 0.
	indexBuffer := nil.
	matrixBufferCapacity := 0.
	matrixBuffer := nil.
	
	matrices := SLVMNativeOrderedCollection for: WMMatrix4F.
	quickStateBuffer := ByteArray new: WDPQuickState structureSize.
]

{ #category : #initialization }
WDPPompeiiSurface >> initializeWithExtent: anExtent driver: aDriver sampleCount: aSampleCount [
	extent := anExtent.
	sampleCount := aSampleCount.
	driver := aDriver.
	self initialize
	
]

{ #category : #drawing }
WDPPompeiiSurface >> isInRenderPass [
	^ isInRenderPass
]

{ #category : #drawing }
WDPPompeiiSurface >> modelViewMatrixIndex: aMatrixIndex [
	quickState modelViewMatrixIndex: aMatrixIndex.
	hasValidQuickState := false.
]

{ #category : #accessing }
WDPPompeiiSurface >> projectionMatrix [
	^ WMMatrix4F
		orthoLeft: 0.0 right: extent x asFloat
		bottom: extent y asFloat top: 0.0
		near: -1.0 far: 1.0
		invertedY: (driver engine projectionInvertedY xor: [flipY])
]

{ #category : #drawing }
WDPPompeiiSurface >> projectionMatrixIndex: aMatrixIndex [
	quickState projectionMatrixIndex: aMatrixIndex.
	hasValidQuickState := false.
]

{ #category : #initialization }
WDPPompeiiSurface >> pushMatrix: aMatrix [
	matrices add: aMatrix.
	^ matrices size - 1
]

{ #category : #drawing }
WDPPompeiiSurface >> recordDrawingCommands [
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
WDPPompeiiSurface >> sampleCount [
	^ sampleCount
]

{ #category : #accessing }
WDPPompeiiSurface >> sampleCount: anObject [
	sampleCount := anObject
]

{ #category : #drawing }
WDPPompeiiSurface >> sendMatricesToMemory [
	self ensureMatrixBufferCapacity: matrices size.
	LibC memCopy: matrices rawData to: matrixBuffer validPointer size: matrices rawDataSize
]

{ #category : #drawing }
WDPPompeiiSurface >> sendMeshesToMemory [
	| tmp vertexBufferSize indexBufferSize vertexMemory indexMemory nextVertexOffset nextIndexOffset map |
	"Swap the mesh sets."
	tmp := meshesInMemory.
	meshesInMemory := meshesToSend.
	meshesToSend := tmp.
	
	meshMemoryMap removeAll.

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
		self assert: mesh vertices size % PompeiiMesh2DVertex structureSize = 0.
		map := WDPPompeiiMeshMemoryMap new
				baseVertex: nextVertexOffset // PompeiiMesh2DVertex structureSize;
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
WDPPompeiiSurface >> setupCommonState [
	transform := PompeiiGenericTransform new.
	currentTransform := nil.

	drawingCommands removeAll.
	matrices removeAll.
	quickState := WDPQuickState new.
	self
		projectionMatrixIndex: (self pushMatrix: self projectionMatrix);
		modelViewMatrixIndex: (self pushMatrix: WMMatrix4F identity).
]

{ #category : #drawing }
WDPPompeiiSurface >> setupStateTracker [
	stateTracker
		reset;
		mode: #pompeii;
		shaderSignature: self shaderSignature;
		useShaderResources: self shaderSignature defaultSamplers;
		
		frontFaceWinding: AGPU_COUNTER_CLOCKWISE;
		cullMode: AGPU_CULL_MODE_NONE;
		depthEnabled: false;

		blendingAllMode: WDCBlendingMode replace.

]

{ #category : #drawing }
WDPPompeiiSurface >> shaderSignature [
	^ shaderSignature ifNil: [ WDPPompeiiShaderSignature for: driver engine ]
]

{ #category : #accessing }
WDPPompeiiSurface >> solidRenderPass [
	^ solidRenderPass ifNil: [ solidRenderPass := renderTarget createRenderPassWithColor: Color white ].
]

{ #category : #accessing }
WDPPompeiiSurface >> stateTracker [
	^ stateTracker ifNil: [ stateTracker := WDCStateTracker for: driver engine ].
]

{ #category : #drawing }
WDPPompeiiSurface >> submitDrawingCommands [
	| queue |
	queue := driver engine graphicsQueue.
	queue addCommandList: commandList validHandle.
	
	fence ifNotNil: [ queue signalFence: fence ]
]

{ #category : #accessing }
WDPPompeiiSurface >> transform [
	^ transform
]

{ #category : #drawing }
WDPPompeiiSurface >> validateQuickState [
	hasValidQuickState ifTrue: [ ^ self ].
	quickState storeBytesIn: quickStateBuffer.
	stateTracker pushConstants: 0 size: WDPQuickState structureSize values: quickStateBuffer.
	hasValidQuickState := true.
]
