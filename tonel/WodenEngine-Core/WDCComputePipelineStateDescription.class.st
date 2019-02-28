Class {
	#name : #WDCComputePipelineStateDescription,
	#superclass : #Object,
	#instVars : [
		'shaderSignature',
		'isChanged',
		'computeShader'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Rendering'
}

{ #category : #comparing }
WDCComputePipelineStateDescription >> = other [
	self class == other class ifFalse: [ ^ false ].
	
	computeShader == other computeShader ifFalse: [ ^ false ].
	shaderSignature == other shaderSignature ifFalse: [ ^ false ].
	^ true

]

{ #category : #adding }
WDCComputePipelineStateDescription >> addDependantPipelineStateToShaders: pipelineState [
	computeShader ifNotNil: [ :shader | shader addDependantPipelineState: pipelineState ].
]

{ #category : #building }
WDCComputePipelineStateDescription >> buildError: errorMessage [
	^ WDCPipelineBuildError new
			pipelineDescription: self;
			signal: errorMessage

]

{ #category : #building }
WDCComputePipelineStateDescription >> buildForDevice: device [
	| builder result logErrorLength logErrorBuffer |
	builder := device createComputePipelineBuilder.

	"Shaders"
	shaderSignature ifNotNil: [ builder setShaderSignature: shaderSignature handle ].
	computeShader ifNotNil: [ builder attachShader: computeShader validHandle ].
	
	result := builder build.
	result ifNil: [
		logErrorLength := builder getBuildingLogLength.
		logErrorBuffer := ExternalAddress gcallocate: logErrorLength.
		builder getBuildingLog: logErrorLength buffer: logErrorBuffer.
		self buildError: logErrorBuffer readString.
	].

	^ result
]

{ #category : #updating }
WDCComputePipelineStateDescription >> changed [
	isChanged := true
]

{ #category : #accessing }
WDCComputePipelineStateDescription >> computeShader [
	^ computeShader
]

{ #category : #accessing }
WDCComputePipelineStateDescription >> computeShader: aShader [
	aShader ~~ computeShader ifTrue: [ 
		self changed
	].

	computeShader := aShader
]

{ #category : #comparing }
WDCComputePipelineStateDescription >> hash [
	| result |
	result := self class identityHash.
	result := result bitXor: computeShader identityHash.
	result := result bitXor: shaderSignature identityHash.
	^ result
]

{ #category : #initialization }
WDCComputePipelineStateDescription >> initialize [
	super initialize.
	self reset
]

{ #category : #accessing }
WDCComputePipelineStateDescription >> isChanged [
	^ isChanged
]

{ #category : #accessing }
WDCComputePipelineStateDescription >> isChanged: anObject [
	isChanged := anObject
]

{ #category : #initialization }
WDCComputePipelineStateDescription >> reset [
	isChanged := true.
	shaderSignature := nil.
	computeShader := nil.
]

{ #category : #accessing }
WDCComputePipelineStateDescription >> shaderSignature [
	^ shaderSignature
]

{ #category : #accessing }
WDCComputePipelineStateDescription >> shaderSignature: aShaderSignature [
	shaderSignature ~~ aShaderSignature ifTrue: [
		self changed
	].

	shaderSignature := aShaderSignature
]

{ #category : #'as yet unclassified' }
WDCComputePipelineStateDescription >> traceBuildWith: engine [
	engine trace: 'Build PSO compute: {1}.' format: {computeShader asString}.
]
