Class {
	#name : #WDIGLTF2Image,
	#superclass : #Object,
	#instVars : [
		'imageData',
		'imageReader',
		'form',
		'name'
	],
	#pools : [
		'WDIGLTF2Constants'
	],
	#category : #'WodenEngine-Importers-GLTF'
}

{ #category : #converting }
WDIGLTF2Image >> asWodenNormalTexture [
	self isRenderTargetImage ifTrue: [ 
		^ self renderTargetDescription asWodenNormalTexture
	].

	^ self form asWodenNormalTexture
]

{ #category : #converting }
WDIGLTF2Image >> asWodenSRGBTexture [
	self isRenderTargetImage ifTrue: [ 
		^ self renderTargetDescription asWodenSRGBTexture
	].
	^ self form asWodenSRGBTexture
]

{ #category : #converting }
WDIGLTF2Image >> asWodenTexture [
	self isRenderTargetImage ifTrue: [ 
		^ self renderTargetDescription asWodenTexture
	].

	^ self form asWodenTexture
]

{ #category : #'as yet unclassified' }
WDIGLTF2Image >> cachingKey [
	^ { imageReader class name . imageData readStream }
]

{ #category : #converting }
WDIGLTF2Image >> extent [
	^ self form extent
]

{ #category : #'as yet unclassified' }
WDIGLTF2Image >> form [
	^ form ifNil: [form := imageReader loadFromStream: imageData readStream].
]

{ #category : #accessing }
WDIGLTF2Image >> imageData [
	^ imageData
]

{ #category : #accessing }
WDIGLTF2Image >> imageData: anObject [
	imageData := anObject
]

{ #category : #accessing }
WDIGLTF2Image >> imageReader [
	^ imageReader
]

{ #category : #accessing }
WDIGLTF2Image >> imageReader: anObject [
	imageReader := anObject
]

{ #category : #initialization }
WDIGLTF2Image >> initialize [
	super initialize.
	name := ''.
]

{ #category : #testing }
WDIGLTF2Image >> isRenderTargetImage [
	^ name beginsWith: '$'
]

{ #category : #accessing }
WDIGLTF2Image >> name [
	^ name
]

{ #category : #accessing }
WDIGLTF2Image >> name: anObject [
	name := anObject
]

{ #category : #converting }
WDIGLTF2Image >> renderTargetDescription [
	self assert: self isRenderTargetImage.
	^ WDCRenderTargetTextureDescription new
		name: name;
		extent: self extent;
		yourself
]
