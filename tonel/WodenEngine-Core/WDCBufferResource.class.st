Class {
	#name : #WDCBufferResource,
	#superclass : #WDCResourceWithSessionHandle,
	#instVars : [
		'description',
		'data',
		'pointer'
	],
	#category : 'WodenEngine-Core-GPU-Resources'
}

{ #category : #'resource building' }
WDCBufferResource >> buildHandle [
	self assert: description isNotNil.
	handle := engine device createBuffer: description initial_data: self initialData.
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

{ #category : #accessing }
WDCBufferResource >> validPointer [
	self checkSession.
	^ pointer
]
