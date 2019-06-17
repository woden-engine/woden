Class {
	#name : #WDCTexture,
	#superclass : #WDCResourceWithSessionHandle,
	#instVars : [
		'description',
		'data'
	],
	#classVars : [
		'FormatsWithDepthAspect',
		'FormatsWithStencilAspect'
	],
	#category : #'WodenEngine-Core-GPU-Resources'
}

{ #category : #'class initialization' }
WDCTexture class >> initialize [
	super initialize.
	
	FormatsWithDepthAspect := Set newFrom: {
		AGPU_TEXTURE_FORMAT_D16_UNORM.
		AGPU_TEXTURE_FORMAT_D24_UNORM_S8_UINT .
		AGPU_TEXTURE_FORMAT_D32_FLOAT .
		AGPU_TEXTURE_FORMAT_D32_FLOAT_S8X24_UINT.
	}.
	
	FormatsWithStencilAspect := Set newFrom: { 
		AGPU_TEXTURE_FORMAT_D24_UNORM_S8_UINT .
		AGPU_TEXTURE_FORMAT_D32_FLOAT_S8X24_UINT.
	}.
]

{ #category : #converting }
WDCTexture >> asSRGBTextureFor: anEngine [
	self assert: engine == anEngine.
	^ self
]

{ #category : #converting }
WDCTexture >> asTextureFor: anEngine [
	self assert: engine == anEngine.
	^ self
]

{ #category : #converting }
WDCTexture >> asWodenNormalTexture [
	^ self
]

{ #category : #converting }
WDCTexture >> asWodenSRGBTexture [
	^ self
]

{ #category : #converting }
WDCTexture >> asWodenTexture [
	^ self
]

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
	^ data isNotNil and: [ description usage_modes anyMask: AGPU_TEXTURE_USAGE_UPLOADED ]
]

{ #category : #'as yet unclassified' }
WDCTexture >> concretizeWodenSRGBTextureWithResourceCache: aResourceCache [
	^ self concretizeWodenTextureWithResourceCache: aResourceCache
]

{ #category : #'as yet unclassified' }
WDCTexture >> concretizeWodenTextureWithResourceCache: aResourceCache [
	engine == aResourceCache engine ifTrue: [ ^ self ].
	
	engine ifNil: [ 
		engine := aResourceCache engine
	] ifNotNil: [ 
		self halt.
	].

	^ self
]

{ #category : #accessing }
WDCTexture >> data [
	^ data
]

{ #category : #accessing }
WDCTexture >> data: anObject [
	data ifNotNil: [ self removeResourceDependency: data ].
	data := anObject.
	data ifNotNil: [ self addResourceDependency: data ].
	(self hasValidHandle and: [ self canUploadData ]) ifTrue: [ self uploadTextureData ]
]

{ #category : #dependencies }
WDCTexture >> dependencyChange: dependency [
	(dependency == data and: [self hasValidHandle and: [ self canUploadData ]]) ifTrue: [
		self uploadTextureData
	]

]

{ #category : #accessing }
WDCTexture >> description [
	^ description
]

{ #category : #accessing }
WDCTexture >> description: anObject [
	description := anObject
]

{ #category : #accessing }
WDCTexture >> extent [
	^ description width @ description height
]

{ #category : #'as yet unclassified' }
WDCTexture >> fullTextureView [
	| view |
	view := AGPUTextureViewDescription new.
	self validHandle getFullViewDescription: view.
	^ view

]

{ #category : #testing }
WDCTexture >> hasDepthAspect [
	^ FormatsWithDepthAspect includes: description format
	
]

{ #category : #testing }
WDCTexture >> hasStencilAspect [
	^ FormatsWithStencilAspect includes: description format
	
]

{ #category : #testing }
WDCTexture >> isDepthReaded [
	^ self hasDepthAspect and: [ description usage_modes anyMask: AGPU_TEXTURE_USAGE_SAMPLED ]
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

{ #category : #accessing }
WDCTexture >> valueRange [
	data ifNil: [ ^ nil ].
	data isForm ifTrue: [ ^ { 0.0 . 1.0 } ].
	^ data valueRange
]
