Class {
	#name : #WDCPharoProceduralScriptEvaluator,
	#superclass : #Object,
	#instVars : [
		'engine',
		'parameters',
		'heightFunction',
		'normalHeightScaleFactor',
		'textureExtent',
		'colorMapFunction',
		'albedoFunction',
		'metallicFunction',
		'roughnessFunction',
		'extentForInspector',
		'cubeMap',
		'hdr',
		'colorFunction',
		'ambientOcclusionRadius',
		'ambientOcclusionHeightThreshold',
		'ambientOcclusionSampleCount',
		'terrainFunction',
		'terrainData',
		'terrainCellSize'
	],
	#category : #'WodenEngine-Core-Texture'
}

{ #category : #'as yet unclassified' }
WDCPharoProceduralScriptEvaluator class >> evaluateScriptFromFile: aFileReference [
	^ self new evaluateScriptFromFile: aFileReference
]

{ #category : #'as yet unclassified' }
WDCPharoProceduralScriptEvaluator class >> forInspector [
	^ self new parameters: (Dictionary newFromPairs: #(texture inspector))
]

{ #category : #accessing }
WDCPharoProceduralScriptEvaluator >> albedoFunction [
	^ albedoFunction
]

{ #category : #accessing }
WDCPharoProceduralScriptEvaluator >> albedoFunction: anObject [
	albedoFunction := anObject
]

{ #category : #accessing }
WDCPharoProceduralScriptEvaluator >> ambientOcclusionHeightThreshold [
	^ ambientOcclusionHeightThreshold
]

{ #category : #accessing }
WDCPharoProceduralScriptEvaluator >> ambientOcclusionHeightThreshold: anObject [
	ambientOcclusionHeightThreshold := anObject
]

{ #category : #accessing }
WDCPharoProceduralScriptEvaluator >> ambientOcclusionRadius [
	^ ambientOcclusionRadius
]

{ #category : #accessing }
WDCPharoProceduralScriptEvaluator >> ambientOcclusionRadius: anObject [
	ambientOcclusionRadius := anObject
]

{ #category : #accessing }
WDCPharoProceduralScriptEvaluator >> ambientOcclusionSampleCount [
	^ ambientOcclusionSampleCount
]

{ #category : #accessing }
WDCPharoProceduralScriptEvaluator >> ambientOcclusionSampleCount: anObject [
	ambientOcclusionSampleCount := anObject
]

{ #category : #accessing }
WDCPharoProceduralScriptEvaluator >> at: aParamName [
	^ self at: aParamName ifAbsent: [ nil ]
]

{ #category : #accessing }
WDCPharoProceduralScriptEvaluator >> at: aParamName ifAbsent: isAbsentBlock [
	parameters ifNil: [ ^ isAbsentBlock value ].
	^ self parameters at: aParamName ifAbsent: isAbsentBlock
]

{ #category : #accessing }
WDCPharoProceduralScriptEvaluator >> colorFunction [
	^ colorFunction
]

{ #category : #accessing }
WDCPharoProceduralScriptEvaluator >> colorFunction: anObject [
	colorFunction := anObject
]

{ #category : #accessing }
WDCPharoProceduralScriptEvaluator >> colorMapFunction [
	^ colorMapFunction ifNil: [ colorMapFunction := WDCGrayscaleColorMap new ]
]

{ #category : #accessing }
WDCPharoProceduralScriptEvaluator >> colorMapFunction: anObject [
	colorMapFunction := anObject
]

{ #category : #accessing }
WDCPharoProceduralScriptEvaluator >> cubeMap [
	^ cubeMap
]

{ #category : #accessing }
WDCPharoProceduralScriptEvaluator >> cubeMap: anObject [
	cubeMap := anObject
]

{ #category : #accessing }
WDCPharoProceduralScriptEvaluator >> engine [
	^ engine
]

{ #category : #accessing }
WDCPharoProceduralScriptEvaluator >> engine: anObject [
	engine := anObject
]

{ #category : #'rendering helpers' }
WDCPharoProceduralScriptEvaluator >> evaluate [
	terrainFunction ifNotNil: [ ^ self evaluateTerrainMap. ].
	self cubeMap ifTrue: [ ^ self evaluateCubeMap ].
	^ self evaluate2DTexture

]

{ #category : #'rendering helpers' }
WDCPharoProceduralScriptEvaluator >> evaluate2DTexture [
	self isInInspector ifTrue: [
		^ WDCMultiTextureView new textures: {
			'Albedo' -> (self evaluateAlbedoTextureWithExtent: self extentForInspector).
			'Normal Map' -> (self evaluateNormalMapTextureWithExtent: self extentForInspector).
			'Height Map' -> (self evaluateHeightMapTextureWithExtent: self extentForInspector).
			'Ambient Occlusion' -> (self evaluateAmbientOcclusionTextureWithExtent: self extentForInspector).
			'Metallic' -> (self evaluateMetallicTextureWithExtent: self extentForInspector).
			'Roughness' -> (self evaluateRoughnessTextureWithExtent: self extentForInspector).
			'RMA' -> (self evaluateRoughnessMetallicAOTextureWithExtent: self extentForInspector).
		}
	].

	(self isAlbedoRequested or: [self isDefaultTextureRequested]) ifTrue: [ 
		^ self evaluateAlbedoTextureWithExtent: textureExtent
	].

	self isNormalMapRequested ifTrue: [
		^ self evaluateNormalMapTextureWithExtent: textureExtent
	].

	self isHeightMapRequested ifTrue: [
		^ self evaluateHeightMapTextureWithExtent: textureExtent
	].

	self isAmbientOcclusionRequested ifTrue: [ 
		^ self evaluateAmbientOcclusionTextureWithExtent: self extentForInspector
	].

	self isMetallicRequested ifTrue: [ 
		^ self evaluateMetallicTextureWithExtent: self extentForInspector
	].

	self isRoughnessRequested ifTrue: [ 
		^ self evaluateRoughnessTextureWithExtent: self extentForInspector
	].

	self isMetallicRoughnessAORequested ifTrue: [ 
		^ self evaluateRoughnessMetallicAOTextureWithExtent: self extentForInspector
	].

	^ nil
]

{ #category : #'rendering helpers' }
WDCPharoProceduralScriptEvaluator >> evaluateAlbedoTextureWithExtent: anExtent [
	^ WDCTextureData extent: anExtent srgbColorRenderWith: [ :s :t |
		self colorMapFunction value: (heightFunction value: s value: t)
	]
]

{ #category : #'rendering helpers' }
WDCPharoProceduralScriptEvaluator >> evaluateAmbientOcclusionTextureWithExtent: anExtent [
	^ nil
]

{ #category : #'rendering helpers' }
WDCPharoProceduralScriptEvaluator >> evaluateCubeMap [
	self shouldBeImplemented
]

{ #category : #'rendering helpers' }
WDCPharoProceduralScriptEvaluator >> evaluateHeightMapTextureWithExtent: anExtent [
	^ nil
]

{ #category : #'rendering helpers' }
WDCPharoProceduralScriptEvaluator >> evaluateMetallicTextureWithExtent: anExtent [
	^ nil
]

{ #category : #'rendering helpers' }
WDCPharoProceduralScriptEvaluator >> evaluateNormalMapTextureWithExtent: anExtent [
	^ WDCTextureData extent: anExtent normalMapWithHeightFunction: heightFunction heightScaleFactor: normalHeightScaleFactor
]

{ #category : #'rendering helpers' }
WDCPharoProceduralScriptEvaluator >> evaluateRoughnessMetallicAOTextureWithExtent: anExtent [
	^ nil
]

{ #category : #'rendering helpers' }
WDCPharoProceduralScriptEvaluator >> evaluateRoughnessTextureWithExtent: anExtent [
	^ nil
]

{ #category : #'as yet unclassified' }
WDCPharoProceduralScriptEvaluator >> evaluateScriptFromFile: scriptFileReference [
	^ Smalltalk compiler
			receiver: (WDCPharoProceduralScriptContext new textureGenerator: self);
			evaluate: scriptFileReference asFileReference contents

]

{ #category : #'rendering helpers' }
WDCPharoProceduralScriptEvaluator >> evaluateTerrainHeightMapTextureWithExtent: anExtent [
	| minHeight maxHeight invRange center coordinateTransform coordinateScale coordinateOffset |
	coordinateTransform := self terrainCoordinateTransform.
	coordinateScale := coordinateTransform first.
	coordinateOffset := coordinateTransform second.
	minHeight := self terrainData minHeight.
	maxHeight := self terrainData maxHeight.
	center := (maxHeight + minHeight) * 0.5.
	invRange := (maxHeight closeTo: minHeight)
		ifTrue: [ 0.0 ]
		ifFalse: [ (maxHeight - center) reciprocal ].
	
	^ WDCTextureData extent: anExtent signedHeightRenderWith: [ :s :t |
		| x y|
		x := s*coordinateScale x + coordinateOffset x.
		y := t*coordinateScale y + coordinateOffset y.
		(((terrainFunction value: x value: y) first min: maxHeight max: minHeight) - center) * invRange
	].
]

{ #category : #'rendering helpers' }
WDCPharoProceduralScriptEvaluator >> evaluateTerrainMap [
	self isInInspector ifTrue: [
		^ WDCMultiTextureView new textures: {
			'Height Map' -> (self evaluateTerrainHeightMapTextureWithExtent: self extentForInspector).
			'Splatter Map' -> (self evaluateTerrainSplatterMapTextureWithExtent: self extentForInspector).
		}
	].

	self isSplatterMapRequested ifTrue: [
		^ self evaluateTerrainSplatterMapTextureWithExtent: textureExtent
	].

	self isHeightMapRequested ifTrue: [
		^ self evaluateTerrainHeightMapTextureWithExtent: textureExtent
	].

	self isTerrainDataRequested ifTrue: [ 
		^ self terrainData copy
			heightMap: (self evaluateTerrainHeightMapTextureWithExtent: textureExtent);
			splatterMap: (self evaluateTerrainSplatterMapTextureWithExtent: textureExtent);
			yourself
	].

	^ self evaluateTerrainHeightMapTextureWithExtent: textureExtent

]

{ #category : #'rendering helpers' }
WDCPharoProceduralScriptEvaluator >> evaluateTerrainSplatterMapTextureWithExtent: anExtent [
	| coordinateTransform coordinateScale coordinateOffset |
	coordinateTransform := self terrainCoordinateTransform.
	coordinateScale := coordinateTransform first.
	coordinateOffset := coordinateTransform second.

	^ WDCTextureData extent: anExtent colorRenderWith: [ :s :t |
		| x y|
		x := s*coordinateScale x + coordinateOffset x.
		y := t*coordinateScale y + coordinateOffset y.

		Color forSplattingElements: (terrainFunction value: x value: y) second
	].
]

{ #category : #accessing }
WDCPharoProceduralScriptEvaluator >> extentForInspector [
	^ extentForInspector ifNil: [ extentForInspector := self textureExtent ]
]

{ #category : #accessing }
WDCPharoProceduralScriptEvaluator >> hdr [
	^ hdr
]

{ #category : #accessing }
WDCPharoProceduralScriptEvaluator >> hdr: anObject [
	hdr := anObject
]

{ #category : #accessing }
WDCPharoProceduralScriptEvaluator >> heightFunction [
	^ heightFunction
]

{ #category : #accessing }
WDCPharoProceduralScriptEvaluator >> heightFunction: anObject [
	heightFunction := anObject
]

{ #category : #initialization }
WDCPharoProceduralScriptEvaluator >> initialize [
	super initialize.
	normalHeightScaleFactor := 1.0.
	ambientOcclusionRadius := nil.
	ambientOcclusionHeightThreshold := nil.
	ambientOcclusionSampleCount := 512.
	cubeMap := false.
	hdr := false.
]

{ #category : #testing }
WDCPharoProceduralScriptEvaluator >> isAlbedoRequested [
	^ self requestedTexture = #albedo
]

{ #category : #testing }
WDCPharoProceduralScriptEvaluator >> isAmbientOcclusionRequested [
	^ self requestedTexture = #ao
]

{ #category : #testing }
WDCPharoProceduralScriptEvaluator >> isDefaultTextureRequested [
	^ self requestedTexture = #default
]

{ #category : #testing }
WDCPharoProceduralScriptEvaluator >> isHeightMapRequested [
	^ self requestedTexture = #height
]

{ #category : #testing }
WDCPharoProceduralScriptEvaluator >> isInInspector [
	^ self requestedTexture = #inspector
]

{ #category : #testing }
WDCPharoProceduralScriptEvaluator >> isMetallicRequested [
	^ self requestedTexture = #metallic
]

{ #category : #testing }
WDCPharoProceduralScriptEvaluator >> isMetallicRoughnessAORequested [
	^ self requestedTexture = #rma
]

{ #category : #testing }
WDCPharoProceduralScriptEvaluator >> isNormalMapRequested [
	^ self requestedTexture = #normal
]

{ #category : #testing }
WDCPharoProceduralScriptEvaluator >> isRoughnessRequested [
	^ self requestedTexture = #roughness
]

{ #category : #testing }
WDCPharoProceduralScriptEvaluator >> isSplatterMapRequested [
	^ self requestedTexture = #splatter
]

{ #category : #testing }
WDCPharoProceduralScriptEvaluator >> isTerrainDataRequested [
	^ self requestedTexture = #terrainData
]

{ #category : #accessing }
WDCPharoProceduralScriptEvaluator >> metallicFunction [
	^ metallicFunction
]

{ #category : #accessing }
WDCPharoProceduralScriptEvaluator >> metallicFunction: anObject [
	metallicFunction := anObject
]

{ #category : #accessing }
WDCPharoProceduralScriptEvaluator >> normalHeightScaleFactor [
	^ normalHeightScaleFactor
]

{ #category : #accessing }
WDCPharoProceduralScriptEvaluator >> normalHeightScaleFactor: anObject [
	normalHeightScaleFactor := anObject
]

{ #category : #accessing }
WDCPharoProceduralScriptEvaluator >> parameters [
	^ parameters
]

{ #category : #accessing }
WDCPharoProceduralScriptEvaluator >> parameters: anObject [
	parameters := anObject
]

{ #category : #printing }
WDCPharoProceduralScriptEvaluator >> printOn: aStream [
	super printOn: aStream.
	aStream print: parameters
]

{ #category : #accessing }
WDCPharoProceduralScriptEvaluator >> requestedTexture [
	^ (self at: #texture) ifNil: [ #default ]
]

{ #category : #accessing }
WDCPharoProceduralScriptEvaluator >> roughnessFunction [
	^ roughnessFunction
]

{ #category : #accessing }
WDCPharoProceduralScriptEvaluator >> roughnessFunction: anObject [
	roughnessFunction := anObject
]

{ #category : #accessing }
WDCPharoProceduralScriptEvaluator >> skyCubeMap: aBoolean [
	self
		cubeMap: aBoolean;
		hdr: aBoolean
]

{ #category : #'as yet unclassified' }
WDCPharoProceduralScriptEvaluator >> terrainCoordinateTransform [
	^ terrainCellSize
		ifNil: [ { Float32x2 ones . Float32x2 zeros } ]
		ifNotNil: [
			| scale |
			scale := Float32x2 ones * 2.0 / self terrainData heightMapScale.
			{scale . self terrainData heightMapOffset*scale - (scale*0.5)}
		]
]

{ #category : #accessing }
WDCPharoProceduralScriptEvaluator >> terrainData [
	^ terrainData ifNil: [ terrainData := WDCTerrainData new ]
]

{ #category : #accessing }
WDCPharoProceduralScriptEvaluator >> terrainFunction [
	^ terrainFunction
]

{ #category : #accessing }
WDCPharoProceduralScriptEvaluator >> terrainFunction: aFunction [
	terrainFunction := aFunction
]

{ #category : #accessing }
WDCPharoProceduralScriptEvaluator >> textureExtent [
	^ textureExtent
]

{ #category : #accessing }
WDCPharoProceduralScriptEvaluator >> textureExtent: anObject [
	textureExtent := anObject
]

{ #category : #'as yet unclassified' }
WDCPharoProceduralScriptEvaluator >> textureExtent: newTextureExtent terrainCellSize: newTerrainCellSize [
	self textureExtent: newTextureExtent.
	terrainCellSize := newTerrainCellSize asFloat32x2.
	self terrainData
		terrainExtent: newTextureExtent*newTerrainCellSize.
]

{ #category : #'as yet unclassified' }
WDCPharoProceduralScriptEvaluator >> validEngine [
	^ engine ifNil: [ engine := WDCEngine default ]
]
