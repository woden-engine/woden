Class {
	#name : #WDCMeshExplicitSeparatedVertexData,
	#superclass : #WDCAbstractMeshVertexData,
	#instVars : [
		'channels',
		'vertexCount',
		'hasVertexTangents'
	],
	#pools : [
		'AGPUConstants',
		'WDCVertexBindingConstants'
	],
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #adding }
WDCMeshExplicitSeparatedVertexData >> addChannel: aChannel [
	channels := channels copyWith: aChannel.
	hasVertexTangents := nil.
]

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
WDCMeshExplicitSeparatedVertexData >> engine: anEngine [
	channels do: [ :channel | channel engine: anEngine ]
]

{ #category : #testing }
WDCMeshExplicitSeparatedVertexData >> getChannelWithVertexBindingLocation: aLocation [
	channels do: [ :channel |
		channel binding = aLocation ifTrue: [ ^ channel ]
	].

	^ nil
]

{ #category : #testing }
WDCMeshExplicitSeparatedVertexData >> hasChannelWithVertexBindingLocation: aLocation [
	channels do: [ :channel |
		channel binding = aLocation ifTrue: [ ^ true ]
	].

	^ false
]

{ #category : #testing }
WDCMeshExplicitSeparatedVertexData >> hasVertexTangents [
	^ hasVertexTangents ifNil: [hasVertexTangents := self hasChannelWithVertexBindingLocation: Tangents4VertexBindingLocation]
]

{ #category : #testing }
WDCMeshExplicitSeparatedVertexData >> normalsChannel [
	^ self getChannelWithVertexBindingLocation: NormalsVertexBindingLocation
]

{ #category : #testing }
WDCMeshExplicitSeparatedVertexData >> positionsChannel [
	^ self getChannelWithVertexBindingLocation: PositionsVertexBindingLocation
]

{ #category : #testing }
WDCMeshExplicitSeparatedVertexData >> texcoordsChannel [
	^ self getChannelWithVertexBindingLocation: TexcoordsVertexBindingLocation
]

{ #category : #accessing }
WDCMeshExplicitSeparatedVertexData >> vertexCount [
	^ vertexCount
]

{ #category : #accessing }
WDCMeshExplicitSeparatedVertexData >> vertexCount: anObject [
	vertexCount := anObject
]
