Class {
	#name : #WDCParticleSystemRenderable,
	#superclass : #WDCDeformableRenderable,
	#instVars : [
		'particleCount',
		'simulationBlock',
		'renderingBlock',
		'startupTime'
	],
	#category : #'WodenEngine-Core-Particle'
}

{ #category : #'extra per object rendering data' }
WDCParticleSystemRenderable >> createDeformationState [
	^ WDCParticleSystemRenderableAnimationState new
		particleSystem: self;
		engine: engine;
		yourself
]

{ #category : #initialization }
WDCParticleSystemRenderable >> initialize [
	super initialize.
	self makeTranslucent.
		
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
WDCParticleSystemRenderable >> renderOn: stateTracker instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex [
	(deformationState activateParticleMaterialOn: stateTracker) ifTrue: [ 
		stateTracker
			useShaderResources: deformationState currentRenderableStateBinding;
			primitiveType: AGPU_TRIANGLE_STRIP;
			drawArrays: 4 instance_count: particleCount first_vertex: baseInstance base_instance: baseVertex
	].
]

{ #category : #accessing }
WDCParticleSystemRenderable >> renderingBlock [
	^ renderingBlock
]

{ #category : #accessing }
WDCParticleSystemRenderable >> renderingBlock: anObject [
	renderingBlock := anObject
]

{ #category : #accessing }
WDCParticleSystemRenderable >> simulationBlock [
	^ simulationBlock
]

{ #category : #accessing }
WDCParticleSystemRenderable >> simulationBlock: anObject [
	simulationBlock := anObject
]

{ #category : #accessing }
WDCParticleSystemRenderable >> startupTime [
	^ startupTime
]

{ #category : #accessing }
WDCParticleSystemRenderable >> startupTime: anObject [
	startupTime := anObject
]
