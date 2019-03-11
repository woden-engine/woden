Class {
	#name : #WDCRenderTarget,
	#superclass : #WDCAbstractRenderTarget,
	#instVars : [
		'gpuOnly',
		'explicitSynchronization'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Window'
}

{ #category : #'instance creation' }
WDCRenderTarget class >> for: anEngine extent: anExtent [
	^ self new engine: anEngine; extent: anExtent; yourself
]

{ #category : #initialization }
WDCRenderTarget >> createFramebuffer [
	| colorBufferFags description colorAttachments depthStencilView depthStencilAttachment depthStencilFlags depthStencilDesc colorViews |
	colorBufferFags := AGPU_TEXTURE_FLAG_RENDER_TARGET.
	self gpuOnly ifTrue: [
		colorBufferFags := colorBufferFags | AGPU_TEXTURE_FLAG_RENDERBUFFER_ONLY
	] ifFalse: [
		colorBufferFags := colorBufferFags | AGPU_TEXTURE_FLAG_READED_BACK
	].
	
	colorAttachments := self colorAttachmentFormats collect: [ :format |
		description := AGPUTextureDescription new
		type: AGPU_TEXTURE_2D;
		width: width;
		height: height;
		depthOrArraySize: 1;
		miplevels: 1;
		format: AGPU_TEXTURE_FORMAT_B8G8R8A8_UNORM_SRGB;
		flags: colorBufferFags;
		sample_count: sampleCount.
		
		engine createTexture: description
	].

	colorViews := colorAttachments collect: #fullTextureView.

	depthStencilView := nil.
	depthStencilAttachment := nil.
	(hasDepth or: [ hasStencil ]) ifTrue: [
		depthStencilFlags := AGPU_TEXTURE_FLAG_DEPTH | AGPU_TEXTURE_FLAG_RENDERBUFFER_ONLY.
		hasStencil ifTrue: [ depthStencilFlags := depthStencilFlags | AGPU_TEXTURE_FLAG_STENCIL ].
		isDepthReaded ifTrue: [ depthStencilFlags := depthStencilFlags | AGPU_TEXTURE_FLAG_RENDER_TARGET  ].
		
		depthStencilDesc := AGPUTextureDescription new
			type: AGPU_TEXTURE_2D;
			width: width;
			height: height;
			depthOrArraySize: 1;
			miplevels: 1;
			format: self depthStencilFormat;
			flags: depthStencilFlags;
			sample_count: sampleCount.
			
		depthStencilAttachment := (engine createTexture: depthStencilDesc)
			checkSession;
			yourself.

		depthStencilView := depthStencilAttachment fullTextureView.
	].

	^ self createFramebufferWithColorAttachments: colorAttachments views: colorViews depthStencilAttachment: depthStencilAttachment view: depthStencilView
]

{ #category : #initialization }
WDCRenderTarget >> createFramebufferWithColorAttachments: colorAttachments views: colorViews depthStencilAttachment: depthStencilAttachment view: depthStencilView [

	| handle colorCount colorViewBuffer structureSize destIndex |
	colorCount := 0.
	colorViewBuffer := nil.
	
	self assert: colorAttachments size = colorViews size.
	
	colorAttachments ifNotEmpty: [
		colorAttachments size = 1 ifTrue: [ 
			colorCount := 1.
			colorViewBuffer := colorViews first.
		] ifFalse: [
			structureSize := AGPUTextureViewDescription structureSize.
			colorViewBuffer := ByteArray new: colorAttachments size * structureSize.
			destIndex := 1.
			colorViews doWithIndex: [ :view :index |
				view getHandle.
				self halt.
				"TODO: Memcpy colorViewBuffer + destIndex, view, structureSize"
				destIndex := destIndex + structureSize
			].
			self halt
		]
	].

	handle := engine device createFrameBuffer: width height: height colorCount: colorCount colorViews: colorViewBuffer depthStencilView: depthStencilView.

	^ WDCRenderTargetFramebuffer new
		engine: engine;
		colorAttachments: colorAttachments;
		depthStencilAttachment: depthStencilAttachment;
		width: width;
		height: height;
		sampleCount: sampleCount;
		handle: handle;
		yourself
]

{ #category : #accessing }
WDCRenderTarget >> createFramebuffers [
	^ self createFramebuffers: self framebufferingCount
]

{ #category : #accessing }
WDCRenderTarget >> createFramebuffers: aCount [
	| oldFramebuffers |
	oldFramebuffers := framebuffers.
	framebuffers := (1 to: aCount) collect: [:i |
		self createFramebuffer
			initializeExtraStateFrom: (oldFramebuffers ifNotNil: [oldFramebuffers at: i]);
		yourself
	].

]

{ #category : #accessing }
WDCRenderTarget >> createFramebuffersWithColorAttachments: colorAttachments depthStencilAttachment: depthStencilAttachment [
	^ self createFramebuffersWithColorAttachments: colorAttachments views: (colorAttachments collect: #fullTextureView) depthStencilAttachment: depthStencilAttachment view: (depthStencilAttachment ifNotNil: #fullTextureView)

]

{ #category : #accessing }
WDCRenderTarget >> createFramebuffersWithColorAttachments: colorAttachments views: colorViews depthStencilAttachment: depthStencilAttachment view: depthStencilView [
	self assert: gpuOnly.
	framebuffers := {self createFramebufferWithColorAttachments: colorAttachments views: colorViews depthStencilAttachment: depthStencilAttachment view: depthStencilView}
]

{ #category : #accessing }
WDCRenderTarget >> explicitSynchronization [
	^ explicitSynchronization
]

{ #category : #accessing }
WDCRenderTarget >> explicitSynchronization: anObject [
	explicitSynchronization := anObject
]

{ #category : #accessing }
WDCRenderTarget >> framebufferingCount [
	^ ((gpuOnly or: [ explicitSynchronization ]) ifTrue: [ 1 ] ifFalse: [engine frameBufferingCount])
]

{ #category : #accessing }
WDCRenderTarget >> gpuOnly [
	^ gpuOnly
]

{ #category : #accessing }
WDCRenderTarget >> gpuOnly: anObject [
	gpuOnly := anObject
]

{ #category : #initialization }
WDCRenderTarget >> initialize [
	super initialize.
	gpuOnly := true.
	explicitSynchronization := false.
]
