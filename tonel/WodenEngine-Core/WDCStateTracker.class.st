Class {
	#name : #WDCStateTracker,
	#superclass : #Object,
	#instVars : [
		'engine',
		'commandList',
		'pipelineStateDescription',
		'commandListBuilder',
		'mode',
		'submode',
		'currentViewport',
		'editorViewType',
		'computePipelineStateDescription',
		'activePipelineStateDescription'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Rendering'
}

{ #category : #'instance creation' }
WDCStateTracker class >> for: aWDCEngine [
	^ self new engine: aWDCEngine
]

{ #category : #accessing }
WDCStateTracker >> activateShaderSignature: aShaderSignature [
	^ aShaderSignature activeOnStateTracker: self
]

{ #category : #commands }
WDCStateTracker >> applyFullScreenPass: fullScreenPass [
	fullScreenPass applyWithStateTracker: self
]

{ #category : #commands }
WDCStateTracker >> beginRenderPass: renderPass renderTarget: renderTarget [
	self beginRenderPass: renderPass renderTarget: renderTarget x: 0 y: 0 width: renderTarget width height: renderTarget height
]

{ #category : #commands }
WDCStateTracker >> beginRenderPass: renderPass renderTarget: renderTarget bounds: bounds [
	| origin extent |
	origin := bounds origin.
	extent := bounds extent.
	self beginRenderPass: renderPass renderTarget: renderTarget x: origin x y: origin y width: extent x height: extent y.

]

{ #category : #commands }
WDCStateTracker >> beginRenderPass: renderPass renderTarget: renderTarget x: x y: y width: width height: height [
	commandListBuilder
		beginRenderPass: renderPass validHandle framebuffer: renderTarget currentFramebuffer validHandle bundle_content: 0;
		setViewport: x y: y w: width h: height;
		setScissor: x y: y w: width h: height.

	currentViewport := { x . y . width . height }.
	pipelineStateDescription
		changed;
		renderTargetFormats: renderTarget colorAttachmentFormats;
		depthStencilFormat: renderTarget depthStencilFormat;
		sampleCount: renderTarget sampleCount
]

{ #category : #'pipeline state' }
WDCStateTracker >> blendingAllEnabled: enabled sourceFactor: sourceFactor destFactor: destFactor operation: operation [
	pipelineStateDescription blendingStates: {WDCPipelineStateBlendingState new
		targetMask: -1;
		enabled: enabled;
		sourceFactor: sourceFactor;
		destFactor: destFactor;
		operation: operation;
		sourceAlphaFactor: sourceFactor;
		destAlphaFactor: destFactor;
		alphaOperation: operation;
		yourself
	}
]

{ #category : #'pipeline state' }
WDCStateTracker >> blendingAllMode: blendingMode [
	pipelineStateDescription blendingStates: { blendingMode asPipelineStateBlendingState }
]

{ #category : #accessing }
WDCStateTracker >> commandList [
	^ commandList
]

{ #category : #accessing }
WDCStateTracker >> commandList: anObject [
	commandList := anObject
]

{ #category : #commands }
WDCStateTracker >> commandList: aCommandList rebuildWith: aBlock [
	commandList := aCommandList.
	self reset.
	commandList withPipelineState: nil rebuild: [ :builder |
		commandListBuilder := builder.
		[ 
			aBlock cull: self.
		] ensure: [ commandListBuilder := nil ]
	].
	^ aCommandList
]

{ #category : #'pipeline state' }
WDCStateTracker >> commitComputePipelineState [
	| pipelineState |
	(activePipelineStateDescription == computePipelineStateDescription and: [computePipelineStateDescription isChanged not]) ifTrue: [ ^ self ].

	pipelineState := engine resourceCache pipelineStateForDescription: computePipelineStateDescription.
	pipelineStateDescription isChanged: false.
	commandListBuilder
		usePipelineState: pipelineState handle
]

{ #category : #'pipeline state' }
WDCStateTracker >> commitPipelineState [
	| pipelineState |
	(activePipelineStateDescription == pipelineStateDescription and: [pipelineStateDescription isChanged not]) ifTrue: [ ^ self ].

	pipelineState := engine resourceCache pipelineStateForDescription: pipelineStateDescription.
	pipelineStateDescription isChanged: false.
	commandListBuilder usePipelineState: pipelineState handle
]

{ #category : #'pipeline state' }
WDCStateTracker >> computeShader: aVertexShader [
	computePipelineStateDescription computeShader: aVertexShader
]

{ #category : #'pipeline state' }
WDCStateTracker >> computeShader: shader arguments: shaderArguments [
	self
		shaderSignature: shaderArguments signature;
		computeShader: shader.
	shaderArguments applyBindingsOnStateTracker: self
]

{ #category : #barriers }
WDCStateTracker >> computeShaderBuffersReadWriteMemoryBarrier [
	self memoryBarrier: AGPU_PIPELINE_STAGE_COMPUTE_SHADER
		dest_stage: AGPU_PIPELINE_STAGE_COMPUTE_SHADER
		source_accesses: AGPU_ACCESS_SHADER_WRITE
		dest_accesses: AGPU_ACCESS_SHADER_READ
]

{ #category : #'pipeline state' }
WDCStateTracker >> cullMode: cullMode [
	pipelineStateDescription cullMode: cullMode
]

{ #category : #accessing }
WDCStateTracker >> currentViewport [
	^ currentViewport
]

{ #category : #accessing }
WDCStateTracker >> currentViewportRectangle [
	^ currentViewport first @ currentViewport second extent: currentViewport third @ currentViewport fourth
]

{ #category : #'pipeline state' }
WDCStateTracker >> depthBiasConstant: constant slope: slope [
	pipelineStateDescription
		depthBiasConstant: constant;
		depthBiasSlope: slope
]

{ #category : #'pipeline state' }
WDCStateTracker >> depthEnabled: aBoolean [
	pipelineStateDescription depthEnabled: aBoolean
]

{ #category : #'pipeline state' }
WDCStateTracker >> depthFunction: aBoolean [
	pipelineStateDescription depthFunction: aBoolean
]

{ #category : #'pipeline state' }
WDCStateTracker >> depthWriteMask: aBoolean [
	pipelineStateDescription depthWriteMask: aBoolean
]

{ #category : #commands }
WDCStateTracker >> dispatchComputeGlobalGrid: x [
	| localSizeX |
	localSizeX := computePipelineStateDescription computeShader localSizeX.
	^ self dispatchComputeGroupCount: (x + localSizeX - 1) // localSizeX
]

{ #category : #commands }
WDCStateTracker >> dispatchComputeGlobalGridX: x y: y [
	| localSizeX localSizeY groupsX groupsY |
	localSizeX := computePipelineStateDescription computeShader localSizeX.
	localSizeY := computePipelineStateDescription computeShader localSizeY.
	groupsX := (x + localSizeX - 1) // localSizeX.
	groupsY := (y + localSizeY - 1) // localSizeY.
	^ self dispatchComputeGroupCountX: groupsX y: groupsY

]

{ #category : #commands }
WDCStateTracker >> dispatchComputeGroupCount: x [
	^ self dispatchComputeGroupCountX: x y: 1 z: 1
]

{ #category : #commands }
WDCStateTracker >> dispatchComputeGroupCountX: x y: y [
	^ self dispatchComputeGroupCountX: x y: y z: 1
]

{ #category : #commands }
WDCStateTracker >> dispatchComputeGroupCountX: x y: y z: z [
	self commitComputePipelineState.
	commandListBuilder
		dispatchCompute: x group_count_y: y group_count_z: z
]

{ #category : #commands }
WDCStateTracker >> dispatchCubeFaceScreenQuadRender: cubeFaceId [
	self 
		primitiveType: AGPU_TRIANGLES;
		drawArrays: 3 instance_count: 1 first_vertex: 0 base_instance: cubeFaceId
]

{ #category : #commands }
WDCStateTracker >> dispatchScreenQuadRender [
	self 
		primitiveType: AGPU_TRIANGLES;
		drawArrays: 3 instance_count: 1 first_vertex: 0 base_instance: 0
]

{ #category : #commands }
WDCStateTracker >> drawArrays: vertex_count instance_count: instance_count first_vertex: first_vertex base_instance: base_instance [
	self commitPipelineState.
	commandListBuilder drawArrays: vertex_count instance_count: instance_count first_vertex: first_vertex base_instance: base_instance
]

{ #category : #commands }
WDCStateTracker >> drawElements: indexCount instance_count: instanceCount first_index: firstIndex base_vertex: baseVertex base_instance: baseInstance [
	self commitPipelineState.
	commandListBuilder drawElements: indexCount instance_count: instanceCount first_index: firstIndex base_vertex: baseVertex base_instance: baseInstance
]

{ #category : #accessing }
WDCStateTracker >> editorViewType [
	^ editorViewType
]

{ #category : #accessing }
WDCStateTracker >> editorViewType: aSymbolOrNil [
	editorViewType := aSymbolOrNil
]

{ #category : #commands }
WDCStateTracker >> endRenderPass [
	commandListBuilder endRenderPass
]

{ #category : #accessing }
WDCStateTracker >> engine [
	^ engine
]

{ #category : #accessing }
WDCStateTracker >> engine: anObject [
	engine := anObject
]

{ #category : #'pipeline state' }
WDCStateTracker >> fragmentShader: aFragmentShader [
	pipelineStateDescription fragmentShader: aFragmentShader
]

{ #category : #'pipeline state' }
WDCStateTracker >> frontFaceWinding: winding [
	pipelineStateDescription frontFaceWinding: winding
]

{ #category : #initialization }
WDCStateTracker >> initialize [
	super initialize.
	pipelineStateDescription := WDCGraphicsPipelineStateDescription new.
	computePipelineStateDescription := WDCComputePipelineStateDescription new.
]

{ #category : #barriers }
WDCStateTracker >> memoryBarrier: source_stage dest_stage: dest_stage source_accesses: source_accesses dest_accesses: dest_accesses [
	commandListBuilder memoryBarrier: source_stage dest_stage: dest_stage source_accesses: source_accesses dest_accesses: dest_accesses
]

{ #category : #accessing }
WDCStateTracker >> mode [
	^ mode
]

{ #category : #accessing }
WDCStateTracker >> mode: anObject [
	mode := anObject
]

{ #category : #accessing }
WDCStateTracker >> pipelineStateDescription [
	^ pipelineStateDescription
]

{ #category : #'pipeline state' }
WDCStateTracker >> polygonMode: polygonMode [
	pipelineStateDescription polygonMode: polygonMode
]

{ #category : #'pipeline state' }
WDCStateTracker >> primitiveType: aPrimitiveType [
	pipelineStateDescription primitiveType: aPrimitiveType
]

{ #category : #commands }
WDCStateTracker >> pushConstants: offset size: size values: values [
	commandListBuilder pushConstants: offset size: size values: values
]

{ #category : #accessing }
WDCStateTracker >> reset [
	pipelineStateDescription reset.

]

{ #category : #commands }
WDCStateTracker >> resolveRenderTarget: sourceRenderTarget into: targetRenderTarget [
	commandListBuilder
		resolveFramebuffer: targetRenderTarget currentFramebuffer validHandle
		sourceFramebuffer: sourceRenderTarget currentFramebuffer validHandle
]

{ #category : #commands }
WDCStateTracker >> resolveTexture: sourceTexture into: destTexture aspect: aspect [
	commandListBuilder
		resolveTexture: sourceTexture validHandle sourceLevel: 0 sourceLayer: 0 destTexture: destTexture validHandle destLevel: 0 destLayer: 0 levelCount: 1 layerCount: 1 aspect: aspect
]

{ #category : #commands }
WDCStateTracker >> scissorRectangle: aRectangle [
	commandListBuilder
		setScissor: aRectangle origin x y: aRectangle origin y w: aRectangle width h: aRectangle height
]

{ #category : #commands }
WDCStateTracker >> shaderSignature: shaderSignatureClassOrInstance [
	| shaderSignature |
	shaderSignature := shaderSignatureClassOrInstance shaderSignatureFor: engine.
	pipelineStateDescription shaderSignature: shaderSignature.
	computePipelineStateDescription shaderSignature: shaderSignature.
	commandListBuilder setShaderSignature: shaderSignature handle
]

{ #category : #accessing }
WDCStateTracker >> submode [
	^ submode
]

{ #category : #accessing }
WDCStateTracker >> submode: anObject [
	submode := anObject
]

{ #category : #commands }
WDCStateTracker >> useComputeShaderResources: shaderResource [
	commandListBuilder useComputeShaderResources: shaderResource validHandle
]

{ #category : #commands }
WDCStateTracker >> useIndexBuffer: indexBuffer [
	indexBuffer applyAsIndexBufferToCommandList: commandListBuilder
]

{ #category : #commands }
WDCStateTracker >> useShaderResources: shaderResource [
	commandListBuilder useShaderResources: shaderResource validHandle
]

{ #category : #commands }
WDCStateTracker >> useVertexBinding: vertexBinding [
	self vertexLayout: vertexBinding vertexLayout.
	commandListBuilder useVertexBinding: vertexBinding validHandle.

]

{ #category : #'pipeline state' }
WDCStateTracker >> vertexLayout: aVertexLayout [
	pipelineStateDescription vertexLayout: aVertexLayout
]

{ #category : #'pipeline state' }
WDCStateTracker >> vertexShader: aVertexShader [
	pipelineStateDescription vertexShader: aVertexShader
]

{ #category : #'as yet unclassified' }
WDCStateTracker >> withVertexData: vertexData do: aBlock [
	^ aBlock value
]
