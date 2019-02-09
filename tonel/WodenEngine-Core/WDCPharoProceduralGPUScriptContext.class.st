Class {
	#name : #WDCPharoProceduralGPUScriptContext,
	#superclass : #WDCPharoProceduralScriptContext,
	#category : #'WodenEngine-Core-Texture'
}

{ #category : #'rendering helpers' }
WDCPharoProceduralGPUScriptContext >> textureExtent: anExtent inspectorExtent: anExtentForInspector heightFunction: heightFunction colorWith: colorFunction normalHeightScaleFactor: normalHeightScaleFactor [
	| gpuHeightFunction compiler spirv |
	gpuHeightFunction := DASLPharoBlockConverter new
		functionName: #heightFieldFunction;
		convertClosure: heightFunction argumentTypes: #(float float) returnType: #float.

	compiler := 	DASLCompiler new.
	spirv := compiler 
		target: #'spir-v';
		sourceFromFileNamed: 'core-assets/shaders/procedural/grayScaleInterface.dastrel' injectingNodes: {gpuHeightFunction};
		compile;
		generatedCode.
	^ spirv
]
