Class {
	#name : #WDCParticleSystemRenderableSceneData,
	#superclass : #WDCSceneDependantRenderableData,
	#instVars : [
		'particleSystem',
		'engine',
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
WDCParticleSystemRenderableSceneData >> activateParticleMaterialOn: stateTracker [
	^ self validParticleMaterial activateOn: stateTracker
]

{ #category : #accessing }
WDCParticleSystemRenderableSceneData >> cpuParticleSimulationBuffer [
	^ cpuParticleSimulationBuffer
]

{ #category : #accessing }
WDCParticleSystemRenderableSceneData >> cpuParticleSimulationBuffer: anObject [
	cpuParticleSimulationBuffer := anObject
]

{ #category : #'as yet unclassified' }
WDCParticleSystemRenderableSceneData >> deltaTime [
	^ 1.0 / WDCFrameBufferingDriver defaultTargetFrameRate.

]

{ #category : #accessing }
WDCParticleSystemRenderableSceneData >> engine [
	^ engine
]

{ #category : #accessing }
WDCParticleSystemRenderableSceneData >> engine: anObject [
	engine := anObject
]

{ #category : #accessing }
WDCParticleSystemRenderableSceneData >> particleStateBuffer [
	^ particleStateBuffer
]

{ #category : #accessing }
WDCParticleSystemRenderableSceneData >> particleStateBuffer: anObject [
	particleStateBuffer := anObject
]

{ #category : #accessing }
WDCParticleSystemRenderableSceneData >> particleSystem [
	^ particleSystem
]

{ #category : #accessing }
WDCParticleSystemRenderableSceneData >> particleSystem: anObject [
	particleSystem := anObject
]

{ #category : #'as yet unclassified' }
WDCParticleSystemRenderableSceneData >> shadersDirectory [
	^ WodenCoreAssets location / #shaders
]

{ #category : #'as yet unclassified' }
WDCParticleSystemRenderableSceneData >> simulateFrame: frameBufferingIndex [
	WDCEngine gpuBasedParticleSimulation ifTrue: [
		self simulateFrameWithTheGPU
	] ifFalse: [ 
		self simulateFrameWithTheCPU: frameBufferingIndex
	]
]

{ #category : #'as yet unclassified' }
WDCParticleSystemRenderableSceneData >> simulateFrameWithTheCPU: frameBufferingIndex [
	| simulationBlock deltaTime |
	simulationBlock := particleSystem simulationBlock.
	deltaTime := self deltaTime.
	cpuParticleSimulationBuffer doWithIndex: [ :particleState :index |
		simulationBlock value: particleState value: index value: deltaTime.
		cpuParticleSimulationBuffer at: index put: particleState
	].

	LibC memCopy: cpuParticleSimulationBuffer rawData
		to: particleStateBuffer validPointer + (cpuParticleSimulationBuffer rawDataSize * (frameBufferingIndex - 1))
		size: cpuParticleSimulationBuffer rawDataSize
	
]

{ #category : #'as yet unclassified' }
WDCParticleSystemRenderableSceneData >> simulateFrameWithTheGPU [
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
			memoryBarrier: AGPU_PIPELINE_STAGE_COMPUTE_SHADER
				dest_stage: AGPU_PIPELINE_STAGE_VERTEX_SHADER | AGPU_PIPELINE_STAGE_FRAGMENT_SHADER
				source_accesses: AGPU_ACCESS_SHADER_WRITE dest_accesses: AGPU_ACCESS_SHADER_READ.
	].

	engine graphicsQueue addCommandList: currentCommandLists validCommandList validHandle.

]

{ #category : #'as yet unclassified' }
WDCParticleSystemRenderableSceneData >> validParticleMaterial [
	^ particleMaterial ifNil: [ particleMaterial := WDCSimpleParticleMaterial for: engine ]
]

{ #category : #'as yet unclassified' }
WDCParticleSystemRenderableSceneData >> validParticleSimulationComputeParameters [
	^ particleSimulationComputeParameters ifNil: [ particleSimulationComputeParameters :=
		engine newGenericComputeShaderArguments
			storageBuffer: particleStateBuffer slot: 0
	]
]

{ #category : #'as yet unclassified' }
WDCParticleSystemRenderableSceneData >> validParticleSimulationShaderLibrary [
	| codeConverter lowLevelShader spirvShader compiler |
	particleSimulationShaderLibrary ifNil: [
		codeConverter := DASLPharoCodeConverter new.
		codeConverter
			convertFunction: particleSystem simulationBlock name: #particleStateTransitionFunction argumentTypes: #((ref WDCParticleState) uint float) returnType: #void.

		compiler := 	DASLCompiler new.
		spirvShader := compiler 
			target: #'spir-v';
			withDebugInformation;
			optimizationLevel: 2;
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
