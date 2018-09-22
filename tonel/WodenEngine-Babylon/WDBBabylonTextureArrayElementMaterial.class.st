Class {
	#name : #WDBBabylonTextureArrayElementMaterial,
	#superclass : #BabylonTextureArrayElementMaterial,
	#instVars : [
		'driver',
		'modified',
		'shaderBinding'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Babylon-Material'
}

{ #category : #accessing }
WDBBabylonTextureArrayElementMaterial >> driver [
	^ driver
]

{ #category : #accessing }
WDBBabylonTextureArrayElementMaterial >> driver: anObject [
	driver := anObject
]

{ #category : #initialization }
WDBBabylonTextureArrayElementMaterial >> forBabylonDriver: aDriver [
	^ self
]

{ #category : #initialization }
WDBBabylonTextureArrayElementMaterial >> initialize [
	super initialize.
	modified := true
]

{ #category : #accessing }
WDBBabylonTextureArrayElementMaterial >> modified [
]

{ #category : #initialization }
WDBBabylonTextureArrayElementMaterial >> updateShaderBinding [
	textureArray ifNil: [ ^ self ].
	shaderBinding ifNil: [ ^ self ].
	"shaderBinding bind: 0 textureArray: textureArray startMiplevel: 0 miplevels: -1 firstElement: elementIndex numberOfElements: 1 lodclamp: 100000.0"
	shaderBinding bind: 0 texture: textureArray startMiplevel: 0 miplevels: -1 lodclamp: 100000.0
]

{ #category : #initialization }
WDBBabylonTextureArrayElementMaterial >> validShaderBinding [
	shaderBinding ifNil: [
		shaderBinding := (WDBBabylonShaderSignature for: driver engine) newTexture.
		self updateShaderBinding
	].

	^ shaderBinding
]

{ #category : #initialization }
WDBBabylonTextureArrayElementMaterial >> validTexture [
]
