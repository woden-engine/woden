Class {
	#name : #WDIGLTF2SkeletonGraphNode,
	#superclass : #Object,
	#instVars : [
		'parent',
		'bone'
	],
	#pools : [
		'WDIGLTF2Constants'
	],
	#category : #'WodenEngine-Importers-GLTF'
}

{ #category : #accessing }
WDIGLTF2SkeletonGraphNode >> bone [

	^ bone
]

{ #category : #accessing }
WDIGLTF2SkeletonGraphNode >> bone: anObject [

	bone := anObject
]

{ #category : #accessing }
WDIGLTF2SkeletonGraphNode >> parent [

	^ parent
]

{ #category : #accessing }
WDIGLTF2SkeletonGraphNode >> parent: anObject [

	parent := anObject
]
