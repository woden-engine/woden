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
		
	compiler ssaModule globalNamed: #main.
	spirv saveTo: 'test.spv'.
	self halt.
	^ spirv

]

{ #category : #'as yet unclassified' }
WDCPharoProceduralGPUScriptContext >> getMainFragmentStageFrom: spirvShader engine: engine [
	| lowLevelShader |
	"For debugging: spirvShader saveTo: 'generated.spv'."
	
	lowLevelShader := WDCLowLevelShaderSource new
		engine: engine;
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

{ #category : #'as yet unclassified' }
WDCPharoProceduralGPUScriptContext >> shader: spirvShader toFormWithExtent: extent format: format [
	| engine texture commandAllocator commandList stateTracker form pitch slicePitch shader shaderArguments renderTarget |
	engine := WDCEngine default.
	
	shader := self getMainFragmentStageFrom: spirvShader engine: engine.

	texture := engine createTexture: (AGPUTextureDescription new
		type: AGPU_TEXTURE_2D;
		format: format;
		width: extent x;
		height: extent y;
		depthOrArraySize: 1;
		miplevels: 1;
		sample_count: 1;
		sample_quality: 0;
		flags: AGPU_TEXTURE_FLAG_READED_BACK | AGPU_TEXTURE_FLAG_RENDERBUFFER_ONLY | AGPU_TEXTURE_FLAG_RENDER_TARGET;
		yourself
	).
	
	renderTarget := WDCRenderTarget for: engine colorAttachments: {texture}.

	commandAllocator := engine createGraphicsDirectCommandListAllocator.
	commandList := commandAllocator createListNow.

	stateTracker := WDCStateTracker for: engine.
	stateTracker commandList: commandList rebuildWith: [
		stateTracker
			beginRenderPass: renderTarget validMainRenderPass renderTarget: renderTarget;
			activateShaderSignature: (WDCCompositionShaderSignature for: engine);
			vertexShader: engine resourceCache screenQuadVertexShader;
			fragmentShader: shader;
			dispatchScreenQuadRender;
			endRenderPass
	].

	engine graphicsQueue
		addCommandList: commandList validHandle; finishExecution.

	form := Form extent: extent depth: 32.
	pitch := form width * 4.
	slicePitch := pitch * form height.
	form unhibernate.
	texture validHandle readTextureData: 0 arrayIndex: 0 pitch: pitch slicePitch: slicePitch buffer: 	form bits.
	^ form
]

{ #category : #'rendering helpers' }
WDCPharoProceduralGPUScriptContext >> shadersDirectory [
	^ WodenCoreAssets location / #shaders
]

{ #category : #'rendering helpers' }
WDCPharoProceduralGPUScriptContext >> textureExtent: anExtent inspectorExtent: anExtentForInspector heightFunction: heightFunction colorWith: colorFunction normalHeightScaleFactor: normalHeightScaleFactor [
	| colorShader |
	colorShader := self colorShaderForHeightFunction: heightFunction coloredWith: colorFunction.
	^ self shader: colorShader toFormWithExtent: anExtent format: (
	colorFunction isGrayscaleColorMap
		ifTrue: [ AGPU_TEXTURE_FORMAT_B8G8R8A8_UNORM ]
		ifFalse: [ AGPU_TEXTURE_FORMAT_B8G8R8A8_UNORM_SRGB ]
	)
]
