Class {
	#name : #WDCPipelineStateDescription,
	#superclass : #Object,
	#instVars : [
		'vertexShader',
		'vertexLayout',
		'fragmentShader',
		'shaderSignature',
		'primitiveType',
		'frontFaceWinding',
		'cullMode',
		'depthEnabled',
		'depthWriteMask',
		'depthFunction',
		'isChanged',
		'renderTargetFormats',
		'depthStencilFormat',
		'blendingStates',
		'sampleCount'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : 'WodenEngine-Core-Rendering'
}

{ #category : #comparing }
WDCPipelineStateDescription >> = other [
	self class == other class ifFalse: [ ^ false ].
	
	vertexShader == other vertexShader ifFalse: [ ^ false ].
	vertexLayout == other vertexLayout ifFalse: [ ^ false ].
	fragmentShader == other fragmentShader ifFalse: [ ^ false ].
	shaderSignature == other shaderSignature ifFalse: [ ^ false ].

	primitiveType = other primitiveType ifFalse: [ ^ false ].
	frontFaceWinding = other frontFaceWinding ifFalse: [ ^ false ].
	cullMode = other cullMode ifFalse: [ ^ false ].

	depthEnabled = other depthEnabled ifFalse: [ ^ false ].
	depthWriteMask = other depthWriteMask ifFalse: [ ^ false ].
	depthFunction = other depthFunction ifFalse: [ ^ false ].

	renderTargetFormats = other renderTargetFormats ifFalse: [ ^ false ].
	depthStencilFormat = other depthStencilFormat ifFalse: [ ^ false ].
	blendingStates = other blendingStates ifFalse: [ ^ false ].
	sampleCount = other sampleCount ifFalse: [ ^ false ].
	^ true

]

{ #category : #accessing }
WDCPipelineStateDescription >> blendingStates [
	^ blendingStates
]

{ #category : #accessing }
WDCPipelineStateDescription >> blendingStates: newBlendingStates [
	blendingStates ~= newBlendingStates ifTrue: [ self changed ].
	blendingStates := newBlendingStates
]

{ #category : #building }
WDCPipelineStateDescription >> buildError: errorMessage [
	^ WDCPipelineBuildError new
			pipelineDescription: self;
			signal: errorMessage

]

{ #category : #building }
WDCPipelineStateDescription >> buildForDevice: device [
	| builder result logErrorLength logErrorBuffer |
	builder := device createPipelineBuilder.

	"Shaders"
	shaderSignature ifNotNil: [ builder setShaderSignature: shaderSignature handle ].
	vertexShader ifNotNil: [ builder attachShader: vertexShader validHandle ].
	fragmentShader ifNotNil: [ builder attachShader: fragmentShader validHandle ].
	vertexLayout ifNotNil: [ builder setVertexLayout: vertexLayout validHandle ].

	"Primitives"
	builder
		setPrimitiveType: primitiveType;
		setFrontFace: frontFaceWinding;
		setCullMode: cullMode.
	
	"Render targets"
	builder setRenderTargetCount: renderTargetFormats size.
	renderTargetFormats doWithIndex: [ :format :index |
		builder setRenderTargetFormat: index - 1 format: format
	].

	builder setDepthStencilFormat: depthStencilFormat.
	builder setSampleDescription: sampleCount sample_quality: 0.
	blendingStates do: [ :blendingState |
		blendingState applyOn: builder.
	].

	"Depth buffer"
	builder setDepthState: depthEnabled writeMask: depthWriteMask function: depthFunction.
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
WDCPipelineStateDescription >> changed [
	isChanged := true
]

{ #category : #accessing }
WDCPipelineStateDescription >> cullMode [
	^ cullMode
]

{ #category : #accessing }
WDCPipelineStateDescription >> cullMode: newCullMode [
	cullMode ~= newCullMode ifTrue: [ self changed ].
	cullMode := newCullMode
]

{ #category : #accessing }
WDCPipelineStateDescription >> depthEnabled [
	^ depthEnabled
]

{ #category : #accessing }
WDCPipelineStateDescription >> depthEnabled: aBoolean [
	depthEnabled ~= aBoolean ifTrue: [ self changed ].
	depthEnabled := aBoolean
]

{ #category : #accessing }
WDCPipelineStateDescription >> depthFunction [
	^ depthFunction
]

{ #category : #accessing }
WDCPipelineStateDescription >> depthFunction: newDepthFunction [
	depthFunction ~= newDepthFunction ifTrue: [ self changed ].
	depthFunction := newDepthFunction
]

{ #category : #accessing }
WDCPipelineStateDescription >> depthStencilFormat [
	^ depthStencilFormat
]

{ #category : #accessing }
WDCPipelineStateDescription >> depthStencilFormat: newDepthStencilFormat [
	depthStencilFormat ~= newDepthStencilFormat ifTrue: [ self changed ].
	depthStencilFormat := newDepthStencilFormat
]

{ #category : #accessing }
WDCPipelineStateDescription >> depthWriteMask [
	^ depthWriteMask
]

{ #category : #accessing }
WDCPipelineStateDescription >> depthWriteMask: newDepthWriteMask [
	depthWriteMask ~= newDepthWriteMask ifTrue: [ self changed ].
	depthWriteMask := newDepthWriteMask
]

{ #category : #accessing }
WDCPipelineStateDescription >> fragmentShader [
	^ fragmentShader
]

{ #category : #accessing }
WDCPipelineStateDescription >> fragmentShader: newFragmentShader [
	fragmentShader ~~ newFragmentShader ifTrue: [ self changed ].
	fragmentShader := newFragmentShader.
]

{ #category : #accessing }
WDCPipelineStateDescription >> frontFaceWinding [
	^ frontFaceWinding
]

{ #category : #accessing }
WDCPipelineStateDescription >> frontFaceWinding: newFrontFaceWinding [
	frontFaceWinding ~= newFrontFaceWinding ifTrue: [ self changed ].
	frontFaceWinding := newFrontFaceWinding
]

{ #category : #comparing }
WDCPipelineStateDescription >> hash [
	| result |
	result := self class identityHash.
	result := result bitXor: vertexShader identityHash.
	result := result bitXor: vertexLayout identityHash.
	result := result bitXor: fragmentShader identityHash.
	result := result bitXor: shaderSignature identityHash.

	result := result bitXor: primitiveType hash.
	result := result bitXor: frontFaceWinding hash.
	result := result bitXor: cullMode hash.

	result := result bitXor: depthEnabled hash.
	result := result bitXor: depthWriteMask hash.
	result := result bitXor: depthFunction hash.

	result := result bitXor: renderTargetFormats hash.
	result := result bitXor: depthStencilFormat hash.
	result := result bitXor: blendingStates hash.
	result := result bitXor: sampleCount hash.

	^ result
]

{ #category : #initialization }
WDCPipelineStateDescription >> initialize [
	super initialize.
	
	self reset
]

{ #category : #accessing }
WDCPipelineStateDescription >> isChanged [
	^ isChanged
]

{ #category : #accessing }
WDCPipelineStateDescription >> isChanged: aBoolean [
	isChanged := aBoolean
]

{ #category : #accessing }
WDCPipelineStateDescription >> primitiveType [
	^ primitiveType
]

{ #category : #accessing }
WDCPipelineStateDescription >> primitiveType: newPrimitiveType [
	primitiveType ~= newPrimitiveType ifTrue: [ self changed ].
	primitiveType := newPrimitiveType
]

{ #category : #accessing }
WDCPipelineStateDescription >> renderTargetFormats [
	^ renderTargetFormats
]

{ #category : #accessing }
WDCPipelineStateDescription >> renderTargetFormats: newRenderTargetFormats [
	renderTargetFormats ~= newRenderTargetFormats ifTrue: [ self changed ].
	renderTargetFormats := newRenderTargetFormats
]

{ #category : #initialization }
WDCPipelineStateDescription >> reset [
	isChanged := true.
	shaderSignature := nil.
	vertexShader := nil.
	fragmentShader := nil.
	vertexLayout := nil.
	
	frontFaceWinding := AGPU_COUNTER_CLOCKWISE.
	cullMode := AGPU_CULL_MODE_NONE.
	primitiveType := AGPU_POINTS.
	
	depthEnabled := false.
	depthWriteMask := false.
	depthFunction := AGPU_ALWAYS.
	
	renderTargetFormats := #().
	depthStencilFormat := AGPU_TEXTURE_FORMAT_UNKNOWN.
	blendingStates := #().
	sampleCount := 1.

]

{ #category : #accessing }
WDCPipelineStateDescription >> sampleCount [
	^ sampleCount
]

{ #category : #accessing }
WDCPipelineStateDescription >> sampleCount: newSampleCount [
	newSampleCount ~= sampleCount ifTrue: [ self changed ].
	sampleCount := newSampleCount
]

{ #category : #accessing }
WDCPipelineStateDescription >> shaderSignature [
	^ shaderSignature
]

{ #category : #accessing }
WDCPipelineStateDescription >> shaderSignature: newShaderSignature [
	fragmentShader ~~ newShaderSignature ifTrue: [ self changed ].
	shaderSignature := newShaderSignature
]

{ #category : #accessing }
WDCPipelineStateDescription >> vertexLayout [
	^ vertexLayout
]

{ #category : #accessing }
WDCPipelineStateDescription >> vertexLayout: newVertexLayout [
	vertexLayout ~~ newVertexLayout ifTrue: [ self changed ].
	vertexLayout := newVertexLayout
]

{ #category : #accessing }
WDCPipelineStateDescription >> vertexShader [
	^ vertexShader
]

{ #category : #accessing }
WDCPipelineStateDescription >> vertexShader: newVertexShader [
	vertexShader ~~ newVertexShader ifTrue: [ self changed ].
	vertexShader := newVertexShader
]
