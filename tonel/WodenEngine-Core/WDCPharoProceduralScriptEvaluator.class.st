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
		'extentForInspector'
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
WDCPharoProceduralScriptEvaluator >> at: aParamName [
	^ self at: aParamName ifAbsent: [ nil ]
]

{ #category : #accessing }
WDCPharoProceduralScriptEvaluator >> at: aParamName ifAbsent: isAbsentBlock [
	parameters ifNil: [ ^ isAbsentBlock value ].
	^ self parameters at: aParamName ifAbsent: isAbsentBlock
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
WDCPharoProceduralScriptEvaluator >> engine [
	^ engine
]

{ #category : #accessing }
WDCPharoProceduralScriptEvaluator >> engine: anObject [
	engine := anObject
]

{ #category : #'rendering helpers' }
WDCPharoProceduralScriptEvaluator >> evaluate [
	self isInInspector ifTrue: [
		^ WDCMultiTextureView new textures: { 
			'Albedo' -> (WDCTextureData extent: self extentForInspector srgbColorRenderWith: [ :s :t |
				colorMapFunction value: (heightFunction value: s value: t)
			]).
			'Normal Map' -> (WDCTextureData extent: self extentForInspector normalMapWithHeightFunction: heightFunction heightScaleFactor: normalHeightScaleFactor).
		}.

	].

	(self isAlbedoRequested or: [self isDefaultTextureRequested]) ifTrue: [ 
		^ WDCTextureData extent: textureExtent srgbColorRenderWith: [ :s :t |
			colorMapFunction value: (heightFunction value: s value: t)
		]
	].

	self isNormalMapRequested ifTrue: [
		^ WDCTextureData extent: textureExtent
			normalMapWithHeightFunction: heightFunction
			heightScaleFactor: normalHeightScaleFactor
	].

	^ nil
]

{ #category : #'as yet unclassified' }
WDCPharoProceduralScriptEvaluator >> evaluateScriptFromFile: scriptFileReference [
	^ Smalltalk compiler
			receiver: (WDCPharoProceduralScriptContext new textureGenerator: self);
			evaluate: scriptFileReference asFileReference contents

]

{ #category : #accessing }
WDCPharoProceduralScriptEvaluator >> extentForInspector [
	^ extentForInspector ifNil: [ extentForInspector := self textureExtent ]
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
]

{ #category : #testing }
WDCPharoProceduralScriptEvaluator >> isAlbedoRequested [
	^ self requestedTexture = #albedo
]

{ #category : #testing }
WDCPharoProceduralScriptEvaluator >> isDefaultTextureRequested [
	^ self requestedTexture = #default
]

{ #category : #testing }
WDCPharoProceduralScriptEvaluator >> isInInspector [
	^ self requestedTexture = #inspector
]

{ #category : #testing }
WDCPharoProceduralScriptEvaluator >> isNormalMapRequested [
	^ self requestedTexture = #normal
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
WDCPharoProceduralScriptEvaluator >> textureExtent [
	^ textureExtent
]

{ #category : #accessing }
WDCPharoProceduralScriptEvaluator >> textureExtent: anObject [
	textureExtent := anObject
]

{ #category : #'as yet unclassified' }
WDCPharoProceduralScriptEvaluator >> validEngine [
	^ engine ifNil: [ engine := WDCEngine default ]
]
