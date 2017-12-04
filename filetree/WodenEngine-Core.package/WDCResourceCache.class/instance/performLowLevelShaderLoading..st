shaders
performLowLevelShaderLoading: shaderFile
	| compiler generatedCode lowLevelShaderSource dependencies |
	compiler := 	DASLCompiler new.
	generatedCode := (compiler 
		target: shaderLanguageTargetName;
		sourceFromFileNamed: shaderFile;
		compile;
		generatedCode) asShaderCode.
		
	dependencies := compiler processedDependencies collect: #asFileReference.
	lowLevelShaderSource := WDCLowLevelShaderSource new
		entryFile: shaderFile;
		dependencies: dependencies;
		source: generatedCode.
	
	^ lowLevelShaderSource
	