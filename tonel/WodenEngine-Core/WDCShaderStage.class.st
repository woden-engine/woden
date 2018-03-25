"
I represent an actual  instance of a shader stage.
"
Class {
	#name : #WDCShaderStage,
	#superclass : #Object,
	#instVars : [
		'source',
		'handle',
		'engine',
		'shaderLanguageTarget',
		'stage',
		'dependantPipelines',
		'dependantPipelinesMutex'
	],
	#category : 'WodenEngine-Core-Shaders'
}

{ #category : #adding }
WDCShaderStage >> addDependantPipelineState: state [
	dependantPipelinesMutex critical: [
		dependantPipelines add: state
	]
]

{ #category : #compiling }
WDCShaderStage >> compile [
	| newHandle oldHandle |
	newHandle := engine device createShader: stage.
	newHandle setShaderSource: shaderLanguageTarget sourceText: source source sourceTextLength: source source size.
	newHandle compileShader: ''.

	oldHandle := handle.
	handle := newHandle.
	
	oldHandle release.
]

{ #category : #accessing }
WDCShaderStage >> engine [
	^ engine
]

{ #category : #accessing }
WDCShaderStage >> engine: anObject [
	engine := anObject
]

{ #category : #accessing }
WDCShaderStage >> handle [
	^ handle
]

{ #category : #accessing }
WDCShaderStage >> handle: anObject [
	handle := anObject
]

{ #category : #initialization }
WDCShaderStage >> initialize [
	super initialize.
	dependantPipelinesMutex := Semaphore forMutualExclusion.
	dependantPipelines := IdentitySet new.
	
]

{ #category : #accessing }
WDCShaderStage >> name [
	^ source name
]

{ #category : #printing }
WDCShaderStage >> printOn: aStream [
	aStream print: self name
]

{ #category : #compiling }
WDCShaderStage >> reload [
	self compile.
	dependantPipelinesMutex critical: [
		dependantPipelines do: #reload
	]
]

{ #category : #accessing }
WDCShaderStage >> shaderLanguageTarget [
	^ shaderLanguageTarget
]

{ #category : #accessing }
WDCShaderStage >> shaderLanguageTarget: anObject [
	shaderLanguageTarget := anObject
]

{ #category : #accessing }
WDCShaderStage >> source [
	^ source
]

{ #category : #accessing }
WDCShaderStage >> source: anObject [
	source := anObject
]

{ #category : #accessing }
WDCShaderStage >> stage [
	^ stage
]

{ #category : #accessing }
WDCShaderStage >> stage: anObject [
	stage := anObject
]

{ #category : #accessing }
WDCShaderStage >> validHandle [
	^ handle
]
