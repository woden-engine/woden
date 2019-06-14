Class {
	#name : #WDCParticleSystemRenderableSceneData,
	#superclass : #WDCSceneDependantRenderableData,
	#instVars : [
		'particleSystem',
		'engine',
		'particleStateBuffer',
		'particleMaterial',
		'cpuParticleSimulationBuffer'
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
	deltaTime := 1.0 / WDCFrameBufferingDriver defaultTargetFrameRate.
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
	self flag: 'TODO: Implement this'
]

{ #category : #'as yet unclassified' }
WDCParticleSystemRenderableSceneData >> validParticleMaterial [
	^ particleMaterial ifNil: [ particleMaterial := WDCSimpleParticleMaterial for: engine ]
]
