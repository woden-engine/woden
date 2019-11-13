"
I represent an array of structures style representation for vertex data.
"
Class {
	#name : #WDCMeshInterleavedVertexData,
	#superclass : #WDCAbstractMeshVertexData,
	#instVars : [
		'data',
		'vertexClass',
		'hasVertexColors',
		'hasVertexTangents',
		'hasNormals'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #'gpu binding resources' }
WDCMeshInterleavedVertexData >> createVertexBindingFor: anEngine [
	| result vertexLayout |
	vertexLayout := anEngine vertexLayoutFor: vertexClass.
	result := anEngine createVertexBindingForLayout: vertexLayout.
	result vertexBuffers: { self createVertexBufferFor: anEngine }; offsets: { 0 }.
	^ result
]

{ #category : #'gpu binding resources' }
WDCMeshInterleavedVertexData >> createVertexBufferFor: anEngine [
	^ anEngine createVertex: data elementSize elements: data size immutableBuffer: data rawData
]

{ #category : #accessing }
WDCMeshInterleavedVertexData >> data [
	^ data
]

{ #category : #accessing }
WDCMeshInterleavedVertexData >> data: anObject [
	data := anObject
]

{ #category : #testing }
WDCMeshInterleavedVertexData >> hasVertexColors [
	^ hasVertexColors ifNil: [ hasVertexColors := (vertexClass lookupSelector: #color) isNotNil ]
]

{ #category : #testing }
WDCMeshInterleavedVertexData >> hasVertexNormals [
	^ hasNormals ifNil: [ hasNormals := (vertexClass lookupSelector: #normal) isNotNil ]
]

{ #category : #testing }
WDCMeshInterleavedVertexData >> hasVertexTangents [ 
	^ hasVertexTangents ifNil: [ hasVertexTangents := (vertexClass lookupSelector: #tangent4) isNotNil ]
]

{ #category : #accessing }
WDCMeshInterleavedVertexData >> size [
	^ data ifNil: [ 0 ] ifNotNil: [ data size ]
]

{ #category : #accessing }
WDCMeshInterleavedVertexData >> vertexClass [
	^ vertexClass
]

{ #category : #accessing }
WDCMeshInterleavedVertexData >> vertexClass: anObject [
	vertexClass := anObject
]
