"
I represent an array of structures style representation for vertex data.
"
Class {
	#name : #WDCInterleavedVertexData,
	#superclass : #WDCAbstractMeshVertexData,
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #'as yet unclassified' }
WDCInterleavedVertexData >> createVertexBindingFor: anEngine [
	| result vertexLayout |
	vertexLayout := anEngine vertexLayoutFor: vertexClass.
	result := anEngine createVertexBindingForLayout: vertexLayout.
	result vertexBuffers: { self createVertexBufferFor: anEngine }; offsets: { 0 }.
	^ result
]

{ #category : #'as yet unclassified' }
WDCInterleavedVertexData >> createVertexBufferFor: anEngine [
	^ anEngine createVertex: data elementSize elements: data size immutableBuffer: data rawData 
]

{ #category : #accessing }
WDCInterleavedVertexData >> data [
	^ data
]

{ #category : #accessing }
WDCInterleavedVertexData >> data: anObject [
	data := anObject
]

{ #category : #accessing }
WDCInterleavedVertexData >> size [
	^ data ifNil: [ 0 ] ifNotNil: [ data size ]
]

{ #category : #accessing }
WDCInterleavedVertexData >> vertexClass [
	^ vertexClass
]

{ #category : #accessing }
WDCInterleavedVertexData >> vertexClass: anObject [
	vertexClass := anObject
]
