Class {
	#name : #WDCParticleSystemRenderable,
	#superclass : #WDCRenderable,
	#instVars : [
		'particleMaterial',
		'particleCount',
		'simulationBlock',
		'startupTime'
	],
	#category : #'WodenEngine-Core-Particle'
}

{ #category : #'extra per object rendering data' }
WDCParticleSystemRenderable >> createSceneDependentDataFor: anEngine into: bindings [
	| cpuParticleSimulationBuffer particleStateBuffer renderableSceneData stateBufferSize initialParticleState |
	cpuParticleSimulationBuffer := SLVMNativeArray for: WDCParticleState new: particleCount.
	initialParticleState := WDCParticleState new
		size: (WMVector3F x: 0.2 y: 0.2 z: 0.2);
		color: Color black asWMVector4F;
		startingUp: true.
		
	1 to: particleCount do: [ :index |
		initialParticleState
			lifeTime: (index - 1) * (startupTime / particleCount);
			setInitialSeedForIndex: index.
		
		cpuParticleSimulationBuffer at: index put: initialParticleState
	].

	stateBufferSize := cpuParticleSimulationBuffer rawDataSize.
	WDCEngine gpuBasedParticleSimulation ifTrue: [
		particleStateBuffer := anEngine createGPUStorageBuffer: stateBufferSize initialData: cpuParticleSimulationBuffer rawData.
		bindings doWithIndex: [ :binding :index |
			binding bind: 2 storageBuffer: particleStateBuffer offset: 0 size: stateBufferSize
		].
	] ifFalse: [
		| cpuInitialData |
		cpuInitialData := ByteArray new.
		bindings do: [ :b |
			cpuInitialData := cpuInitialData , cpuParticleSimulationBuffer rawData
		].
		
		particleStateBuffer := anEngine createStreamingStorageBuffer: cpuInitialData size initialData: cpuInitialData.
		bindings doWithIndex: [ :binding :index |
			binding bind: 2 storageBuffer: particleStateBuffer offset: (index - 1) * stateBufferSize size: stateBufferSize
		].
	].

	renderableSceneData := WDCParticleSystemRenderableSceneData new
		engine: anEngine;
		particleSystem: self;
		particleStateBuffer: particleStateBuffer;
		cpuParticleSimulationBuffer: cpuParticleSimulationBuffer.
	^ renderableSceneData
]

{ #category : #initialization }
WDCParticleSystemRenderable >> initialize [
	super initialize.
	particleCount := 1000.
	startupTime := 3.0.
]

{ #category : #accessing }
WDCParticleSystemRenderable >> particleCount [
	^ particleCount
]

{ #category : #accessing }
WDCParticleSystemRenderable >> particleCount: anObject [
	particleCount := anObject
]

{ #category : #'extra per object rendering data' }
WDCParticleSystemRenderable >> performCommonGpuStateUpdateFor: anEngine frameIndex: frameBufferingIndex into: particleSystemSceneData [
	particleSystemSceneData simulateFrame: frameBufferingIndex
]

{ #category : #'extra per object rendering data' }
WDCParticleSystemRenderable >> renderOn: stateTracker instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex [
	(renderingSceneDependantData activateParticleMaterialOn: stateTracker) ifTrue: [ 
		stateTracker
			primitiveType: AGPU_TRIANGLE_STRIP;
			drawArrays: 4 instance_count: particleCount first_vertex: baseInstance base_instance: baseVertex
	].
]

{ #category : #'extra per object rendering data' }
WDCParticleSystemRenderable >> renderOn: listBuilder mode: renderMode submode: submode instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex [
]

{ #category : #accessing }
WDCParticleSystemRenderable >> simulationBlock [
	^ simulationBlock
]

{ #category : #accessing }
WDCParticleSystemRenderable >> simulationBlock: anObject [
	simulationBlock := anObject
]
