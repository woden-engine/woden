Class {
	#name : #WDCParticleSystemRenderable,
	#superclass : #WDCAnimatedRenderable,
	#instVars : [
		'particleMaterial',
		'particleCount',
		'simulationBlock',
		'startupTime'
	],
	#category : #'WodenEngine-Core-Particle'
}

{ #category : #'extra per object rendering data' }
WDCParticleSystemRenderable >> createAnimationState [
	^ WDCParticleSystemRenderableAnimationState new
		particleSystem: self;
		engine: engine;
		yourself
]

{ #category : #initialization }
WDCParticleSystemRenderable >> initialize [
	super initialize.
	self
		isOpaqueShadowCaster: false;
		translucentRenderPriority.
		
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
	(animationState activateParticleMaterialOn: stateTracker) ifTrue: [ 
		stateTracker
			useShaderResources: animationState currentRenderableStateBinding;
			primitiveType: AGPU_TRIANGLE_STRIP;
			drawArrays: 4 instance_count: particleCount first_vertex: baseInstance base_instance: baseVertex
	].
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
