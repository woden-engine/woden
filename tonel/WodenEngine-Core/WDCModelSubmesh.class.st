Class {
	#name : #WDCModelSubmesh,
	#superclass : #Object,
	#instVars : [
		'firstIndex',
		'indexCount',
		'primitiveType',
		'material'
	],
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #'as yet unclassified' }
WDCModelSubmesh >> actualMaterialFor: anEngine [
	material isString ifTrue: [ ^ anEngine resourceCache loadMaterial: material ].
	material isMaterialDescription ifTrue: [ ^ material concreteMaterialFor: anEngine ].
	^ material
]

{ #category : #accessing }
WDCModelSubmesh >> firstIndex [
	^ firstIndex
]

{ #category : #accessing }
WDCModelSubmesh >> firstIndex: anObject [
	firstIndex := anObject
]

{ #category : #accessing }
WDCModelSubmesh >> indexCount [
	^ indexCount
]

{ #category : #accessing }
WDCModelSubmesh >> indexCount: anObject [
	indexCount := anObject
]

{ #category : #accessing }
WDCModelSubmesh >> material [
	^ material
]

{ #category : #accessing }
WDCModelSubmesh >> material: anObject [
	material := anObject
]

{ #category : #accessing }
WDCModelSubmesh >> primitiveType [
	^ primitiveType
]

{ #category : #accessing }
WDCModelSubmesh >> primitiveType: anObject [
	primitiveType := anObject
]

{ #category : #'as yet unclassified' }
WDCModelSubmesh >> subMeshFor: anEngine [
	^ WDCGenericSubmesh new
		firstIndex: firstIndex;
		indexCount: indexCount;
		primitiveType: primitiveType;
		material: (self actualMaterialFor: anEngine);
		yourself.
]
