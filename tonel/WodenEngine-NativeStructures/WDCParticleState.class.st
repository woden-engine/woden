Class {
	#name : #WDCParticleState,
	#superclass : #SysmelStructureType,
	#instVars : [
		'#position => Float32x3',
		'#velocity => Float32x3',
		'#size => Float32x3',
		'#color => Float32x4',
		'#lifeTime => Float32',
		'#randomSeed => UInt32',
		'#flags => UInt32',
		'#padding => UInt32'
	],
	#category : #'WodenEngine-NativeStructures-Core-Particle'
}

{ #category : #accessing }
WDCParticleState >> color [
	^ color
]

{ #category : #accessing }
WDCParticleState >> color: anObject [
	color := anObject
]

{ #category : #accessing }
WDCParticleState >> flags [
	^ flags
]

{ #category : #accessing }
WDCParticleState >> flags: anObject [
	flags := anObject
]

{ #category : #accessing }
WDCParticleState >> lifeTime [
	^ lifeTime
]

{ #category : #accessing }
WDCParticleState >> lifeTime: anObject [
	lifeTime := anObject
]

{ #category : #accessing }
WDCParticleState >> padding [
	^ padding
]

{ #category : #accessing }
WDCParticleState >> padding: anObject [
	padding := anObject
]

{ #category : #accessing }
WDCParticleState >> position [
	^ position
]

{ #category : #accessing }
WDCParticleState >> position: anObject [
	position := anObject
]

{ #category : #accessing }
WDCParticleState >> randomSeed [
	^ randomSeed
]

{ #category : #accessing }
WDCParticleState >> randomSeed: anObject [
	randomSeed := anObject
]

{ #category : #accessing }
WDCParticleState >> size [
	^ size
]

{ #category : #accessing }
WDCParticleState >> size: anObject [
	size := anObject
]

{ #category : #accessing }
WDCParticleState >> velocity [
	^ velocity
]

{ #category : #accessing }
WDCParticleState >> velocity: anObject [
	velocity := anObject
]
