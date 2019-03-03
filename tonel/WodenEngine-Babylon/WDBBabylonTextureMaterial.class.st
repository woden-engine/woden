Class {
	#name : #WDBBabylonTextureMaterial,
	#superclass : #BabylonTextureMaterial,
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
WDBBabylonTextureMaterial >> driver [
	^ driver
]

{ #category : #accessing }
WDBBabylonTextureMaterial >> driver: anObject [
	driver := anObject
]

{ #category : #initialization }
WDBBabylonTextureMaterial >> forBabylonDriver: aDriver [
	^ self
]

{ #category : #initialization }
WDBBabylonTextureMaterial >> initialize [
	super initialize.
	modified := true
]

{ #category : #initialization }
WDBBabylonTextureMaterial >> modified [
	modified := true
]

{ #category : #initialization }
WDBBabylonTextureMaterial >> updateShaderBinding [
	texture ifNil: [ ^ self ].
	shaderBinding ifNil: [ ^ self ].
	shaderBinding bind: 0 texture: texture
]

{ #category : #initialization }
WDBBabylonTextureMaterial >> validShaderBinding [
	shaderBinding ifNil: [
		shaderBinding := (WDBBabylonShaderSignature for: driver engine) newTexture.
		self updateShaderBinding
	].

	^ shaderBinding
]

{ #category : #initialization }
WDBBabylonTextureMaterial >> validTexture [
]
