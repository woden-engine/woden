Class {
	#name : #WDIGLTF2Skin,
	#superclass : #Object,
	#instVars : [
		'name',
		'inverseBindMatrices',
		'jointIndices',
		'rootNodeIndex',
		'inverseBindMatricesAccessor',
		'armature',
		'jointIndexToBoneIndexPermutationTable'
	],
	#pools : [
		'WDIGLTF2Constants'
	],
	#category : #'WodenEngine-Importers-GLTF'
}

{ #category : #accessing }
WDIGLTF2Skin >> armature [
	^ armature ifNil: [ armature := WDCSkinnedModelArmature new name: name ]
]

{ #category : #'as yet unclassified' }
WDIGLTF2Skin >> fetchInverseBindMatrices [
	^ inverseBindMatricesAccessor decodeContentAsArray
]

{ #category : #accessing }
WDIGLTF2Skin >> inverseBindMatrices [
	^ inverseBindMatrices ifNil: [ inverseBindMatrices := self fetchInverseBindMatrices ]
]

{ #category : #accessing }
WDIGLTF2Skin >> inverseBindMatricesAccessor [
	^ inverseBindMatricesAccessor
]

{ #category : #accessing }
WDIGLTF2Skin >> inverseBindMatricesAccessor: anObject [
	inverseBindMatricesAccessor := anObject
]

{ #category : #accessing }
WDIGLTF2Skin >> jointIndexToBoneIndexPermutationTable [
	^ jointIndexToBoneIndexPermutationTable
]

{ #category : #accessing }
WDIGLTF2Skin >> jointIndexToBoneIndexPermutationTable: anObject [
	jointIndexToBoneIndexPermutationTable := anObject
]

{ #category : #accessing }
WDIGLTF2Skin >> jointIndices [
	^ jointIndices
]

{ #category : #accessing }
WDIGLTF2Skin >> jointIndices: anObject [
	jointIndices := anObject
]

{ #category : #accessing }
WDIGLTF2Skin >> name [
	^ name
]

{ #category : #accessing }
WDIGLTF2Skin >> name: anObject [
	name := anObject
]

{ #category : #'as yet unclassified' }
WDIGLTF2Skin >> permutatedInverseBindMatrices [
	| permutatedMatrices |
	permutatedMatrices := Array new: jointIndices size.
	self inverseBindMatrices doWithIndex: [ :each :index |
		permutatedMatrices at: (jointIndexToBoneIndexPermutationTable at: index) + 1 put: each
	].
	^ permutatedMatrices
]

{ #category : #accessing }
WDIGLTF2Skin >> rootNodeIndex [
	^ rootNodeIndex
]

{ #category : #accessing }
WDIGLTF2Skin >> rootNodeIndex: anObject [
	rootNodeIndex := anObject
]
