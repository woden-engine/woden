Class {
	#name : #WDPPompeiiTextureMaterial,
	#superclass : #PompeiiTextureMaterial,
	#instVars : [
		'driver',
		'modified',
		'shaderBinding'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Pompeii-Material'
}

{ #category : #accessing }
WDPPompeiiTextureMaterial >> driver [
	^ driver
]

{ #category : #accessing }
WDPPompeiiTextureMaterial >> driver: anObject [
	driver := anObject
]

{ #category : #initialization }
WDPPompeiiTextureMaterial >> forPompeiiDriver: aDriver [
	^ self
]

{ #category : #initialization }
WDPPompeiiTextureMaterial >> initialize [
	super initialize.
	modified := true
]

{ #category : #initialization }
WDPPompeiiTextureMaterial >> modified [
	modified := true
]

{ #category : #initialization }
WDPPompeiiTextureMaterial >> updateShaderBinding [
	texture ifNil: [ ^ self ].
	shaderBinding ifNil: [ ^ self ].
	shaderBinding bind: 0 texture: texture startMiplevel: 0 miplevels: -1 lodclamp: 100000.0
]

{ #category : #initialization }
WDPPompeiiTextureMaterial >> validShaderBinding [
	shaderBinding ifNil: [
		shaderBinding := (WDPPompeiiShaderSignature for: driver engine) newTexture.
		self updateShaderBinding
	].

	^ shaderBinding
]

{ #category : #initialization }
WDPPompeiiTextureMaterial >> validTexture [
]
