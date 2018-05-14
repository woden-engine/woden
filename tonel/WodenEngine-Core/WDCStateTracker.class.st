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
		'activeMaterial',
		'objectBlendingMode',
		'materialBlendingMode'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : 'WodenEngine-Core-Rendering'
}

{ #category : #'instance creation' }
WDCStateTracker class >> for: aWDCEngine [
	^ self new engine: aWDCEngine
]

{ #category : #commands }
WDCStateTracker >> activateMaterial: material [
	activeMaterial == material ifTrue: [ ^ true ].
	
	self materialBlendingMode: nil.
	(material activateOn: self) ifTrue: [ 
		activeMaterial := material.
		^ true
	] ifFalse: [
		^ false
	]
	
]

{ #category : #'as yet unclassified' }
WDCStateTracker >> applyBlendingModel [
	materialBlendingMode ifNotNil: [
		^ self blendingAllMode: materialBlendingMode.
	].

	objectBlendingMode ifNotNil: [
		^ self blendingAllMode: objectBlendingMode.
	]

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
		
	pipelineStateDescription
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
WDCStateTracker >> commitPipelineState [
	| pipelineState |
	pipelineStateDescription isChanged ifFalse: [ ^ self ].

	pipelineState := engine resourceCache pipelineStateForDescription: pipelineStateDescription.
	pipelineStateDescription isChanged: false.
	commandListBuilder usePipelineState: pipelineState handle
]

{ #category : #'pipeline state' }
WDCStateTracker >> cullMode: cullMode [
	pipelineStateDescription cullMode: cullMode
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
WDCStateTracker >> drawArrays: vertex_count instance_count: instance_count first_vertex: first_vertex base_instance: base_instance [
	self commitPipelineState.
	commandListBuilder drawArrays: vertex_count instance_count: instance_count first_vertex: first_vertex base_instance: base_instance
]

{ #category : #commands }
WDCStateTracker >> drawElements: indexCount instance_count: instanceCount first_index: firstIndex base_vertex: baseVertex base_instance: baseInstance [
	self commitPipelineState.
	commandListBuilder drawElements: indexCount instance_count: instanceCount first_index: firstIndex base_vertex: baseVertex base_instance: baseInstance
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
	pipelineStateDescription := WDCPipelineStateDescription new.
]

{ #category : #accessing }
WDCStateTracker >> materialBlendingMode [
	^ materialBlendingMode
]

{ #category : #accessing }
WDCStateTracker >> materialBlendingMode: anObject [
	materialBlendingMode := anObject.
	self applyBlendingModel
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
WDCStateTracker >> objectBlendingMode [
	^ objectBlendingMode
]

{ #category : #accessing }
WDCStateTracker >> objectBlendingMode: anObject [
	objectBlendingMode := anObject.
	self applyBlendingModel
]

{ #category : #accessing }
WDCStateTracker >> pipelineStateDescription [
	^ pipelineStateDescription
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
	activeMaterial := nil.
	objectBlendingMode := nil.
	materialBlendingMode := nil.
]

{ #category : #commands }
WDCStateTracker >> resolveRenderTarget: sourceRenderTarget into: targetRenderTarget [
	commandListBuilder
		resolveFramebuffer: targetRenderTarget currentFramebuffer validHandle
		sourceFramebuffer: sourceRenderTarget currentFramebuffer validHandle
]

{ #category : #commands }
WDCStateTracker >> shaderSignature: shaderSignatureClassOrInstance [
	| shaderSignature |
	shaderSignature := shaderSignatureClassOrInstance shaderSignatureFor: engine.
	pipelineStateDescription shaderSignature: shaderSignature.
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
WDCStateTracker >> useIndexBuffer: indexBuffer [
	commandListBuilder useIndexBuffer: indexBuffer validHandle
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
