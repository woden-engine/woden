Class {
	#name : #WTAthensBasicMeshPathBuilderBackend,
	#superclass : #WTAthensMeshPathBuilderBackend,
	#instVars : [
		'vertices',
		'indices'
	],
	#category : 'Woden2-Athens'
}

{ #category : #adding }
WTAthensBasicMeshPathBuilderBackend >> addIndex: anIndex [
	indices add: anIndex
]

{ #category : #initialization }
WTAthensBasicMeshPathBuilderBackend >> initialize [
	super initialize.
	vertices := SLVMNativeOrderedCollection for: self vertexType.
	indices := SLVMNativeOrderedCollection for: #int.

]

{ #category : #'as yet unclassified' }
WTAthensBasicMeshPathBuilderBackend >> numberOfVertices [
	^ vertices size.
]

{ #category : #adding }
WTAthensBasicMeshPathBuilderBackend >> primitiveAddVertex: aPoint [
	vertices add: aPoint asWMVector2F.
]

{ #category : #'as yet unclassified' }
WTAthensBasicMeshPathBuilderBackend >> vertexType [
	^ WMVector2F
]
