Class {
	#name : #WDCPharoProceduralGPUScriptEvaluator,
	#superclass : #WDCPharoProceduralScriptEvaluator,
	#instVars : [
		'codeConverter'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Texture'
}

{ #category : #'rendering helpers' }
WDCPharoProceduralGPUScriptEvaluator >> aoShaderFor: heightFunctionObject aoRadius: aoRadius aoHeightThreshold: heightThreshold aoSampleCount: sampleCount [
	| builder aoFactorNode aoHeightThresholdNode aoSampleCountNode |
	
	codeConverter := DASLPharoCodeConverter new.
	codeConverter
		convertFunction: heightFunctionObject name: #heightFieldFunction argumentTypes: #(float float) returnType: #float.
	builder := DASLAstBuilder new.
			
	aoFactorNode := builder constantGlobalNamed: #AmbientOcclusionRadius typeNamed: #float value: 
		(builder literalFloat: aoRadius asFloat).
	aoHeightThresholdNode := builder constantGlobalNamed: #AmbientOcclusionHeightThreshold typeNamed: #float value: 
		(builder literalFloat: heightThreshold asFloat).
	aoSampleCountNode := builder constantGlobalNamed: #AmbientOcclusionSampleCount typeNamed: #uint value: 
		(builder literalUInt: sampleCount asInteger).
		
	^ self compileShader: 'procedural/ambientOcclusionTextureInterface.dastrel' injectingNodes: codeConverter generatedNodes , { aoFactorNode . aoHeightThresholdNode . aoSampleCountNode }

]

{ #category : #'rendering helpers' }
WDCPharoProceduralGPUScriptEvaluator >> colorShaderForFunction: aColorFunction [
	codeConverter := DASLPharoCodeConverter new.
	codeConverter convertFunction: aColorFunction name: #colorFunction argumentTypes: #(float float) returnType: #float4.

	^ self compileShader: 'procedural/coloredTextureInterface.dastrel' injectingNodes: codeConverter generatedNodes

]

{ #category : #'rendering helpers' }
WDCPharoProceduralGPUScriptEvaluator >> colorShaderForHeightFunction: heightFunctionObject coloredWith: colorFunctionObject [
	codeConverter := DASLPharoCodeConverter new.
	codeConverter convertFunction: colorFunctionObject name: #colorMapFunction argumentTypes: #(float) returnType: #float4.
	codeConverter convertFunction: heightFunctionObject name: #heightFieldFunction argumentTypes: #(float float) returnType: #float.

	^ self compileShader: 'procedural/coloredHeightFieldTextureInterface.dastrel' injectingNodes: codeConverter generatedNodes

]

{ #category : #'rendering helpers' }
WDCPharoProceduralGPUScriptEvaluator >> compileShader: shaderFileName injectingNodes: nodesToInject [
	| compiler spirv |
	compiler := 	DASLCompiler new.
	spirv := compiler 
		target: #'spir-v';
		withDebugInformation;
		optimizationLevel: 2;
		addIncludeDirectory: self shadersDirectory;
		sourceFromFileNamed: (self shadersDirectory resolve: shaderFileName asFileReference) injectingNodes: nodesToInject;
		compile;
		generatedCode.
		
	compiler ssaModule globalNamed: #main.
	spirv saveTo: 'test.spv'.
	"self halt."
	
	^ spirv

]

{ #category : #'rendering helpers' }
WDCPharoProceduralGPUScriptEvaluator >> evaluateAlbedoTextureWithExtent: anExtent [
	^ colorFunction ifNotNil: [ 
		self renderSRGBWithExtent: anExtent colorFunction: colorFunction
	] ifNil: [
		self renderSRGBWithExtent: anExtent heightFunction: heightFunction coloredWith: self colorMapFunction
	].

]

{ #category : #'rendering helpers' }
WDCPharoProceduralGPUScriptEvaluator >> evaluateAmbientOcclusionTextureWithExtent: anExtent [
	(ambientOcclusionRadius isNil or: [ ambientOcclusionHeightThreshold isNil ]) ifTrue: [ ^ nil ].
	^ self renderAmbientOcclusionWithExtent: self extentForInspector heightFunction: heightFunction
]

{ #category : #'rendering helpers' }
WDCPharoProceduralGPUScriptEvaluator >> evaluateCubeMap [
	| shader |
	codeConverter := DASLPharoCodeConverter new.
	codeConverter convertFunction: colorFunction name: #colorFunction argumentTypes: #(float float float) returnType: #float4.

	hdr ifTrue: [ 
		shader := self compileShader: 'procedural/hdrCubeMapInterface.dastrel' injectingNodes: codeConverter generatedNodes.
		^ self shader: shader toCubeTextureDataExtent: textureExtent bpp: 32 format: AGPU_TEXTURE_FORMAT_B8G8R8A8_UNORM textureFetchFunctionName: #fetch_textureRGBM mipmapComputationFunctionName: #mipmap encodeFunctionName: #encode_bgrm8
	] ifFalse: [ 
		shader := self compileShader: 'procedural/coloredCubeMapInterface.dastrel' injectingNodes: codeConverter generatedNodes.
		^ self shader: shader toCubeTextureDataExtent: textureExtent bpp: 32 format: AGPU_TEXTURE_FORMAT_B8G8R8A8_UNORM_SRGB textureFetchFunctionName: #fetch_texture mipmapComputationFunctionName: #mipmap encodeFunctionName: #encode_bgra8_srgb
	].

]

{ #category : #'rendering helpers' }
WDCPharoProceduralGPUScriptEvaluator >> evaluateHeightMapTextureWithExtent: anExtent [
	^ self renderTerrainHeightMapWithExtent: anExtent
]

{ #category : #'rendering helpers' }
WDCPharoProceduralGPUScriptEvaluator >> evaluateMetallicTextureWithExtent: anExtent [
	metallicFunction ifNil: [ ^ nil ].
	^ self renderHeightMapWithExtent: self extentForInspector heightFunction: metallicFunction
]

{ #category : #'rendering helpers' }
WDCPharoProceduralGPUScriptEvaluator >> evaluateNormalMapTextureWithExtent: anExtent [
	heightFunction ifNil: [ ^ nil ].
	^ self renderNormalMapWithExtent: anExtent heightFunction: heightFunction heightScaleFactor: normalHeightScaleFactor
]

{ #category : #'rendering helpers' }
WDCPharoProceduralGPUScriptEvaluator >> evaluateRoughnessMetallicAOTextureWithExtent: anExtent [
	| hasAmbient |
	hasAmbient := ambientOcclusionRadius isNotNil and: [ ambientOcclusionHeightThreshold isNotNil ].
	(hasAmbient or: [ roughnessFunction isNotNil or: [ metallicFunction isNotNil ] ]) ifFalse: [ ^ nil ].
	
	^ hasAmbient
		ifTrue: [ self renderRoughnessMetallicAOWithExtent: self extentForInspector]
		ifFalse: [ self renderRoughnessMetallicWithExtent: self extentForInspector] 
]

{ #category : #'rendering helpers' }
WDCPharoProceduralGPUScriptEvaluator >> evaluateRoughnessTextureWithExtent: anExtent [
	roughnessFunction ifNil: [ ^ nil ].
	^ self renderHeightMapWithExtent: self extentForInspector heightFunction: roughnessFunction
]

{ #category : #'rendering helpers' }
WDCPharoProceduralGPUScriptEvaluator >> evaluateTerrainHeightMapTextureWithExtent: anExtent [
	^ self renderTerrainHeightMapWithExtent: anExtent
]

{ #category : #'rendering helpers' }
WDCPharoProceduralGPUScriptEvaluator >> evaluateTerrainSplatterMapTextureWithExtent: anExtent [
	^ self renderTerrainSplatterMapWithExtent: anExtent
]

{ #category : #'as yet unclassified' }
WDCPharoProceduralGPUScriptEvaluator >> getMainFragmentStageFrom: spirvShader [
	| lowLevelShader |
	"For debugging: spirvShader saveTo: 'generated.spv'."
	
	lowLevelShader := WDCLowLevelShaderSource new
		engine: self validEngine;
		entryFile: 'generated shader' asFileReference;
		source: spirvShader asShaderCode;
		entryPoints: spirvShader entryPoints;
		yourself.
		
	^ lowLevelShader asShaderLibrary getFragmentStage: #main
]

{ #category : #'rendering helpers' }
WDCPharoProceduralGPUScriptEvaluator >> heightFieldShaderFor: heightFunctionObject [
	codeConverter := DASLPharoCodeConverter new.
	codeConverter convertFunction: heightFunctionObject name: #heightFieldFunction argumentTypes: #(float float) returnType: #float.

	^ self compileShader: 'procedural/heightFieldTextureInterface.dastrel' injectingNodes: codeConverter generatedNodes.


]

{ #category : #'rendering helpers' }
WDCPharoProceduralGPUScriptEvaluator >> normalShaderForHeightFunction: heightFunctionObject dx: dx dy: dy heightScaleFactor: heightScaleFactor [
	| heightScaleFactorNode builder dxNode dyNode |
	
	codeConverter := DASLPharoCodeConverter new.
	codeConverter
		convertFunction: heightFunctionObject name: #heightFieldFunction argumentTypes: #(float float) returnType: #float.
	builder := DASLAstBuilder new.
			
	heightScaleFactorNode := builder constantGlobalNamed: #HeightScaleFactor typeNamed: #float value: 
		(builder literalFloat: heightScaleFactor asFloat).
	dxNode := builder constantGlobalNamed: #HeightFieldDx typeNamed: #float value: 
		(builder literalFloat: dx asFloat).
	dyNode := builder constantGlobalNamed: #HeightFieldDy typeNamed: #float value: 
		(builder literalFloat: dy asFloat).
		
	^ self compileShader: 'procedural/heightFieldToNormalMapTextureInterface.dastrel' injectingNodes: codeConverter generatedNodes , { heightScaleFactorNode . dxNode . dyNode }

]

{ #category : #'rendering helpers' }
WDCPharoProceduralGPUScriptEvaluator >> renderAmbientOcclusionWithExtent: anExtent heightFunction: aHeightFunction [
	| aoShader |
	
	aoShader := self aoShaderFor: aHeightFunction aoRadius: ambientOcclusionRadius aoHeightThreshold: ambientOcclusionHeightThreshold aoSampleCount: ambientOcclusionSampleCount.
	^ self shader: aoShader toTextureDataExtent: anExtent bpp: 8 format: AGPU_TEXTURE_FORMAT_R8_UNORM encodeFunctionName: #encode_r8.

]

{ #category : #'rendering helpers' }
WDCPharoProceduralGPUScriptEvaluator >> renderHeightMapWithExtent: anExtent heightFunction: heightFunction [
	| colorShader |
	colorShader := self heightFieldShaderFor: heightFunction.
	^ self shader: colorShader toTextureDataExtent: anExtent bpp: 8 format: AGPU_TEXTURE_FORMAT_R8_UNORM encodeFunctionName: #encode_r8
]

{ #category : #'rendering helpers' }
WDCPharoProceduralGPUScriptEvaluator >> renderNormalMapWithExtent: anExtent heightFunction: heightFunction heightScaleFactor: heightScaleFactor [
	| normalShader |
	normalShader := self normalShaderForHeightFunction: heightFunction
		dx: 1.0 / anExtent x dy: 1.0 / anExtent y heightScaleFactor: heightScaleFactor.
	^ (self shader: normalShader
		toTextureDataExtent: anExtent bpp: 32 format:
		AGPU_TEXTURE_FORMAT_B8G8R8A8_UNORM
		textureFetchFunctionName: #fetch_normalTexture
		mipmapComputationFunctionName: #mipmap_normal
		encodeFunctionName: #encode_bgra_normal)
			normalMap: true;
			yourself
]

{ #category : #'rendering helpers' }
WDCPharoProceduralGPUScriptEvaluator >> renderRoughnessMetallicAOWithExtent: anExtent [
	| rmaShader |
	
	rmaShader := self rmaShaderFor: heightFunction
		roughnessFunction: (roughnessFunction ifNil: [1.0])
		metallicFunction: (metallicFunction ifNil: [1.0])
		aoRadius: ambientOcclusionRadius aoHeightThreshold: ambientOcclusionHeightThreshold aoSampleCount: ambientOcclusionSampleCount.
	^ self shader: rmaShader toTextureDataExtent: anExtent bpp: 32 format: AGPU_TEXTURE_FORMAT_B8G8R8A8_UNORM encodeFunctionName: #encode_bgra8.

]

{ #category : #'rendering helpers' }
WDCPharoProceduralGPUScriptEvaluator >> renderRoughnessMetallicWithExtent: anExtent [
	| rmaShader |
	
	rmaShader := self roughnessMetallicShaderFor: heightFunction
		roughnessFunction: (roughnessFunction ifNil: [1.0])
		metallicFunction: (metallicFunction ifNil: [1.0]).
	^ self shader: rmaShader toTextureDataExtent: anExtent bpp: 32 format: AGPU_TEXTURE_FORMAT_B8G8R8A8_UNORM encodeFunctionName: #encode_bgra8.

]

{ #category : #'rendering helpers' }
WDCPharoProceduralGPUScriptEvaluator >> renderSRGBWithExtent: anExtent colorFunction: aColorFunction [
	| colorShader |
	colorShader := self colorShaderForFunction: aColorFunction.
	^ self shader: colorShader toTextureDataExtent: anExtent bpp: 32 format: AGPU_TEXTURE_FORMAT_B8G8R8A8_UNORM_SRGB encodeFunctionName: #encode_bgra8_srgb
]

{ #category : #'rendering helpers' }
WDCPharoProceduralGPUScriptEvaluator >> renderSRGBWithExtent: anExtent heightFunction: heightFunction coloredWith: colorFunction [
	| colorShader |
	colorShader := self colorShaderForHeightFunction: heightFunction coloredWith: colorFunction.
	^ self shader: colorShader toTextureDataExtent: anExtent bpp: 32 format: AGPU_TEXTURE_FORMAT_B8G8R8A8_UNORM_SRGB encodeFunctionName: #encode_bgra8_srgb
]

{ #category : #'rendering helpers' }
WDCPharoProceduralGPUScriptEvaluator >> renderTerrainHeightMapWithExtent: anExtent [
	| colorShader |
	colorShader := self terrainHeightFieldShaderFor: terrainFunction.
	^ self shader: colorShader toTextureDataExtent: anExtent bpp: 16 format: AGPU_TEXTURE_FORMAT_R16_SNORM encodeFunctionName: #encode_sr16
]

{ #category : #'rendering helpers' }
WDCPharoProceduralGPUScriptEvaluator >> renderTerrainSplatterMapWithExtent: anExtent [
	| colorShader |
	colorShader := self terrainSplatterMapShaderFor: terrainFunction.
	^ self shader: colorShader toTextureDataExtent: anExtent bpp: 32 format: AGPU_TEXTURE_FORMAT_B8G8R8A8_UNORM encodeFunctionName: #encode_bgra8
]

{ #category : #'rendering helpers' }
WDCPharoProceduralGPUScriptEvaluator >> rmaShaderFor: heightFunctionObject
roughnessFunction: roughnessFunctionObject metallicFunction: metallicFunctionObject
aoRadius: aoRadius aoHeightThreshold: heightThreshold aoSampleCount: sampleCount [
	| builder aoFactorNode aoHeightThresholdNode aoSampleCountNode |
	
	codeConverter := DASLPharoCodeConverter new.
	codeConverter
		convertFunction: heightFunctionObject name: #heightFieldFunction argumentTypes: #(float float) returnType: #float;
		convertFunction: roughnessFunctionObject name: #roughnessFunction argumentTypes: #(float float) returnType: #float;
		convertFunction: metallicFunctionObject name: #metallicFunction argumentTypes: #(float float) returnType: #float.
	builder := DASLAstBuilder new.
			
	aoFactorNode := builder constantGlobalNamed: #AmbientOcclusionRadius typeNamed: #float value: 
		(builder literalFloat: aoRadius asFloat).
	aoHeightThresholdNode := builder constantGlobalNamed: #AmbientOcclusionHeightThreshold typeNamed: #float value: 
		(builder literalFloat: heightThreshold asFloat).
	aoSampleCountNode := builder constantGlobalNamed: #AmbientOcclusionSampleCount typeNamed: #uint value: 
		(builder literalUInt: sampleCount asInteger).
		
	^ self compileShader: 'procedural/rmaTextureInterface.dastrel' injectingNodes: codeConverter generatedNodes , { aoFactorNode . aoHeightThresholdNode . aoSampleCountNode }

]

{ #category : #'as yet unclassified' }
WDCPharoProceduralGPUScriptEvaluator >> shader: spirvShader toCubeTextureDataExtent: extent bpp: bitsPerPixel format: pixelFormat textureFetchFunctionName: textureFetchFunctionName mipmapComputationFunctionName: mipmapComputationFunctionName encodeFunctionName: encodeFunctionName [
	| shader renderer resultTextureData resultLayer layers |
	layers := (1 to: 6) collect: [ :cubeFaceID |
		shader := self getMainFragmentStageFrom: spirvShader.
		renderer := engine resourceCache mainProceduralOfflineTextureRendererForExtent: extent.
		resultTextureData := WDCTextureData extent: extent bpp: bitsPerPixel format: pixelFormat.

		resultLayer := resultTextureData layers first.
		renderer critical: [
			renderer renderWith: [
				renderer
					cubeFaceId: cubeFaceID - 1;
					renderProceduralTextureWithFragmentShader: shader extent: extent format: pixelFormat;
					generateProceduralTextureWithExtent: extent fetchWith: textureFetchFunctionName mipmapWith: mipmapComputationFunctionName encodeWith: encodeFunctionName for: resultLayer
			];
			submit;
			finish;
			readMipmapLevelsInto: resultLayer
		].
	
		resultLayer
	].

	^ resultTextureData
		type: AGPU_TEXTURE_CUBE;
		layers: layers;
		yourself
]

{ #category : #'as yet unclassified' }
WDCPharoProceduralGPUScriptEvaluator >> shader: spirvShader toTextureDataExtent: extent bpp: bitsPerPixel format: pixelFormat encodeFunctionName: encodeFunctionName [
	^ self shader: spirvShader toTextureDataExtent: extent bpp: bitsPerPixel format: pixelFormat textureFetchFunctionName: #fetch_texture encodeFunctionName: encodeFunctionName
]

{ #category : #'as yet unclassified' }
WDCPharoProceduralGPUScriptEvaluator >> shader: spirvShader toTextureDataExtent: extent bpp: bitsPerPixel format: pixelFormat textureFetchFunctionName: textureFetchFunctionName encodeFunctionName: encodeFunctionName [
	^ self shader: spirvShader toTextureDataExtent: extent bpp: bitsPerPixel format: pixelFormat textureFetchFunctionName: textureFetchFunctionName mipmapComputationFunctionName: #mipmap encodeFunctionName: encodeFunctionName
]

{ #category : #'as yet unclassified' }
WDCPharoProceduralGPUScriptEvaluator >> shader: spirvShader toTextureDataExtent: extent bpp: bitsPerPixel format: pixelFormat textureFetchFunctionName: textureFetchFunctionName mipmapComputationFunctionName: mipmapComputationFunctionName encodeFunctionName: encodeFunctionName [
	| shader resultTextureData resultLayer renderer renderPixelFormat |
	
	shader := self getMainFragmentStageFrom: spirvShader.
	renderer := engine resourceCache mainProceduralOfflineTextureRendererForExtent: extent.
	resultTextureData := WDCTextureData extent: extent bpp: bitsPerPixel format: pixelFormat.
	renderPixelFormat := pixelFormat.
	"renderPixelFormat == AGPU_TEXTURE_FORMAT_R16_SNORM ifTrue: [
		renderPixelFormat := AGPU_TEXTURE_FORMAT_R32_FLOAT
	]."

	resultLayer := resultTextureData layers first.

	renderer critical: [
		renderer renderWith: [
			renderer
				renderProceduralTextureWithFragmentShader: shader extent: extent format: renderPixelFormat;
				generateProceduralTextureWithExtent: extent fetchWith: textureFetchFunctionName mipmapWith: mipmapComputationFunctionName encodeWith: encodeFunctionName for: resultLayer
			];
			submit;
			finish;
			readMipmapLevelsInto: resultLayer
	].

	^ resultTextureData

]

{ #category : #'rendering helpers' }
WDCPharoProceduralGPUScriptEvaluator >> shadersDirectory [
	^ WodenCoreAssets location / #shaders
]

{ #category : #'rendering helpers' }
WDCPharoProceduralGPUScriptEvaluator >> terrainHeightFieldShaderFor: heightFunctionObject [
	| minHeight maxHeight invRange builder constantNodes centerHeight coordinateTransform coordinateScale coordinateOffset |
	coordinateTransform := self terrainCoordinateTransform.
	coordinateScale := coordinateTransform first.
	coordinateOffset := coordinateTransform second.

	codeConverter := DASLPharoCodeConverter new.
	codeConverter convertFunction: heightFunctionObject name: #terrainGenerationFunction argumentTypes: #(float float) returnType: #(float (tuple float float float float float)).

	minHeight := self terrainData minHeight.
	maxHeight := self terrainData maxHeight.
	centerHeight := (minHeight + maxHeight) * 0.5.
	invRange := (maxHeight closeTo: minHeight)
		ifTrue: [ 0.0 ]
		ifFalse: [ (maxHeight - centerHeight) reciprocal ].
		
	builder := DASLAstBuilder new.
	constantNodes := {
	 builder constantGlobalNamed: #HeightMapScale typeNamed: #float2 value:
		(builder listLiteralWith: {
			builder literalFloat: coordinateScale x . builder literalFloat: coordinateScale y
			}).
	 builder constantGlobalNamed: #HeightMapOffset typeNamed: #float2 value:
		(builder listLiteralWith: {
			builder literalFloat: coordinateOffset y . builder literalFloat: coordinateOffset y
			}).
	 builder constantGlobalNamed: #HeightScaleMinValue typeNamed: #float value: 
		(builder literalFloat: minHeight asFloat).
	 builder constantGlobalNamed: #HeightScaleMaxValue typeNamed: #float value: 
		(builder literalFloat: maxHeight asFloat).
	 builder constantGlobalNamed: #HeightScaleCenterValue typeNamed: #float value: 
		(builder literalFloat: centerHeight asFloat).
	 builder constantGlobalNamed: #HeightScaleInvRange typeNamed: #float value: 
		(builder literalFloat: invRange asFloat).
	}.


	^ self compileShader: 'procedural/terrainHeightMapTextureInterface.dastrel' injectingNodes:  constantNodes , codeConverter generatedNodes.


]

{ #category : #'rendering helpers' }
WDCPharoProceduralGPUScriptEvaluator >> terrainSplatterMapShaderFor: heightFunctionObject [
	| coordinateTransform coordinateScale coordinateOffset builder constantNodes |
	coordinateTransform := self terrainCoordinateTransform.
	coordinateScale := coordinateTransform first.
	coordinateOffset := coordinateTransform second.
	
	codeConverter := DASLPharoCodeConverter new.
	codeConverter convertFunction: heightFunctionObject name: #terrainGenerationFunction argumentTypes: #(float float) returnType: #(float (tuple float float float float float)).

	builder := DASLAstBuilder new.
	constantNodes := {
	 builder constantGlobalNamed: #HeightMapScale typeNamed: #float2 value:
		(builder listLiteralWith: {
			builder literalFloat: coordinateScale x . builder literalFloat: coordinateScale y
			}).
	 builder constantGlobalNamed: #HeightMapOffset typeNamed: #float2 value:
		(builder listLiteralWith: {
			builder literalFloat: coordinateOffset y . builder literalFloat: coordinateOffset y
			}).
	}.
	
	^ self compileShader: 'procedural/terrainSplatterMapTextureInterface.dastrel' injectingNodes: codeConverter generatedNodes , constantNodes.


]

{ #category : #'rendering helpers' }
WDCPharoProceduralGPUScriptEvaluator >> textureExtent: anExtent inspectorExtent: anExtentForInspector heightFunction: heightFunction colorWith: colorFunction normalHeightScaleFactor: normalHeightScaleFactor [
	self isInInspector ifTrue: [
		^ WDCMultiTextureView new textures: { 
			'Albedo' -> (self renderSRGBWithExtent: anExtentForInspector heightFunction: heightFunction coloredWith: colorFunction).
			'Normal Map' -> (self renderNormalMapWithExtent: anExtentForInspector heightFunction: heightFunction heightScaleFactor: normalHeightScaleFactor).
			'Height Map' -> (self renderHeightMapWithExtent: anExtentForInspector heightFunction: heightFunction).
		}.

	].

	(self isAlbedoRequested or: [self isDefaultTextureRequested]) ifTrue: [ 
		^ self renderSRGBWithExtent: anExtent heightFunction: heightFunction coloredWith: colorFunction
	].

	self isNormalMapRequested ifTrue: [
		^ self renderNormalMapWithExtent: anExtentForInspector heightFunction: heightFunction heightScaleFactor: normalHeightScaleFactor.
	].

	^ nil

]
