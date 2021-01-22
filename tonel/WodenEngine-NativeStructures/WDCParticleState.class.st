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

{ #category : #random }
WDCParticleState >> nextRandom [
	<dastrelShaderFunction: #particleNextRandom returnType: #float>
	^ (self nextRandomInt castTo: Float32) / 1073741823.0
]

{ #category : #random }
WDCParticleState >> nextRandomInt [
	<dastrelShaderFunction: #particleNextRandomInt returnType: #int>
	^ self nextRandomUInt - 16r40000000
]

{ #category : #random }
WDCParticleState >> nextRandomUInt [
	<dastrelShaderFunction: #particleNextRandomUInt returnType: #uint>
	"https://en.wikipedia.org/wiki/Linear_congruential_generator"
	"GlibC 2^31 	1103515245 	12345"
	^ randomSeed := (randomSeed*1103515245 + 12345) & 16r7FFFFFFF
]

{ #category : #random }
WDCParticleState >> nextRandomVector2F [
	<dastrelShaderFunction: #particleNextRandomVector2F returnType: #float2>
	^ Float32x2 x: self nextRandom y: self nextRandom
]

{ #category : #random }
WDCParticleState >> nextRandomVector3F [
	<dastrelShaderFunction: #particleNextRandomVector3F returnType: #float3>
	^ Float32x3 x: self nextRandom y: self nextRandom z: self nextRandom
]

{ #category : #random }
WDCParticleState >> nextRandomVector3F_xz [
	<dastrelShaderFunction: #particleNextRandomVector3F_xz returnType: #float3>
	^ Float32x3 x: self nextRandom y: 0.0 z: self nextRandom
]

{ #category : #random }
WDCParticleState >> nextRandomVector4F [
	<dastrelShaderFunction: #particleNextRandomVector4F>
	^ Float32x4 x: self nextRandom y: self nextRandom z: self nextRandom w: self nextRandom
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

{ #category : #random }
WDCParticleState >> setInitialSeedForIndex: index [
	randomSeed := index randomNoiseHash castTo: UInt32.
	randomSeed == 0 ifTrue: [
		randomSeed := 1.
	].
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
WDCParticleState >> startingUp [
	<dastrelShaderFunction: #isParticleStartingUp returnType: #bool>
	^ flags anyMask: 1
]

{ #category : #accessing }
WDCParticleState >> startingUp: aBoolean [
	<dastrelShaderFunction: #setParticleStartingUp returnType: #void>
	aBoolean ifTrue: [
		flags := flags | 1
	] ifFalse: [ 
		flags := flags bitClear:  1
	]
]

{ #category : #accessing }
WDCParticleState >> velocity [
	^ velocity
]

{ #category : #accessing }
WDCParticleState >> velocity: anObject [
	velocity := anObject
]
