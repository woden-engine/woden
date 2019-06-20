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
		
	"compiler ssaModule globalNamed: #main.
	spirv saveTo: 'test.spv'.
	self halt."
	
	^ spirv

]

{ #category : #'rendering helpers' }
WDCPharoProceduralGPUScriptEvaluator >> evaluate [
	cubeMap ifTrue: [ ^ self evaluateCubeMap ].
	self isInInspector ifTrue: [
		^ WDCMultiTextureView new textures: { 
			'Albedo' -> (self renderAlbedoWithExtent: self extentForInspector).
			'Normal Map' -> (self renderNormalMapWithExtent: self extentForInspector heightFunction: heightFunction heightScaleFactor: normalHeightScaleFactor).
			'Height Map' -> (self renderHeightMapWithExtent: self extentForInspector heightFunction: heightFunction).
		}.

	].

	(self isAlbedoRequested or: [self isDefaultTextureRequested]) ifTrue: [ 
		^ self renderAlbedoWithExtent: textureExtent
	].

	self isNormalMapRequested ifTrue: [
		^ self renderNormalMapWithExtent: textureExtent heightFunction: heightFunction heightScaleFactor: normalHeightScaleFactor.
	].

	^ nil

]

{ #category : #'rendering helpers' }
WDCPharoProceduralGPUScriptEvaluator >> evaluateCubeMap [
	| shader |
	codeConverter := DASLPharoCodeConverter new.
	codeConverter convertFunction: colorFunction name: #colorFunction argumentTypes: #(float float float) returnType: #float4.

	shader := self compileShader: 'procedural/coloredCubeMapInterface.dastrel' injectingNodes: codeConverter generatedNodes.
	^ self shader: shader toCubeTextureDataExtent: textureExtent bpp: 32 format: AGPU_TEXTURE_FORMAT_B8G8R8A8_UNORM_SRGB textureFetchFunctionName: #fetch_texture mipmapComputationFunctionName: #mipmap encodeFunctionName: #encode_bgra8_srgb
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
WDCPharoProceduralGPUScriptEvaluator >> renderAlbedoWithExtent: anExtent [
	^ colorFunction ifNotNil: [ 
		self renderSRGBWithExtent: anExtent colorFunction: colorFunction
	] ifNil: [
		self renderSRGBWithExtent: anExtent heightFunction: heightFunction coloredWith: self colorMapFunction
	].

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
	| shader resultTextureData resultLayer renderer |
	
	shader := self getMainFragmentStageFrom: spirvShader.
	renderer := engine resourceCache mainProceduralOfflineTextureRendererForExtent: extent.
	resultTextureData := WDCTextureData extent: extent bpp: bitsPerPixel format: pixelFormat.
	resultLayer := resultTextureData layers first.

	renderer critical: [
		renderer renderWith: [
			renderer
				renderProceduralTextureWithFragmentShader: shader extent: extent format: pixelFormat;
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
