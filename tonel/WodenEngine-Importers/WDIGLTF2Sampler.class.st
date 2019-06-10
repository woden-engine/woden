Class {
	#name : #WDIGLTF2Sampler,
	#superclass : #Object,
	#instVars : [
		'minFilter',
		'magFilter',
		'wrapS',
		'wrapT'
	],
	#pools : [
		'WDIGLTF2Constants'
	],
	#category : #'WodenEngine-Importers-GLTF'
}

{ #category : #accessing }
WDIGLTF2Sampler >> magFilter [
	^ magFilter
]

{ #category : #accessing }
WDIGLTF2Sampler >> magFilter: anObject [
	magFilter := anObject
]

{ #category : #accessing }
WDIGLTF2Sampler >> minFilter [
	^ minFilter
]

{ #category : #accessing }
WDIGLTF2Sampler >> minFilter: anObject [
	minFilter := anObject
]

{ #category : #accessing }
WDIGLTF2Sampler >> wrapS [
	^ wrapS
]

{ #category : #accessing }
WDIGLTF2Sampler >> wrapS: anObject [
	wrapS := anObject
]

{ #category : #accessing }
WDIGLTF2Sampler >> wrapT [
	^ wrapT
]

{ #category : #accessing }
WDIGLTF2Sampler >> wrapT: anObject [
	wrapT := anObject
]
