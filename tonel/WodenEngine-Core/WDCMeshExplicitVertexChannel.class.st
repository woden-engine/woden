Class {
	#name : #WDCMeshExplicitVertexChannel,
	#superclass : #WDCAbstractMeshVertexChannel,
	#instVars : [
		'binding',
		'accessor'
	],
	#classVars : [
		'BindingNameMap'
	],
	#pools : [
		'AGPUConstants',
		'WDCVertexBindingConstants'
	],
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #'as yet unclassified' }
WDCMeshExplicitVertexChannel class >> getBindingNamed: bindingName [
	^ BindingNameMap at: bindingName
]

{ #category : #'as yet unclassified' }
WDCMeshExplicitVertexChannel class >> getBindingNamed: bindingName ifAbsent: aBlock [
	^ BindingNameMap at: bindingName ifAbsent: aBlock
]

{ #category : #'class initialization' }
WDCMeshExplicitVertexChannel class >> initialize [
	
	BindingNameMap := Dictionary newFromPairs: #(
		#positions 0
		#texcoords 1
		#colors 2
		#normals 3
		#tangents4 4
		#boneWeights 5
		#boneIndices 6
		
		"For glTF"
		'POSITION' 0
		'TEXCOORD_0' 1
		'COLOR_0' 2
		'NORMAL' 3
		'TANGENT' 4
		'WEIGHTS_0' 5
		'JOINTS_0' 6
		
		'TEXCOORD_1' 7
	).
]

{ #category : #comparing }
WDCMeshExplicitVertexChannel >> = other [
	^ self class == other class and:
	[ binding = other and:
	[ accessor == other accessor ]]
]

{ #category : #accessing }
WDCMeshExplicitVertexChannel >> accessor [
	^ accessor
]

{ #category : #accessing }
WDCMeshExplicitVertexChannel >> accessor: anObject [
	accessor := anObject
]

{ #category : #converting }
WDCMeshExplicitVertexChannel >> asNativeArrayReference [
	^ accessor asNativeArrayReference
]

{ #category : #accessing }
WDCMeshExplicitVertexChannel >> binding [
	^ binding
]

{ #category : #accessing }
WDCMeshExplicitVertexChannel >> binding: anObject [
	binding := anObject
]

{ #category : #accessing }
WDCMeshExplicitVertexChannel >> description [
	^ WDCStructureField new
		type: accessor type;
		binding: binding;
		offset: 0;
		yourself
]

{ #category : #'as yet unclassified' }
WDCMeshExplicitVertexChannel >> engine: anEngine [
	accessor engine: anEngine
]

{ #category : #comparing }
WDCMeshExplicitVertexChannel >> hash [
	^ self class identityHash bitXor: (binding hash bitXor: accessor identityHash)
]

{ #category : #'as yet unclassified' }
WDCMeshExplicitVertexChannel >> vertexBuffer [
	^ accessor bufferView buffer
]

{ #category : #'as yet unclassified' }
WDCMeshExplicitVertexChannel >> vertexBufferOffset [
	^ accessor bufferView offset + accessor byteOffset
]
