Class {
	#name : #WDCGraphicsPipelineStateDescription,
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
		'sampleCount',
		'depthBiasConstant',
		'depthBiasSlope',
		'polygonMode'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Rendering'
}

{ #category : #comparing }
WDCGraphicsPipelineStateDescription >> = other [
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
	
	depthBiasConstant = other depthBiasConstant ifFalse: [ ^ false ].
	depthBiasSlope = other depthBiasSlope ifFalse: [ ^ false ].
	polygonMode = other polygonMode ifFalse: [ ^ false ].
	^ true

]

{ #category : #adding }
WDCGraphicsPipelineStateDescription >> addDependantPipelineStateToShaders: pipelineState [
	vertexShader ifNotNil: [ :shader | shader addDependantPipelineState: pipelineState ].
	fragmentShader ifNotNil: [ :shader | shader addDependantPipelineState: pipelineState ].
]

{ #category : #accessing }
WDCGraphicsPipelineStateDescription >> blendingStates [
	^ blendingStates
]

{ #category : #accessing }
WDCGraphicsPipelineStateDescription >> blendingStates: newBlendingStates [
	blendingStates ~= newBlendingStates ifTrue: [ self changed ].
	blendingStates := newBlendingStates
]

{ #category : #building }
WDCGraphicsPipelineStateDescription >> buildError: errorMessage [
	^ WDCPipelineBuildError new
			pipelineDescription: self;
			signal: errorMessage

]

{ #category : #building }
WDCGraphicsPipelineStateDescription >> buildForDevice: device [
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
	
	"Depth bias"
	depthBiasConstant ifNotNil: [ 
		builder setDepthBias: depthBiasConstant clamp: 0.0 slope_factor: depthBiasSlope
	].

	"Polygon mode"
	builder setPolygonMode: polygonMode.
	
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
WDCGraphicsPipelineStateDescription >> changed [
	isChanged := true
]

{ #category : #accessing }
WDCGraphicsPipelineStateDescription >> cullMode [
	^ cullMode
]

{ #category : #accessing }
WDCGraphicsPipelineStateDescription >> cullMode: newCullMode [
	cullMode ~= newCullMode ifTrue: [ self changed ].
	cullMode := newCullMode
]

{ #category : #accessing }
WDCGraphicsPipelineStateDescription >> depthBiasConstant [
	^ depthBiasConstant
]

{ #category : #accessing }
WDCGraphicsPipelineStateDescription >> depthBiasConstant: constant [
	depthBiasConstant ~= constant ifTrue: [ self changed ].
	depthBiasConstant := constant.
	self changed.
]

{ #category : #accessing }
WDCGraphicsPipelineStateDescription >> depthBiasSlope [
	^ depthBiasSlope
]

{ #category : #accessing }
WDCGraphicsPipelineStateDescription >> depthBiasSlope: slope [
	depthBiasSlope ~= slope ifTrue: [ self changed ].
	depthBiasSlope := slope.
	self changed.
]

{ #category : #accessing }
WDCGraphicsPipelineStateDescription >> depthEnabled [
	^ depthEnabled
]

{ #category : #accessing }
WDCGraphicsPipelineStateDescription >> depthEnabled: aBoolean [
	depthEnabled ~= aBoolean ifTrue: [ self changed ].
	depthEnabled := aBoolean
]

{ #category : #accessing }
WDCGraphicsPipelineStateDescription >> depthFunction [
	^ depthFunction
]

{ #category : #accessing }
WDCGraphicsPipelineStateDescription >> depthFunction: newDepthFunction [
	depthFunction ~= newDepthFunction ifTrue: [ self changed ].
	depthFunction := newDepthFunction
]

{ #category : #accessing }
WDCGraphicsPipelineStateDescription >> depthStencilFormat [
	^ depthStencilFormat
]

{ #category : #accessing }
WDCGraphicsPipelineStateDescription >> depthStencilFormat: newDepthStencilFormat [
	depthStencilFormat ~= newDepthStencilFormat ifTrue: [ self changed ].
	depthStencilFormat := newDepthStencilFormat
]

{ #category : #accessing }
WDCGraphicsPipelineStateDescription >> depthWriteMask [
	^ depthWriteMask
]

{ #category : #accessing }
WDCGraphicsPipelineStateDescription >> depthWriteMask: newDepthWriteMask [
	depthWriteMask ~= newDepthWriteMask ifTrue: [ self changed ].
	depthWriteMask := newDepthWriteMask
]

{ #category : #accessing }
WDCGraphicsPipelineStateDescription >> fragmentShader [
	^ fragmentShader
]

{ #category : #accessing }
WDCGraphicsPipelineStateDescription >> fragmentShader: newFragmentShader [
	fragmentShader ~~ newFragmentShader ifTrue: [ self changed ].
	fragmentShader := newFragmentShader.
]

{ #category : #accessing }
WDCGraphicsPipelineStateDescription >> frontFaceWinding [
	^ frontFaceWinding
]

{ #category : #accessing }
WDCGraphicsPipelineStateDescription >> frontFaceWinding: newFrontFaceWinding [
	frontFaceWinding ~= newFrontFaceWinding ifTrue: [ self changed ].
	frontFaceWinding := newFrontFaceWinding
]

{ #category : #comparing }
WDCGraphicsPipelineStateDescription >> hash [
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
	
	result := result bitXor: depthBiasConstant hash.
	result := result bitXor: depthBiasSlope hash.
	result := result bitXor: polygonMode hash.
	
	^ result
]

{ #category : #initialization }
WDCGraphicsPipelineStateDescription >> initialize [
	super initialize.
	
	self reset
]

{ #category : #accessing }
WDCGraphicsPipelineStateDescription >> isChanged [
	^ isChanged
]

{ #category : #accessing }
WDCGraphicsPipelineStateDescription >> isChanged: aBoolean [
	isChanged := aBoolean
]

{ #category : #accessing }
WDCGraphicsPipelineStateDescription >> polygonMode [
	^ polygonMode
]

{ #category : #accessing }
WDCGraphicsPipelineStateDescription >> polygonMode: newPolygonMode [
	polygonMode ~= newPolygonMode ifTrue: [ self changed ].
	polygonMode := newPolygonMode
]

{ #category : #accessing }
WDCGraphicsPipelineStateDescription >> primitiveType [
	^ primitiveType
]

{ #category : #accessing }
WDCGraphicsPipelineStateDescription >> primitiveType: newPrimitiveType [
	primitiveType ~= newPrimitiveType ifTrue: [ self changed ].
	primitiveType := newPrimitiveType
]

{ #category : #accessing }
WDCGraphicsPipelineStateDescription >> renderTargetFormats [
	^ renderTargetFormats
]

{ #category : #accessing }
WDCGraphicsPipelineStateDescription >> renderTargetFormats: newRenderTargetFormats [
	renderTargetFormats ~= newRenderTargetFormats ifTrue: [ self changed ].
	renderTargetFormats := newRenderTargetFormats
]

{ #category : #initialization }
WDCGraphicsPipelineStateDescription >> reset [
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
	
	depthBiasConstant := nil.
	depthBiasSlope := nil.
	
	polygonMode := AGPU_POLYGON_MODE_FILL.
	
	renderTargetFormats := #().
	depthStencilFormat := AGPU_TEXTURE_FORMAT_UNKNOWN.
	blendingStates := #().
	sampleCount := 1.

]

{ #category : #accessing }
WDCGraphicsPipelineStateDescription >> sampleCount [
	^ sampleCount
]

{ #category : #accessing }
WDCGraphicsPipelineStateDescription >> sampleCount: newSampleCount [
	newSampleCount ~= sampleCount ifTrue: [ self changed ].
	sampleCount := newSampleCount
]

{ #category : #accessing }
WDCGraphicsPipelineStateDescription >> shaderSignature [
	^ shaderSignature
]

{ #category : #accessing }
WDCGraphicsPipelineStateDescription >> shaderSignature: newShaderSignature [
	fragmentShader ~~ newShaderSignature ifTrue: [ self changed ].
	shaderSignature := newShaderSignature
]

{ #category : #'as yet unclassified' }
WDCGraphicsPipelineStateDescription >> traceBuildWith: engine [
	engine trace: 'Build PSO vertex: {1} fragment {2}.' format: {vertexShader asString . fragmentShader asString}.
]

{ #category : #accessing }
WDCGraphicsPipelineStateDescription >> vertexLayout [
	^ vertexLayout
]

{ #category : #accessing }
WDCGraphicsPipelineStateDescription >> vertexLayout: newVertexLayout [
	vertexLayout ~~ newVertexLayout ifTrue: [ self changed ].
	vertexLayout := newVertexLayout
]

{ #category : #accessing }
WDCGraphicsPipelineStateDescription >> vertexShader [
	^ vertexShader
]

{ #category : #accessing }
WDCGraphicsPipelineStateDescription >> vertexShader: newVertexShader [
	vertexShader ~~ newVertexShader ifTrue: [ self changed ].
	vertexShader := newVertexShader
]
