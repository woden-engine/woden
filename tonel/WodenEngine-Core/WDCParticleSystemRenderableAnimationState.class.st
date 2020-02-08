Class {
	#name : #WDCParticleSystemRenderableAnimationState,
	#superclass : #WDCRenderableDeformationState,
	#instVars : [
		'particleSystem',
		'particleStateBuffer',
		'particleMaterial',
		'cpuParticleSimulationBuffer',
		'particleSimulationShaderLibrary',
		'particleSimulationComputeParameters',
		'perFrameCommandLists'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Particle'
}

{ #category : #'as yet unclassified' }
WDCParticleSystemRenderableAnimationState >> activateParticleMaterialOn: stateTracker [
	^ self validParticleMaterial activateOn: stateTracker
]

{ #category : #accessing }
WDCParticleSystemRenderableAnimationState >> cpuParticleSimulationBuffer [
	cpuParticleSimulationBuffer ifNil: [ self createCPUParticleSimulationBuffer ].
	^ cpuParticleSimulationBuffer
]

{ #category : #accessing }
WDCParticleSystemRenderableAnimationState >> createCPUParticleSimulationBuffer [
	| initialParticleState particleCount startupTime |
	particleCount := particleSystem particleCount.
	startupTime := particleSystem startupTime.
	
	cpuParticleSimulationBuffer := SLVMNativeArray for: WDCParticleState new: particleCount.
	initialParticleState := WDCParticleState new
		size: (WMVector3F x: 0.2 y: 0.2 z: 0.2);
		color: Color black asWMVector4F;
		startingUp: true.
		
	1 to: particleSystem particleCount do: [ :index |
		initialParticleState
			lifeTime: (index - 1) * (startupTime / particleCount);
			setInitialSeedForIndex: index.
		
		cpuParticleSimulationBuffer at: index put: initialParticleState
	].
]

{ #category : #accessing }
WDCParticleSystemRenderableAnimationState >> createEngineDependantData [
	| stateBufferSize |
	super createEngineDependantData.

	stateBufferSize := self cpuParticleSimulationBuffer rawDataSize.
	WDCEngine gpuBasedParticleSimulation ifTrue: [
		particleStateBuffer := engine createGPUStorageBuffer: stateBufferSize initialData: cpuParticleSimulationBuffer rawData.
		renderableStateBindings do: [ :binding |
			binding bind: 0 storageBuffer: particleStateBuffer offset: 0 size: stateBufferSize
		].
	] ifFalse: [
		| cpuInitialData |
		cpuInitialData := ByteArray new.
		renderableStateBindings do: [ :b |
			cpuInitialData := cpuInitialData , cpuParticleSimulationBuffer rawData
		].
		
		particleStateBuffer := engine createStreamingStorageBuffer: cpuInitialData size initialData: cpuInitialData.
	].

	renderableStateBindings doWithIndex: [ :bindings :index |
		bindings
			bind: 0 storageBuffer: particleStateBuffer offset: (index - 1) * stateBufferSize size: stateBufferSize
	]


]

{ #category : #'as yet unclassified' }
WDCParticleSystemRenderableAnimationState >> deltaTime [
	^ 1.0 / WDCFrameBufferingDriver defaultTargetFrameRate.

]

{ #category : #accessing }
WDCParticleSystemRenderableAnimationState >> particleStateBuffer [
	^ particleStateBuffer
]

{ #category : #accessing }
WDCParticleSystemRenderableAnimationState >> particleStateBuffer: anObject [
	particleStateBuffer := anObject
]

{ #category : #accessing }
WDCParticleSystemRenderableAnimationState >> particleSystem [
	^ particleSystem
]

{ #category : #accessing }
WDCParticleSystemRenderableAnimationState >> particleSystem: anObject [
	particleSystem := anObject
]

{ #category : #enumerating }
WDCParticleSystemRenderableAnimationState >> precacheResources [
	self validParticleMaterial precacheResources.
	WDCEngine gpuBasedParticleSimulation ifTrue: [
		self
			validParticleSimulationComputeParameters;
			validParticleSimulationShaderLibrary
	].
]

{ #category : #accessing }
WDCParticleSystemRenderableAnimationState >> requiresAccessFromTheCPU [
	^ WDCEngine gpuBasedParticleSimulation not
]

{ #category : #'as yet unclassified' }
WDCParticleSystemRenderableAnimationState >> shadersDirectory [
	^ WodenCoreAssets location / #shaders
]

{ #category : #'as yet unclassified' }
WDCParticleSystemRenderableAnimationState >> simulateFrame: frameIndex [
	WDCEngine gpuBasedParticleSimulation ifTrue: [
		self simulateFrameWithTheGPU
	] ifFalse: [ 
		self simulateFrameWithTheCPU: frameIndex
	]
]

{ #category : #'as yet unclassified' }
WDCParticleSystemRenderableAnimationState >> simulateFrameWithTheCPU: frameIndex [
	| simulationBlock deltaTime |
	simulationBlock := particleSystem simulationBlock.
	deltaTime := self deltaTime.
	cpuParticleSimulationBuffer doWithIndex: [ :particleState :index |
		simulationBlock value: particleState value: index value: deltaTime.
		cpuParticleSimulationBuffer at: index put: particleState
	].

	LibC memCopy: cpuParticleSimulationBuffer rawData
		to: particleStateBuffer validPointer + (cpuParticleSimulationBuffer rawDataSize * (engine bufferingFrameIndex - 1))
		size: cpuParticleSimulationBuffer rawDataSize
	
]

{ #category : #'as yet unclassified' }
WDCParticleSystemRenderableAnimationState >> simulateFrameWithTheGPU [
	| shader simulationParameters stateTracker currentCommandLists pushConstants deltaTime |
	shader := self validParticleSimulationShaderLibrary
		getComputeStage: #particle_simulation.
	simulationParameters := self validParticleSimulationComputeParameters.

	perFrameCommandLists ifNil: [ perFrameCommandLists := WDCPerFrameSimpleCommandList for: engine ].
	currentCommandLists := perFrameCommandLists currentList.
	currentCommandLists validCommandAllocator reset.

	stateTracker := WDCStateTracker for: engine.
	stateTracker commandList: currentCommandLists validCommandList rebuildWith: [
		pushConstants := ByteArray new: 8.
		pushConstants
			longAt: 1 put: particleSystem particleCount bigEndian: false;
			floatAt: 5 put: self deltaTime.

		stateTracker			
			computeShader: shader arguments: simulationParameters;
			pushConstants: 0 size: pushConstants size values: pushConstants;
			dispatchComputeGlobalGrid: particleSystem particleCount;
			bufferMemoryBarrier: particleStateBuffer
				source_stage: AGPU_PIPELINE_STAGE_COMPUTE_SHADER
				dest_stage: AGPU_PIPELINE_STAGE_VERTEX_SHADER | AGPU_PIPELINE_STAGE_FRAGMENT_SHADER
				source_accesses: AGPU_ACCESS_SHADER_WRITE dest_accesses: AGPU_ACCESS_SHADER_READ
				offset: 0 size: particleStateBuffer size.
	].

	engine graphicsQueue addCommandList: currentCommandLists validCommandList validHandle.

]

{ #category : #'as yet unclassified' }
WDCParticleSystemRenderableAnimationState >> updateCommonGpuStateForFrame: frameIndex [
	self simulateFrame: frameIndex
]

{ #category : #'as yet unclassified' }
WDCParticleSystemRenderableAnimationState >> validParticleMaterial [
	particleMaterial ifNil: [ particleMaterial := WDCSimpleParticleMaterial for: engine ].
	particleMaterial proceduralRenderingBlock: particleSystem renderingBlock.
	^ particleMaterial
]

{ #category : #'as yet unclassified' }
WDCParticleSystemRenderableAnimationState >> validParticleSimulationComputeParameters [
	^ particleSimulationComputeParameters ifNil: [ particleSimulationComputeParameters :=
		engine newGenericComputeShaderArguments
			storageBuffer: particleStateBuffer slot: 0
	]
]

{ #category : #'as yet unclassified' }
WDCParticleSystemRenderableAnimationState >> validParticleSimulationShaderLibrary [
	| codeConverter lowLevelShader spirvShader compiler |
	particleSimulationShaderLibrary ifNil: [
		codeConverter := DASLPharoCodeConverter new.
		codeConverter
			convertFunction: particleSystem simulationBlock name: #particleStateTransitionFunction argumentTypes: #((ref WDCParticleState) uint float) returnType: #void.

		compiler := 	DASLCompiler new.
		spirvShader := compiler 
			target: #'spir-v';
			withDebugInformation;
			optimizationLevel: 0;
			addIncludeDirectory: self shadersDirectory;
			sourceFromFileNamed: (self shadersDirectory resolve: 'particle/simulation-interface.dastrel' asFileReference) injectingNodes: codeConverter generatedNodes;
			compile;
			generatedCode.
	
			lowLevelShader := WDCLowLevelShaderSource new
				engine: engine;
				entryFile: 'generated shader' asFileReference;
				source: spirvShader asShaderCode;
				entryPoints: spirvShader entryPoints;
				yourself.
		
			particleSimulationShaderLibrary := lowLevelShader asShaderLibrary
	].

	^ particleSimulationShaderLibrary
]
