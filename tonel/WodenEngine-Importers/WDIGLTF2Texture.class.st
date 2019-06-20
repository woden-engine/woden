Class {
	#name : #WDIGLTF2Texture,
	#superclass : #Object,
	#instVars : [
		'image',
		'sampler',
		'srgbTexture',
		'normalTexture',
		'texture',
		'combinedWithAODictionary'
	],
	#pools : [
		'WDIGLTF2Constants'
	],
	#category : #'WodenEngine-Importers-GLTF'
}

{ #category : #converting }
WDIGLTF2Texture >> asMetallicRoughnessTextureCombinedWithAO: ambientOcclusionTexture [
	| rawForm combinedData texelCount currentIndex combinedForm rawAOForm aoData resultTexture |
	ambientOcclusionTexture == self ifTrue: [
		^ self asTexture
	].

	self combinedWithAODictionary at: ambientOcclusionTexture ifPresent: [ :combined | ^ combined ].
	
	rawForm := image form.
	self assert: rawForm depth = 32.
	texelCount := rawForm width * rawForm height.
	combinedData := ByteArray new: texelCount * 4.
	rawForm unhibernate.
	LibC memCopy: rawForm bits to: combinedData size: combinedData size.

	(ambientOcclusionTexture isNotNil and:
	[ ambientOcclusionTexture image form extent = rawForm extent and:
	[ ambientOcclusionTexture image form depth = 32 ] ]) ifTrue: [ 
		rawAOForm := ambientOcclusionTexture image form.
		aoData := ByteArray new: texelCount * 4.
		rawAOForm unhibernate.
		LibC memCopy: rawAOForm bits to: aoData size: aoData size.
		
		currentIndex := 1.
		1 to: texelCount do: [ :i |
			combinedData at: currentIndex + 2 put: (aoData at: currentIndex + 2).
			currentIndex := currentIndex + 4
		].
	] ifFalse: [ 
		currentIndex := 1.
		1 to: texelCount do: [ :i |
			combinedData at: currentIndex + 2 put: 16rff.
			currentIndex := currentIndex + 4
		].

	].

	"Create the form with the combined data."
	combinedForm := Form extent: rawForm extent depth: 32.
	combinedForm unhibernate.
	LibC memCopy: combinedData to: combinedForm bits size: combinedData size.

	resultTexture := combinedForm asWodenTexture.
	self combinedWithAODictionary at: ambientOcclusionTexture put: resultTexture.
	^ resultTexture
]

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

{ #category : #converting }
WDIGLTF2Texture >> combinedWithAODictionary [
	^ combinedWithAODictionary ifNil: [ combinedWithAODictionary := Dictionary new ]
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
