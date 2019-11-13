"
I hold the vertex data of a mesh in separated data channel. I am a structure-of-arrays (SoA) style implementation for vertex buffers.

I am an implicit version in terms of abstracting the task of packing the data accesses from the user.
"
Class {
	#name : #WDCMeshImplicitSeparatedVertexData,
	#superclass : #WDCAbstractMeshVertexData,
	#instVars : [
		'channels',
		'vertexCount',
		'packedBufferOffsets',
		'packedDataInSingleBuffer',
		'hasVertexColors',
		'hasVertexTangents',
		'hasNormals'
	],
	#classVars : [
		'VertexChannelDescriptions'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #initialization }
WDCMeshImplicitSeparatedVertexData class >> initialize [
	super initialize.
	VertexChannelDescriptions := Dictionary new.
	
	{ 
		WDCStructureField name: #positions typeNamed: #float3 binding: 0.
		WDCStructureField name: #texcoords typeNamed: #float2 binding: 1.
		WDCStructureField name: #colors typeNamed: #float4 binding: 2.
		WDCStructureField name: #normals typeNamed: #float3 binding: 3.
		WDCStructureField name: #tangents4 typeNamed: #float4 binding: 4.
		WDCStructureField name: #boneWeights typeNamed: #R16G16B16A16_UNORM binding: 5.
		WDCStructureField name: #boneIndices typeNamed: #R16G16B16A16_SINT binding: 6.
	} do: [ :field |
		VertexChannelDescriptions at: field name put: field
	]
]

