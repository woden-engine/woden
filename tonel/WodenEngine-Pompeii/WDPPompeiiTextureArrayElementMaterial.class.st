Class {
	#name : #WDPPompeiiTextureArrayElementMaterial,
	#superclass : #PompeiiTextureArrayElementMaterial,
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
WDPPompeiiTextureArrayElementMaterial >> driver [
	^ driver
]

{ #category : #accessing }
WDPPompeiiTextureArrayElementMaterial >> driver: anObject [
	driver := anObject
]

{ #category : #initialization }
WDPPompeiiTextureArrayElementMaterial >> forPompeiiDriver: aDriver [
	^ self
]

{ #category : #initialization }
WDPPompeiiTextureArrayElementMaterial >> initialize [
	super initialize.
	modified := true
]

{ #category : #accessing }
WDPPompeiiTextureArrayElementMaterial >> modified [
]

{ #category : #initialization }
WDPPompeiiTextureArrayElementMaterial >> updateShaderBinding [
	textureArray ifNil: [ ^ self ].
	shaderBinding ifNil: [ ^ self ].
	"shaderBinding bind: 0 textureArray: textureArray startMiplevel: 0 miplevels: -1 firstElement: elementIndex numberOfElements: 1 lodclamp: 100000.0"
	shaderBinding bind: 0 texture: textureArray startMiplevel: 0 miplevels: -1 lodclamp: 100000.0
]

{ #category : #initialization }
WDPPompeiiTextureArrayElementMaterial >> validShaderBinding [
	shaderBinding ifNil: [
		shaderBinding := (WDPPompeiiShaderSignature for: driver engine) newTexture.
		self updateShaderBinding
	].

	^ shaderBinding
]

{ #category : #initialization }
WDPPompeiiTextureArrayElementMaterial >> validTexture [
]
