Class {
	#name : #WDCSplittedVertexData,
	#superclass : #Object,
	#instVars : [
		'channels',
		'vertexCount',
		'packedBufferOffsets',
		'packedDataInSingleBuffer'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #accessing }
WDCSplittedVertexData >> channels [
	^ channels
]

{ #category : #accessing }
WDCSplittedVertexData >> channels: anObject [
	channels := anObject
]

{ #category : #accessing }
WDCSplittedVertexData >> colors [
	^ self findChannelDataNamed: #colors
]

{ #category : #'as yet unclassified' }
WDCSplittedVertexData >> createVertexBindingFor: anEngine [
	| result vertexLayout vertexBuffers |
	vertexLayout := anEngine vertexLayoutForVertexChannelDescriptions: (channels collect: #description).
	result := anEngine createVertexBindingForLayout: vertexLayout.

	vertexBuffers := self createVertexsBufferFor: anEngine.
	result vertexBuffers: vertexBuffers offsets: packedBufferOffsets.
	^ result
]

{ #category : #'as yet unclassified' }
WDCSplittedVertexData >> createVertexsBufferFor: anEngine [
	| data packedBuffer |
	data := self packedDataInSingleBuffer.
	packedBuffer := anEngine createVertex: 1 elements: data size immutableBuffer: data.
	^ packedBufferOffsets collect: [ :o | packedBuffer ]
]

{ #category : #'as yet unclassified' }
WDCSplittedVertexData >> findChannelDataNamed: aChannelName [
	^ (self findChannelNamed: aChannelName) ifNotNil: [ :channel | channel data ]
]

{ #category : #'as yet unclassified' }
WDCSplittedVertexData >> findChannelNamed: aChannelName [
	channels do: [ :channel | 
		channel name = aChannelName ifTrue: [ ^ channel ]
	].
	^ nil
]

{ #category : #'as yet unclassified' }
WDCSplittedVertexData >> normals [
	^ self findChannelDataNamed: #normals
]

{ #category : #accessing }
WDCSplittedVertexData >> packedDataInSingleBuffer [
	| packedBufferSize channelOffset packedBufferAlignment |
	packedDataInSingleBuffer ifNotNil: [ ^ packedDataInSingleBuffer ].
	
	"Compute the total size of the packed buffer, and the offsets of the different parts."
	packedBufferSize := 0.
	packedBufferAlignment := 1.
	
	packedBufferOffsets := channels collect: [ :channel |
		packedBufferAlignment := packedBufferAlignment max: channel alignment.

		channelOffset := packedBufferSize alignedTo: channel alignment.
		packedBufferSize := channelOffset + channel byteSize.
		channelOffset
	].
	packedBufferSize := packedBufferSize alignedTo: packedBufferAlignment.

	packedDataInSingleBuffer := ByteArray new: packedBufferSize.
	channels doWithIndex: [ :channel :index |
		channelOffset := packedBufferOffsets at: index.
		packedDataInSingleBuffer replaceFrom: 1 + channelOffset to: channelOffset + channel byteSize with: channel bytes startingAt: 1 
	].
	^ packedDataInSingleBuffer
]

{ #category : #accessing }
WDCSplittedVertexData >> positions [
	^ self findChannelDataNamed: #positions
]

{ #category : #accessing }
WDCSplittedVertexData >> size [
	^ vertexCount
]

{ #category : #'as yet unclassified' }
WDCSplittedVertexData >> tangents4 [
	^ self findChannelDataNamed: #tangents4
]

{ #category : #'as yet unclassified' }
WDCSplittedVertexData >> texcoords [
	^ self findChannelDataNamed: #texcoords
]

{ #category : #accessing }
WDCSplittedVertexData >> vertexCount [
	^ vertexCount
]

{ #category : #accessing }
WDCSplittedVertexData >> vertexCount: anObject [
	vertexCount := anObject
]
