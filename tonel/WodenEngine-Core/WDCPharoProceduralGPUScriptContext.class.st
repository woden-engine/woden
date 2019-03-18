Class {
	#name : #WDCPharoProceduralGPUScriptContext,
	#superclass : #WDCPharoProceduralScriptContext,
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Texture'
}

{ #category : #'rendering helpers' }
WDCPharoProceduralGPUScriptContext >> compileShader: shaderFileName injectingNodes: nodesToInject [
	| compiler spirv |
	compiler := 	DASLCompiler new.
	spirv := compiler 
		target: #'spir-v';
		addIncludeDirectory: self shadersDirectory;
		sourceFromFileNamed: (self shadersDirectory resolve: shaderFileName asFileReference) injectingNodes: nodesToInject;
		compile;
		generatedCode.
	^ spirv

]

{ #category : #'as yet unclassified' }
WDCPharoProceduralGPUScriptContext >> getMainComputeStageFrom: spirvShader engine: engine [
	| lowLevelShader |
	"For debugging: spirvShader saveTo: 'generated.spv'."
	
	lowLevelShader := WDCLowLevelShaderSource new
		engine: engine;
		entryFile: 'generated shader' asFileReference;
		source: spirvShader asShaderCode;
		entryPoints: spirvShader entryPoints;
		yourself.
		
	^ lowLevelShader asShaderLibrary getComputeStage: #main
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
WDCPharoProceduralGPUScriptContext >> shaderToFormImage: spirvShader [
	| engine extent texture commandAllocator commandList stateTracker form pitch slicePitch shader shaderArguments |
	engine := WDCEngine default.
	
	shader := self getMainComputeStageFrom: spirvShader engine: engine.

	extent := 512@512.
	texture := engine createBGRAStorageImageWithExtent: extent.

	shaderArguments := engine newGenericComputeShaderArguments
		storageImage: texture slot: 0;
		yourself.

	commandAllocator := engine createGraphicsDirectCommandListAllocator.
	commandList := commandAllocator createListNow.

	stateTracker := WDCStateTracker for: engine.
	stateTracker commandList: commandList rebuildWith: [
		stateTracker
			computeShader: shader arguments: shaderArguments;
			dispatchComputeGlobalGridX: extent x y: extent y
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
	| heightFieldShader |
	heightFieldShader := self heightFieldShaderFor: heightFunction.
	^ self shaderToFormImage: heightFieldShader
]
