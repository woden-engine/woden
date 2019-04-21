Class {
	#name : #WDCMeshExplicitSeparatedVertexData,
	#superclass : #WDCAbstractMeshVertexData,
	#instVars : [
		'channels',
		'vertexCount'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #accessing }
WDCMeshExplicitSeparatedVertexData >> channels [
	^ channels
]

{ #category : #accessing }
WDCMeshExplicitSeparatedVertexData >> channels: anObject [
	channels := anObject
]

{ #category : #'gpu binding resources' }
WDCMeshExplicitSeparatedVertexData >> createVertexBindingFor: anEngine [
	| vertexLayout result |
	vertexLayout := anEngine vertexLayoutForVertexChannelDescriptions: (channels collect: #description).
	result := anEngine createVertexBindingForLayout: vertexLayout.

	result vertexBuffers: (channels collect: #vertexBuffer)
		offsets: (channels collect: #vertexBufferOffset).
	^ result
]

{ #category : #'as yet unclassified' }
WDCMeshExplicitSeparatedVertexData >> engineChangedTo: anEngine [
	channels do: [ :channel | channel engineChangedTo: anEngine ]
]

{ #category : #accessing }
WDCMeshExplicitSeparatedVertexData >> vertexCount [
	^ vertexCount
]

{ #category : #accessing }
WDCMeshExplicitSeparatedVertexData >> vertexCount: anObject [
	vertexCount := anObject
]
