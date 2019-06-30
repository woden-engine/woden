Class {
	#name : #WDCParticleRandomGenerator,
	#superclass : #WDCAbstractRenderable,
	#instVars : [
		'particleCount',
		'particleIndex',
		'simulationIteration',
		'seed'
	],
	#category : #'WodenEngine-Core-Particle'
}

{ #category : #accessing }
WDCParticleRandomGenerator >> particleCount [
	^ particleCount
]

{ #category : #accessing }
WDCParticleRandomGenerator >> particleCount: anObject [
	particleCount := anObject
]

{ #category : #accessing }
WDCParticleRandomGenerator >> particleIndex [
	^ particleIndex
]

{ #category : #accessing }
WDCParticleRandomGenerator >> particleIndex: anObject [
	particleIndex := anObject.
	seed := nil.
]

{ #category : #accessing }
WDCParticleRandomGenerator >> seed [
	^ seed
]

{ #category : #accessing }
WDCParticleRandomGenerator >> seed: anObject [
	seed := anObject
]

{ #category : #accessing }
WDCParticleRandomGenerator >> simulationIteration [
	^ simulationIteration
]

{ #category : #accessing }
WDCParticleRandomGenerator >> simulationIteration: anObject [
	simulationIteration := anObject
]
