Class {
	#name : #WDCTexture,
	#superclass : #WDCResourceWithSessionHandle,
	#instVars : [
		'description',
		'data'
	],
	#category : 'WodenEngine-Core-GPU-Resources'
}

{ #category : #converting }
WDCTexture >> athensFillRectangle: rectangle on: canvas [
	
]

{ #category : #'resource building' }
WDCTexture >> buildHandle [
	self assert: description isNotNil.
	handle := engine device createTexture: description.
	self canUploadData ifTrue: [ 
		self uploadTextureData.
	].

]

{ #category : #'resource building' }
WDCTexture >> canUploadData [
	^ data isNotNil and: [ description flags anyMask: AGPU_TEXTURE_FLAG_UPLOADED ]
]

{ #category : #accessing }
WDCTexture >> data [
	^ data
]

{ #category : #accessing }
WDCTexture >> data: anObject [
	data := anObject.
	(self hasValidHandle and: [ self canUploadData ]) ifTrue: [ self uploadTextureData ]
]

{ #category : #accessing }
WDCTexture >> description [
	^ description
]

{ #category : #accessing }
WDCTexture >> description: anObject [
	description := anObject
]

{ #category : #preview }
WDCTexture >> thumbnail [
	data ifNotNil: [ ^ data thumbnail ].
	^ Color red
]

{ #category : #'resource building' }
WDCTexture >> uploadTexture1DData [
	handle uploadTextureData: 0 arrayIndex: 0 pitch: data size slicePitch: data size data: data
]

{ #category : #'resource building' }
WDCTexture >> uploadTexture2DData [
	data isForm ifTrue: [ ^ self uploadTexture2DFormData ].
	self uploadWodenTextureData

]

{ #category : #'resource building' }
WDCTexture >> uploadTexture2DFormData [
	"Only supporting form for now."
	| pitch slicePitch actualData |
	self assert: data isForm.
	pitch := data width * (data depth // 8).
	slicePitch := pitch * data height.
	data unhibernate.
	actualData := data bits.
	data depth < 32 ifTrue: [ actualData := actualData asByteArray ].
	handle uploadTextureData: 0 arrayIndex: 0 pitch: pitch slicePitch: slicePitch data: actualData.
]

{ #category : #'resource building' }
WDCTexture >> uploadTextureCubeData [
	self uploadWodenTextureData

]

{ #category : #'resource building' }
WDCTexture >> uploadTextureData [
	| type |
	type := description type.
	type = AGPU_TEXTURE_1D ifTrue: [ ^ self uploadTexture1DData ].
	type = AGPU_TEXTURE_2D ifTrue: [ ^ self uploadTexture2DData ].
	type = AGPU_TEXTURE_CUBE ifTrue: [ ^ self uploadTextureCubeData ].
	self error: 'Not yet supported.'
]

{ #category : #'resource building' }
WDCTexture >> uploadWodenTextureData [
	data layers doWithIndex: [ :layer :layerIndex |
		layer levels doWithIndex: [ :level :levelIndex |
			handle uploadTextureData: levelIndex - 1 arrayIndex: layerIndex - 1 pitch: level pitch slicePitch: level slicePitch data: level data.
		]
	]
]
