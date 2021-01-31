Class {
	#name : #WDCDummyEngine,
	#superclass : #Object,
	#instVars : [
		'projectionInvertedY',
		'assetSearchPaths',
		'resourceCache'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Engine'
}

{ #category : #assets }
WDCDummyEngine >> assetSearchPaths [
	^ assetSearchPaths
]

{ #category : #accessing }
WDCDummyEngine >> autoReloadChanges [
	^ false
]

{ #category : #'resource building' }
WDCDummyEngine >> createIndex: indexSize elements: elementCount immutableBuffer: data [
	| desc |
	desc := AGPUBufferDescription new
		size: indexSize*elementCount;
		heap_type: AGPU_MEMORY_HEAP_TYPE_DEVICE_LOCAL;
		usage_modes: AGPU_ELEMENT_ARRAY_BUFFER;
		main_usage_mode: AGPU_ELEMENT_ARRAY_BUFFER;
		mapping_flags: 0;
		stride: indexSize.
	^ WDCBufferResource new
		description: desc;
		data: data;
		yourself
]

{ #category : #initialization }
WDCDummyEngine >> createResourceCache [
	resourceCache ifNil: [
		resourceCache := WDCResourceCache new.
		resourceCache initializeForEngine: self.
 	].

	resourceCache sessionChanged
]

{ #category : #'resource loading' }
WDCDummyEngine >> createVertex: vertexSize elements: elementCount immutableBuffer: data [
	| desc |
	desc := AGPUBufferDescription new
		size: vertexSize*elementCount;
		heap_type: AGPU_MEMORY_HEAP_TYPE_DEVICE_LOCAL;
		usage_modes: AGPU_ARRAY_BUFFER;
		main_usage_mode: AGPU_ARRAY_BUFFER;
		mapping_flags: 0;
		stride: vertexSize.
	^ WDCBufferResource new
		description: desc;
		data: data;
		yourself
]

{ #category : #'resource building' }
WDCDummyEngine >> createVertexBindingForLayout: vertexLayout [
	^ WDCVertexBinding new vertexLayout: vertexLayout; yourself
]

{ #category : #accessing }
WDCDummyEngine >> defaultMaterial [
	^ resourceCache defaultMaterial
]

{ #category : #accessing }
WDCDummyEngine >> frameBufferingCount [
	^ 1
]

{ #category : #accessing }
WDCDummyEngine >> getOrCreateShaderSignature: aShaderSignatureClass [
	^ resourceCache getOrCreateShaderSignature: aShaderSignatureClass
]

{ #category : #wrappers }
WDCDummyEngine >> getPreferredHighLevelShaderLanguage [
	^ AGPU_SHADER_LANGUAGE_VGLSL
]

{ #category : #wrappers }
WDCDummyEngine >> getPreferredIntermediateShaderLanguage [
	^ AGPU_SHADER_LANGUAGE_SPIR_V
]

{ #category : #wrappers }
WDCDummyEngine >> getPreferredShaderLanguage [
	^ AGPU_SHADER_LANGUAGE_SPIR_V
]

{ #category : #initialization }
WDCDummyEngine >> initialize [
	super initialize.
	projectionInvertedY := false.
	assetSearchPaths ifNil: [ 
		assetSearchPaths := OrderedCollection new.
		assetSearchPaths add: WodenCoreAssets coreAssetsLocation.
		assetSearchPaths add: Smalltalk imageDirectory / #assets.
	].
	self initializeForNewSession.
]

{ #category : #initialization }
WDCDummyEngine >> initializeForNewSession [
	self createResourceCache.
]

{ #category : #testing }
WDCDummyEngine >> isDummyEngine [
	^ true
]

{ #category : #'as yet unclassified' }
WDCDummyEngine >> minimalAlignmentForUniformBufferElement [
	self flag: 'FIXME: Ask this to the graphics backend'.
	^ 256
]

{ #category : #accessing }
WDCDummyEngine >> resourceCache [
	^ resourceCache
]

{ #category : #'resource loading' }
WDCDummyEngine >> vertexLayoutFor: aVertexClass [
	^ aVertexClass asWodenVertexLayout
]
