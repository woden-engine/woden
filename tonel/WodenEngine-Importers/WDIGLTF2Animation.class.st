Class {
	#name : #WDIGLTF2Animation,
	#superclass : #Object,
	#instVars : [
		'samplers',
		'channels',
		'name'
	],
	#category : #'WodenEngine-Importers-GLTF'
}

{ #category : #converting }
WDIGLTF2Animation >> asModelAssetAnimation [
	^ WDCSkinnedModelAnimation new
		name: name;
		channels: (channels collect: [ :each | each asSkinnedModelAnimationChannel ]);
		yourself
]

{ #category : #accessing }
WDIGLTF2Animation >> channels [
	^ channels
]

{ #category : #accessing }
WDIGLTF2Animation >> channels: anObject [
	channels := anObject
]

{ #category : #accessing }
WDIGLTF2Animation >> name [
	^ name
]

{ #category : #accessing }
WDIGLTF2Animation >> name: anObject [
	name := anObject
]

{ #category : #accessing }
WDIGLTF2Animation >> samplers [
	^ samplers
]

{ #category : #accessing }
WDIGLTF2Animation >> samplers: anObject [
	samplers := anObject
]
