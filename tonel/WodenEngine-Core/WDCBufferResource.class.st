Class {
	#name : #WDCBufferResource,
	#superclass : #WDCResourceWithSessionHandle,
	#instVars : [
		'description',
		'data',
		'pointer'
	],
	#category : #'WodenEngine-Core-GPU-Resources'
}

{ #category : #'as yet unclassified' }
WDCBufferResource >> applyAsIndexBufferToCommandList: commandListBuilder [
	commandListBuilder useIndexBuffer: self validHandle
]

{ #category : #'as yet unclassified' }
WDCBufferResource >> asIndexBufferAccessor [
	^ WDCBufferAccessor new
		bufferView: self fullView;
		type: self indexBufferElementType;
		count: data size // description stride;
		byteOffset: 0;
		computeMinAndMax;
		yourself
]

{ #category : #'resource building' }
WDCBufferResource >> buildHandle [
	self assert: description isNotNil.
	handle := engine device createBuffer: description initial_data: self initialData.
	session := Smalltalk session.
	(description mapping_flags anyMask: AGPU_MAP_PERSISTENT_BIT) ifTrue: [ 
		pointer := handle mapBuffer: self defaultMappingMode.
		self assert: pointer isNull not.
		data isSessionPersistentExternalBuffer ifTrue: [
			data pointer: pointer size: description size
		].
	].

]

{ #category : #accessing }
WDCBufferResource >> data [
	^ data
]

{ #category : #accessing }
WDCBufferResource >> data: anObject [
	data := anObject
]

{ #category : #private }
WDCBufferResource >> defaultMappingMode [
	| flags readSupported writeSupported |
	flags := description mapping_flags.
	readSupported := flags anyMask: AGPU_MAP_READ_BIT.
	writeSupported := flags anyMask: AGPU_MAP_WRITE_BIT.
	(readSupported and: [ writeSupported ]) ifTrue: [ ^ AGPU_READ_WRITE ].
	readSupported ifTrue: [ ^ AGPU_READ_ONLY ].
	writeSupported ifTrue: [ ^ AGPU_WRITE_ONLY ].
	self error: 'trying to map a buffer that cannot be mapped.'
]

{ #category : #accessing }
WDCBufferResource >> description [
	^ description
]

{ #category : #accessing }
WDCBufferResource >> description: anObject [
	description := anObject
]

{ #category : #'resource building' }
WDCBufferResource >> destroy [
	(description mapping_flags anyMask: AGPU_MAP_PERSISTENT_BIT) ifTrue: [ 
		pointer := handle unmapBuffer.
		pointer := nil.
		handle := nil
	].

]

{ #category : #'as yet unclassified' }
WDCBufferResource >> fullView [
	^ WDCBufferView new
		buffer: self;
		offset: 0;
		length: description size;
		yourself
]

{ #category : #'as yet unclassified' }
WDCBufferResource >> indexBufferElementType [
	| stride |
	stride := description stride.
	stride = 1 ifTrue: [ ^ WDCStructureFieldType typeNamed: #byte ].
	stride = 2 ifTrue: [ ^ WDCStructureFieldType typeNamed: #ushort ].
	stride = 4 ifTrue: [ ^ WDCStructureFieldType typeNamed: #uint ].
	self error: 'Unsupported index type.'
]

{ #category : #'resource building' }
WDCBufferResource >> initialData [
	^ data isSessionPersistentExternalBuffer ifTrue: [ data data ] ifFalse: [ data ].
]

{ #category : #accessing }
WDCBufferResource >> pointer [
	^ pointer
]

{ #category : #accessing }
WDCBufferResource >> pointer: anObject [
	pointer := anObject
]

{ #category : #'as yet unclassified' }
WDCBufferResource >> readStreamFrom: offset withSize: length [
	^ ReadStream on: data from: offset + 1 to: offset + length
]

{ #category : #'as yet unclassified' }
WDCBufferResource >> size [
	^ description size
]

{ #category : #accessing }
WDCBufferResource >> validPointer [
	self checkSession.
	^ pointer
]
