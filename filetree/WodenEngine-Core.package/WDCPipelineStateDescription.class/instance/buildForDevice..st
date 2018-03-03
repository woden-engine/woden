building
buildForDevice: device
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