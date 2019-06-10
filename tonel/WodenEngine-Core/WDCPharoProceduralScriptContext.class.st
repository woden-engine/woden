Class {
	#name : #WDCPharoProceduralScriptContext,
	#superclass : #Object,
	#instVars : [
		'engine',
		'parameters'
	],
	#category : #'WodenEngine-Core-Texture'
}

{ #category : #'as yet unclassified' }
WDCPharoProceduralScriptContext class >> evaluateScriptFromFile: aFileReference [
	^ self new evaluateScriptFromFile: aFileReference
]

{ #category : #'as yet unclassified' }
WDCPharoProceduralScriptContext class >> forInspector [
	^ self new parameters: (Dictionary newFromPairs: #(texture inspector))
]

{ #category : #accessing }
WDCPharoProceduralScriptContext >> at: aParamName [
	^ self at: aParamName ifAbsent: [ nil ]
]

{ #category : #accessing }
WDCPharoProceduralScriptContext >> at: aParamName ifAbsent: isAbsentBlock [
	parameters ifNil: [ ^ isAbsentBlock value ].
	^ self parameters at: aParamName ifAbsent: isAbsentBlock
]

{ #category : #accessing }
WDCPharoProceduralScriptContext >> engine [
	^ engine
]

{ #category : #accessing }
WDCPharoProceduralScriptContext >> engine: anObject [
	engine := anObject
]

{ #category : #'as yet unclassified' }
WDCPharoProceduralScriptContext >> evaluateScriptFromFile: scriptFileReference [
	^ Smalltalk compiler
			receiver: self;
			evaluate: scriptFileReference asFileReference contents

]

{ #category : #testing }
WDCPharoProceduralScriptContext >> isAlbedoRequested [
	^ self requestedTexture = #albedo
]

{ #category : #testing }
WDCPharoProceduralScriptContext >> isDefaultTextureRequested [
	^ self requestedTexture = #default
]

{ #category : #testing }
WDCPharoProceduralScriptContext >> isInInspector [
	^ self requestedTexture = #inspector
]

{ #category : #testing }
WDCPharoProceduralScriptContext >> isNormalMapRequested [
	^ self requestedTexture = #normal
]

{ #category : #accessing }
WDCPharoProceduralScriptContext >> parameters [
	^ parameters
]

{ #category : #accessing }
WDCPharoProceduralScriptContext >> parameters: anObject [
	parameters := anObject
]

{ #category : #printing }
WDCPharoProceduralScriptContext >> printOn: aStream [
	super printOn: aStream.
	aStream print: parameters
]

{ #category : #accessing }
WDCPharoProceduralScriptContext >> requestedTexture [
	^ (self at: #texture) ifNil: [ #default ]
]

{ #category : #'rendering helpers' }
WDCPharoProceduralScriptContext >> textureExtent: anExtent heightFunction: heightFunction [
	^ self textureExtent: anExtent heightFunction: heightFunction colorWith: WDCGrayscaleColorMap new
]

{ #category : #'rendering helpers' }
WDCPharoProceduralScriptContext >> textureExtent: anExtent heightFunction: heightFunction colorWith: colorFunction [
	^ self textureExtent: anExtent inspectorExtent: anExtent heightFunction: heightFunction colorWith: colorFunction
]

{ #category : #'rendering helpers' }
WDCPharoProceduralScriptContext >> textureExtent: anExtent heightFunction: heightFunction colorWith: colorFunction  normalHeightScaleFactor: normalHeightScaleFactor [
	^ self textureExtent: anExtent inspectorExtent: anExtent heightFunction: heightFunction colorWith: colorFunction normalHeightScaleFactor: normalHeightScaleFactor
]

{ #category : #'rendering helpers' }
WDCPharoProceduralScriptContext >> textureExtent: anExtent inspectorExtent: anExtentForInspector heightFunction: heightFunction colorWith: colorFunction [
	^ self textureExtent: anExtent inspectorExtent: anExtentForInspector heightFunction: heightFunction colorWith: colorFunction normalHeightScaleFactor: 1.0
]

{ #category : #'rendering helpers' }
WDCPharoProceduralScriptContext >> textureExtent: anExtent inspectorExtent: anExtentForInspector heightFunction: heightFunction colorWith: colorFunction normalHeightScaleFactor: normalHeightScaleFactor [
	self isInInspector ifTrue: [
		^ WDCMultiTextureView new textures: { 
			'Albedo' -> (WDCTextureData extent: anExtentForInspector srgbColorRenderWith: [ :s :t |
				colorFunction value: (heightFunction value: s value: t)
			]).
			'Normal Map' -> (WDCTextureData extent: anExtentForInspector normalMapWithHeightFunction: heightFunction heightScaleFactor: normalHeightScaleFactor).
		}.

	].

	(self isAlbedoRequested or: [self isDefaultTextureRequested]) ifTrue: [ 
		^ WDCTextureData extent: anExtent srgbColorRenderWith: [ :s :t |
			colorFunction value: (heightFunction value: s value: t)
		]
	].

	self isNormalMapRequested ifTrue: [
		^ WDCTextureData extent: anExtent normalMapWithHeightFunction: heightFunction heightScaleFactor: normalHeightScaleFactor
	].

	^ nil
]

{ #category : #'as yet unclassified' }
WDCPharoProceduralScriptContext >> validEngine [
	^ engine ifNil: [ engine := WDCEngine default ]
]
