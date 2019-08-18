Class {
	#name : #WDCSimpleParticleMaterial,
	#superclass : #WDCMaterial,
	#instVars : [
		'vertexShader',
		'fragmentShader',
		'shaderLibrary',
		'proceduralRenderingBlock'
	],
	#category : #'WodenEngine-Core-Material'
}

{ #category : #rendering }
WDCSimpleParticleMaterial >> activateForwardOn: stateTracker [
	stateTracker
		vertexShader: self vertexShader;
		fragmentShader: self fragmentShader;
		materialBlendingMode: WDCBlendingMode premultipliedAlphaOver.
		
	stateTracker
		materialDepthWriteMask: false.

	^ true
]

{ #category : #accessing }
WDCSimpleParticleMaterial >> createProceduralRenderingFragmentShader [
	| codeConverter compiler spirvShader lowLevelShader particleRenderingShaderLibrary |
	codeConverter := DASLPharoCodeConverter new.
	codeConverter
		convertFunction: proceduralRenderingBlock name: #particleRenderingFunction argumentTypes: #((ref WDCParticleState) uint float float) returnType: #float4.

	compiler := 	DASLCompiler new.
	spirvShader := compiler 
		target: #'spir-v';
		withDebugInformation;
		optimizationLevel: 2;
		addIncludeDirectory: self shadersDirectory;
		sourceFromFileNamed: (self shadersDirectory resolve: 'particle/rendering-interface.dastrel' asFileReference) injectingNodes: codeConverter generatedNodes;
		compile;
		generatedCode.
		
	"spirvShader saveTo: 'particles.spv'."
	
	lowLevelShader := WDCLowLevelShaderSource new
		engine: engine;
		entryFile: 'generated shader' asFileReference;
		source: spirvShader asShaderCode;
		entryPoints: spirvShader entryPoints;
		yourself.
		
	particleRenderingShaderLibrary := lowLevelShader asShaderLibrary.
	fragmentShader := particleRenderingShaderLibrary getFragmentStage: 'particleFragment'.
]

{ #category : #accessing }
WDCSimpleParticleMaterial >> fragmentShader [

	fragmentShader ifNil: [ 
		proceduralRenderingBlock ifNotNil: [
			self tryToCreateProceduralRenderingFragmentShader
		].
		
		fragmentShader ifNil: [ 
			fragmentShader := self shaderLibrary getFragmentStage: #particleFragment
		].
	].

	^ fragmentShader
]

{ #category : #accessing }
WDCSimpleParticleMaterial >> proceduralRenderingBlock [
	^ proceduralRenderingBlock
]

{ #category : #accessing }
WDCSimpleParticleMaterial >> proceduralRenderingBlock: anObject [
	proceduralRenderingBlock == anObject ifTrue: [ ^ self ].
	proceduralRenderingBlock := anObject.
	fragmentShader := nil
]

{ #category : #accessing }
WDCSimpleParticleMaterial >> shaderLibrary [
	^ shaderLibrary ifNil: [ shaderLibrary := engine loadShaderLibrary: 'shaders/material/simple-particle.dastrel' ].

]

{ #category : #accessing }
WDCSimpleParticleMaterial >> shadersDirectory [
	^ WodenCoreAssets location / #shaders
]

{ #category : #accessing }
WDCSimpleParticleMaterial >> tryToCreateProceduralRenderingFragmentShader [
	[self createProceduralRenderingFragmentShader] on: Error do: [ :e | e freeze debug ]
]

{ #category : #accessing }
WDCSimpleParticleMaterial >> vertexShader [
	^ vertexShader ifNil: [vertexShader := self shaderLibrary getVertexStage: #particleVertex ]
]
