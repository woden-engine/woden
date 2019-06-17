Class {
	#name : #WDIGLTF2Image,
	#superclass : #Object,
	#instVars : [
		'imageData',
		'imageReader',
		'form'
	],
	#pools : [
		'WDIGLTF2Constants'
	],
	#category : #'WodenEngine-Importers-GLTF'
}

{ #category : #converting }
WDIGLTF2Image >> asWodenNormalTexture [
	^ self form asWodenNormalTexture
]

{ #category : #converting }
WDIGLTF2Image >> asWodenSRGBTexture [
	^ self form asWodenSRGBTexture
]

{ #category : #converting }
WDIGLTF2Image >> asWodenTexture [
	^ self form asWodenTexture
]

{ #category : #'as yet unclassified' }
WDIGLTF2Image >> cachingKey [
	^ { imageReader class name . imageData readStream }
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
