Class {
	#name : #WDCGenericComputeShaderArguments,
	#superclass : #Object,
	#instVars : [
		'engine',
		'signature',
		'storageImageShaderResourceBindings',
		'uniformBufferShaderResourceBindings',
		'storageBufferShaderResourceBindings',
		'sampledTextureShaderResourceBindings'
	],
	#category : #'WodenEngine-Core-Shaders'
}

{ #category : #'instance creation' }
WDCGenericComputeShaderArguments class >> for: engine [
	^ self new engine: engine; yourself
]

{ #category : #'as yet unclassified' }
WDCGenericComputeShaderArguments >> applyBindingsOnStateTracker: stateTracker [
	uniformBufferShaderResourceBindings ifNotNil: [ stateTracker useComputeShaderResources: uniformBufferShaderResourceBindings ].
	storageBufferShaderResourceBindings ifNotNil: [ stateTracker useComputeShaderResources: storageBufferShaderResourceBindings ].
	sampledTextureShaderResourceBindings ifNotNil: [ stateTracker useComputeShaderResources: sampledTextureShaderResourceBindings ].
	storageImageShaderResourceBindings ifNotNil: [ stateTracker useComputeShaderResources: storageImageShaderResourceBindings ].
	stateTracker useComputeShaderResources: self signature defaultSamplers
]

{ #category : #accessing }
WDCGenericComputeShaderArguments >> engine [
	^ engine
]

{ #category : #accessing }
WDCGenericComputeShaderArguments >> engine: anObject [
	engine := anObject
]

{ #category : #'as yet unclassified' }
WDCGenericComputeShaderArguments >> sampledTexture: texture slot: slotIndex [
	self sampledTexturesShaderResourceBindings
		bind: slotIndex texture: texture
]

{ #category : #'as yet unclassified' }
WDCGenericComputeShaderArguments >> sampledTexture: texture slot: slotIndex startMiplevel: startMipLevel miplevels: mipLevels lodclamp: lodClamp [
	self sampledTexturesShaderResourceBindings
		bind: slotIndex texture: texture startMiplevel: startMipLevel miplevels: mipLevels lodclamp: lodClamp
]

{ #category : #'as yet unclassified' }
WDCGenericComputeShaderArguments >> sampledTexturesShaderResourceBindings [
	^ sampledTextureShaderResourceBindings ifNil: [ sampledTextureShaderResourceBindings := self signature newSampledTextures ]
]

{ #category : #accessing }
WDCGenericComputeShaderArguments >> signature [
	^ signature ifNil: [ signature := WDCGenericComputationShaderSignature for: engine ]
]

{ #category : #accessing }
WDCGenericComputeShaderArguments >> signature: anObject [
	signature := anObject
]

{ #category : #'as yet unclassified' }
WDCGenericComputeShaderArguments >> storageBuffer: buffer slot: slotIndex [
	self storageBuffersShaderResourceBindings
		bind: slotIndex storageBuffer: buffer
]

{ #category : #'as yet unclassified' }
WDCGenericComputeShaderArguments >> storageBuffersShaderResourceBindings [
	^ storageBufferShaderResourceBindings ifNil: [ storageBufferShaderResourceBindings := self signature newStorageBuffers ]
]

{ #category : #'as yet unclassified' }
WDCGenericComputeShaderArguments >> storageImage: texture slot: slotIndex [
	self storageImageShaderResourceBindings
		bind: slotIndex storageImage: texture
]

{ #category : #'as yet unclassified' }
WDCGenericComputeShaderArguments >> storageImage: texture slot: slotIndex level: level layer: layer [
	self storageImageShaderResourceBindings
		bind: slotIndex storageImage: texture level: level layer: layer
]

{ #category : #'as yet unclassified' }
WDCGenericComputeShaderArguments >> storageImageShaderResourceBindings [
	^ storageImageShaderResourceBindings ifNil: [ storageImageShaderResourceBindings := self signature newStorageImages ]
]

{ #category : #'as yet unclassified' }
WDCGenericComputeShaderArguments >> storageImages: textures [
	textures doWithIndex: [ :texture :index | self storageImage: texture slot: index - 1]
]
