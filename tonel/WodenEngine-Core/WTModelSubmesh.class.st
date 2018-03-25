Class {
	#name : #WTModelSubmesh,
	#superclass : #Object,
	#instVars : [
		'firstIndex',
		'indexCount',
		'primitiveType',
		'material'
	],
	#category : 'WodenEngine-Core-Mesh'
}

{ #category : #'as yet unclassified' }
WTModelSubmesh >> actualMaterialFor: anEngine [
	material isString ifTrue: [ ^ anEngine resourceCache loadMaterial: material ].
	^ material
]

{ #category : #accessing }
WTModelSubmesh >> firstIndex [
	^ firstIndex
]

{ #category : #accessing }
WTModelSubmesh >> firstIndex: anObject [
	firstIndex := anObject
]

{ #category : #accessing }
WTModelSubmesh >> indexCount [
	^ indexCount
]

{ #category : #accessing }
WTModelSubmesh >> indexCount: anObject [
	indexCount := anObject
]

{ #category : #accessing }
WTModelSubmesh >> material [
	^ material
]

{ #category : #accessing }
WTModelSubmesh >> material: anObject [
	material := anObject
]

{ #category : #accessing }
WTModelSubmesh >> primitiveType [
	^ primitiveType
]

{ #category : #accessing }
WTModelSubmesh >> primitiveType: anObject [
	primitiveType := anObject
]

{ #category : #'as yet unclassified' }
WTModelSubmesh >> subMeshFor: anEngine [
	^ WTGenericSubmesh new
		firstIndex: firstIndex;
		indexCount: indexCount;
		primitiveType: primitiveType;
		material: (self actualMaterialFor: anEngine);
		yourself.
]