{ #category : #'as yet unclassified' }
WDCMeshImplicitSeparatedVertexData class >> vertexChannelDescriptions [
	^ VertexChannelDescriptions

]

{ #category : #adding }
WDCMeshImplicitSeparatedVertexData >> addChannelNamed: channelName withNativeData: data [
	| description channel |
	description := VertexChannelDescriptions at: channelName.
	channel := WDCMeshImplicitVertexChannel new description: description; data: data.
	channels := channels , { channel }
]

{ #category : #adding }
WDCMeshImplicitSeparatedVertexData >> addChannelNativeColors: data [
	^ self addChannelNamed: #colors withNativeData: data
]

{ #category : #adding }
WDCMeshImplicitSeparatedVertexData >> addChannelNativeNormals: data [
	^ self addChannelNamed: #normals withNativeData: data
]

{ #category : #adding }
WDCMeshImplicitSeparatedVertexData >> addChannelNativePositions: data [
	^ self addChannelNamed: #positions withNativeData: data
]

{ #category : #adding }
WDCMeshImplicitSeparatedVertexData >> addChannelNativeTangents4: data [
	^ self addChannelNamed: #tangents4 withNativeData: data
]

{ #category : #adding }
WDCMeshImplicitSeparatedVertexData >> addChannelNativeTexcoords: data [
	^ self addChannelNamed: #texcoords withNativeData: data
]

{ #category : #accessing }
WDCMeshImplicitSeparatedVertexData >> channels [
	^ channels
]

{ #category : #accessing }
WDCMeshImplicitSeparatedVertexData >> channels: anObject [
	channels := anObject
]

{ #category : #'channel accessing' }
WDCMeshImplicitSeparatedVertexData >> colors [
	^ self findChannelDataNamed: #colors
]

{ #category : #rendering }
WDCMeshImplicitSeparatedVertexData >> createVertexBindingFor: anEngine [
	| result vertexLayout vertexBuffers |
	vertexLayout := anEngine vertexLayoutForVertexChannelDescriptions: (channels collect: #description).
	result := anEngine createVertexBindingForLayout: vertexLayout.

	vertexBuffers := self createVertexsBufferFor: anEngine.
	result vertexBuffers: vertexBuffers offsets: packedBufferOffsets.
	^ result
]

{ #category : #rendering }
WDCMeshImplicitSeparatedVertexData >> createVertexsBufferFor: anEngine [
	| data packedBuffer |
	data := self packedDataInSingleBuffer.
	packedBuffer := anEngine createVertex: 1 elements: data size immutableBuffer: data.
	^ packedBufferOffsets collect: [ :o | packedBuffer ]
]

{ #category : #'channel accessing' }
WDCMeshImplicitSeparatedVertexData >> findChannelDataNamed: aChannelName [
	^ (self findChannelNamed: aChannelName) ifNotNil: [ :channel | channel data ]
]

{ #category : #'channel accessing' }
WDCMeshImplicitSeparatedVertexData >> findChannelNamed: aChannelName [
	channels do: [ :channel | 
		channel name = aChannelName ifTrue: [ ^ channel ]
	].
	^ nil
]

{ #category : #adding }
WDCMeshImplicitSeparatedVertexData >> generateEmptyTexcoords [
	| description vectorClass channelData |
	description := VertexChannelDescriptions at: #texcoords.

	vectorClass := description type slvmType.
	
	vectorClass ifNil: [
		self error: 'Cannot decoded channel without an associated class.'
	].
	
	channelData := SLVMNativeArray for: vectorClass new: vertexCount.
	self addChannelNativeTexcoords: channelData
]

{ #category : #adding }
WDCMeshImplicitSeparatedVertexData >> generateWhiteColorChannel [
	| description vectorClass channelData white |
	description := VertexChannelDescriptions at: #colors.

	vectorClass := description type slvmType.
	
	vectorClass ifNil: [
		self error: 'Cannot decoded channel without an associated class.'
	].
	
	channelData := SLVMNativeArray for: vectorClass new: vertexCount.
	white := vectorClass x: 1.0 y: 1.0 z: 1.0 w: 1.0.
	1 to: vertexCount do: [ :i | channelData at: i put: white ].
	self addChannelNativeColors: channelData
]

{ #category : #adding }
WDCMeshImplicitSeparatedVertexData >> generateZeroNormals [
	| description vectorClass channelData |
	description := VertexChannelDescriptions at: #normals.

	vectorClass := description type slvmType.
	
	vectorClass ifNil: [
		self error: 'Cannot decoded channel without an associated class.'
	].
	
	channelData := SLVMNativeArray for: vectorClass new: vertexCount.
	self addChannelNativeNormals: channelData
]

{ #category : #testing }
WDCMeshImplicitSeparatedVertexData >> hasVertexColors [
	^ hasVertexColors ifNil: [ hasVertexColors := self colors isNotNil ]
]

{ #category : #testing }
WDCMeshImplicitSeparatedVertexData >> hasVertexNormals [
	^ hasNormals ifNil: [ hasNormals := self normals isNotNil ]
]

{ #category : #testing }
WDCMeshImplicitSeparatedVertexData >> hasVertexTangents [
	^ hasVertexTangents ifNil: [ hasVertexTangents := self tangents4 isNotNil ]
]

{ #category : #initialization }
WDCMeshImplicitSeparatedVertexData >> initialize [
	super initialize.
	channels := #().
	
]

{ #category : #'channel accessing' }
WDCMeshImplicitSeparatedVertexData >> normals [
	^ self findChannelDataNamed: #normals
]

{ #category : #accessing }
WDCMeshImplicitSeparatedVertexData >> packedDataInSingleBuffer [
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

{ #category : #'channel accessing' }
WDCMeshImplicitSeparatedVertexData >> positions [
	^ self findChannelDataNamed: #positions
]

{ #category : #accessing }
WDCMeshImplicitSeparatedVertexData >> size [
	^ vertexCount
]

{ #category : #sorting }
WDCMeshImplicitSeparatedVertexData >> sortChannels [
	channels sort: [ :a :b | a binding <= b binding ]
]

{ #category : #'channel accessing' }
WDCMeshImplicitSeparatedVertexData >> tangents4 [
	^ self findChannelDataNamed: #tangents4
]

{ #category : #'channel accessing' }
WDCMeshImplicitSeparatedVertexData >> texcoords [
	^ self findChannelDataNamed: #texcoords
]

{ #category : #accessing }
WDCMeshImplicitSeparatedVertexData >> vertexCount [
	^ vertexCount
]

{ #category : #accessing }
WDCMeshImplicitSeparatedVertexData >> vertexCount: anObject [
	vertexCount := anObject
]
