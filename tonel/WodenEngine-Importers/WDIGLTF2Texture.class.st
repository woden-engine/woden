Class {
	#name : #WDIGLTF2Texture,
	#superclass : #Object,
	#instVars : [
		'image',
		'sampler',
		'srgbTexture',
		'normalTexture',
		'texture'
	],
	#pools : [
		'WDIGLTF2Constants'
	],
	#category : #'WodenEngine-Importers-GLTF'
}

{ #category : #converting }
WDIGLTF2Texture >> asNormalTexture [
	^ normalTexture ifNil: [ normalTexture := image asWodenNormalTexture ]
]

{ #category : #converting }
WDIGLTF2Texture >> asSRGBTexture [
	^ srgbTexture ifNil: [ srgbTexture := image asWodenSRGBTexture ]
]

{ #category : #converting }
WDIGLTF2Texture >> asTexture [
	^ texture ifNil: [ texture := image asWodenTexture ]
]

{ #category : #accessing }
WDIGLTF2Texture >> image [
	^ image
]

{ #category : #accessing }
WDIGLTF2Texture >> image: anObject [
	image := anObject
]

{ #category : #accessing }
WDIGLTF2Texture >> sampler [
	^ sampler
]

{ #category : #accessing }
WDIGLTF2Texture >> sampler: anObject [
	sampler := anObject
]
