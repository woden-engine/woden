Class {
	#name : #WDCPharoProceduralGPUScriptContext,
	#superclass : #WDCPharoProceduralScriptContext,
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Texture'
}

{ #category : #'rendering helpers' }
WDCPharoProceduralGPUScriptContext >> colorShaderForHeightFunction: heightFunction coloredWith: colorFunction [
	| heightFunctionNode colorMapFunctionNode |
	heightFunctionNode := DASLPharoBlockConverter new
		functionName: #heightFieldFunction;
		convertClosure: heightFunction argumentTypes: #(float float) returnType: #float.
	colorMapFunctionNode := colorFunction asDastrelColorMapFunction.

	^ self compileShader: 'procedural/coloredHeightFieldTextureInterface.dastrel' injectingNodes: { heightFunctionNode . colorMapFunctionNode }

]

{ #category : #'rendering helpers' }
WDCPharoProceduralGPUScriptContext >> compileShader: shaderFileName injectingNodes: nodesToInject [
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

{ #category : #'as yet unclassified' }
WDCPharoProceduralGPUScriptContext >> getMainFragmentStageFrom: spirvShader [
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
WDCPharoProceduralGPUScriptContext >> heightFieldShaderFor: heightFunction [
	| heightFunctionNode |
	heightFunctionNode := DASLPharoBlockConverter new
		functionName: #heightFieldFunction;
		convertClosure: heightFunction argumentTypes: #(float float) returnType: #float.

	^ self compileShader: 'procedural/heightFieldTextureInterface.dastrel' injectingNodes: { heightFunctionNode }

]

{ #category : #'rendering helpers' }
WDCPharoProceduralGPUScriptContext >> normalShaderForHeightFunction: heightFunction dx: dx dy: dy heightScaleFactor: heightScaleFactor [
	| heightFunctionNode heightScaleFactorNode builder dxNode dyNode |
	heightFunctionNode := DASLPharoBlockConverter new
		functionName: #heightFieldFunction;
		convertClosure: heightFunction argumentTypes: #(float float) returnType: #float.

	builder := DASLAstBuilder new.
			
	heightScaleFactorNode := builder constantGlobalNamed: #HeightScaleFactor typeNamed: #float value: 
		(builder literalFloat: heightScaleFactor asFloat).
	dxNode := builder constantGlobalNamed: #HeightFieldDx typeNamed: #float value: 
		(builder literalFloat: dx asFloat).
	dyNode := builder constantGlobalNamed: #HeightFieldDy typeNamed: #float value: 
		(builder literalFloat: dy asFloat).
		
	^ self compileShader: 'procedural/heightFieldToNormalMapTextureInterface.dastrel' injectingNodes: { heightFunctionNode . heightScaleFactorNode . dxNode . dyNode }

]

{ #category : #'rendering helpers' }
WDCPharoProceduralGPUScriptContext >> renderHeightMapWithExtent: anExtent heightFunction: heightFunction [
	| colorShader |
	colorShader := self heightFieldShaderFor: heightFunction.
	^ self shader: colorShader toTextureDataExtent: anExtent bpp: 8 format: AGPU_TEXTURE_FORMAT_R8_UNORM encodeFunctionName: #encode_r8
]

{ #category : #'rendering helpers' }
WDCPharoProceduralGPUScriptContext >> renderNormalMapWithExtent: anExtent heightFunction: heightFunction heightScaleFactor: heightScaleFactor [
	| normalShader |
	normalShader := self normalShaderForHeightFunction: heightFunction
		dx: 1.0 / anExtent x dy: 1.0 / anExtent y heightScaleFactor: heightScaleFactor.
	^ self shader: normalShader toTextureDataExtent: anExtent bpp: 32 format: AGPU_TEXTURE_FORMAT_B8G8R8A8_UNORM encodeFunctionName: #encode_bgra8
]

{ #category : #'rendering helpers' }
WDCPharoProceduralGPUScriptContext >> renderSRGBWithExtent: anExtent heightFunction: heightFunction coloredWith: colorFunction [
	| colorShader |
	colorShader := self colorShaderForHeightFunction: heightFunction coloredWith: colorFunction.
	^ self shader: colorShader toTextureDataExtent: anExtent bpp: 32 format: AGPU_TEXTURE_FORMAT_B8G8R8A8_UNORM_SRGB encodeFunctionName: #encode_bgra8_srgb
]

{ #category : #'as yet unclassified' }
WDCPharoProceduralGPUScriptContext >> shader: spirvShader toTextureDataExtent: extent bpp: bitsPerPixel format: pixelFormat encodeFunctionName: encodeFunctionName [
	| texture commandAllocator commandList stateTracker shader shaderArguments renderTarget resultDataBuffer mipmapGenerationLibrary mipmapDataBuffer resultTextureData resultLayer sourceLevelIndex destLevelIndex sourceLevel pushConstantBuffer |
	
	shader := self getMainFragmentStageFrom: spirvShader.

	texture := engine resourceCache proceduralTemporaryRenderTargetWithExtent: extent pixelFormat: pixelFormat.
	mipmapDataBuffer := engine resourceCache proceduralTextureTemporaryMipmapBufferWithExtent: extent.
	resultDataBuffer := engine resourceCache proceduralTextureTemporaryResultBufferWithExtent: extent.
	shaderArguments := engine resourceCache proceduralTextureMipmapGenerationParameters.
	mipmapGenerationLibrary := engine resourceCache proceduralMipmapGenerationLibrary.
	shaderArguments
		sampledTexture: texture slot: 0;
		storageBuffer: mipmapDataBuffer slot: 0;
		storageBuffer: resultDataBuffer slot: 1.
	
	renderTarget := WDCRenderTarget for: engine colorAttachments: {texture}.

	commandAllocator := engine createGraphicsDirectCommandListAllocator.
	commandList := commandAllocator createListNow.

	resultTextureData := WDCTextureData extent: extent bpp: bitsPerPixel format: pixelFormat.
	resultLayer := resultTextureData layers first.

	pushConstantBuffer := SLVMNativeArray for: #uint new: 6.
	
	stateTracker := WDCStateTracker for: engine.
	stateTracker commandList: commandList rebuildWith: [
		stateTracker
			beginRenderPass: renderTarget validMainRenderPass renderTarget: renderTarget;
			activateShaderSignature: (WDCCompositionShaderSignature for: engine);
			vertexShader: engine resourceCache screenQuadVertexShader;
			fragmentShader: shader;
			dispatchScreenQuadRender;
			endRenderPass;

			computeShader: (mipmapGenerationLibrary getComputeStage: #fetch_texture) arguments: shaderArguments;
			dispatchComputeGlobalGridX: extent x y: extent y;
			
			computeShader: (mipmapGenerationLibrary getComputeStage: #mipmap) arguments: shaderArguments.

		sourceLevelIndex := 0.
		sourceLevel := resultLayer levels first.
		destLevelIndex := sourceLevel pixelCount.
		
		resultLayer levels allButFirstDo: [ :destLevel |
			pushConstantBuffer replaceFrom: 1 to: 6 with: {
				sourceLevelIndex.
				sourceLevel width.
				sourceLevel height.
				destLevelIndex.
				destLevel width.
				destLevel height
			}.
			
			stateTracker
				pushConstants: 0 size: pushConstantBuffer rawDataSize values: pushConstantBuffer rawData;
				dispatchComputeGlobalGridX: destLevel width y: destLevel height.
			
			sourceLevelIndex := destLevelIndex.
			destLevelIndex := destLevelIndex + destLevel pixelCount.
			sourceLevel := destLevel
		].

		pushConstantBuffer at: 1 put: destLevelIndex.
		
		stateTracker
			pushConstants: 0 size: pushConstantBuffer rawDataSize values: pushConstantBuffer rawData;
			computeShader: (mipmapGenerationLibrary getComputeStage: encodeFunctionName) arguments: shaderArguments;
			dispatchComputeGlobalGrid: destLevelIndex
	].

	engine graphicsQueue
		addCommandList: commandList validHandle; finishExecution.

	resultLayer readLevelsFromPointer: resultDataBuffer validPointer.
	^ resultTextureData
]

{ #category : #'rendering helpers' }
WDCPharoProceduralGPUScriptContext >> shadersDirectory [
	^ WodenCoreAssets location / #shaders
]

{ #category : #'rendering helpers' }
WDCPharoProceduralGPUScriptContext >> textureExtent: anExtent inspectorExtent: anExtentForInspector heightFunction: heightFunction colorWith: colorFunction normalHeightScaleFactor: normalHeightScaleFactor [
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
