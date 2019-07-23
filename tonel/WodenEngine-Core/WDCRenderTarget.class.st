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
WDCRenderTarget class >> for: engine colorAttachments: colorAttachments [
	^ self for: engine colorAttachments: colorAttachments depthStencilAttachment: nil
]

{ #category : #'instance creation' }
WDCRenderTarget class >> for: engine colorAttachments: colorAttachments depthStencilAttachment: depthStencilAttachment [
	| extent |
	extent := nil.
	depthStencilAttachment ifNotNil: [
		extent := depthStencilAttachment extent.
	].
	extent ifNil: [
		extent := colorAttachments first extent.
	].
	
	^ (self for: engine extent: extent)
		constructWithColorAttachments: colorAttachments depthStencilAttachment: depthStencilAttachment
]

{ #category : #'instance creation' }
WDCRenderTarget class >> for: anEngine extent: anExtent [
	^ self new engine: anEngine; extent: anExtent; yourself
]

{ #category : #'as yet unclassified' }
WDCRenderTarget >> constructWithColorAttachments: colorAttachments [
	^ self constructWithColorAttachments: colorAttachments depthStencilAttachment: (self createImplicitDepthStencilAttachment)
]

{ #category : #'as yet unclassified' }
WDCRenderTarget >> constructWithColorAttachments: colorAttachments depthStencilAttachment: depthStencilAttachment [
	| newSampleCount |
	newSampleCount := nil.
	depthStencilAttachment ifNotNil: [
		newSampleCount := depthStencilAttachment description sample_count
	].
	newSampleCount ifNil: [
		newSampleCount := colorAttachments first description sample_count
	].
	
	^ self
		colorAttachmentFormats: (colorAttachments collect: [ :attachment | attachment description format ]);
		depthStencilFormat: (depthStencilAttachment
			ifNil: [AGPU_TEXTURE_FORMAT_UNKNOWN]
			ifNotNil: [depthStencilAttachment description format]);
		hasDepth: (depthStencilAttachment ifNil: [false] ifNotNil: #hasDepthAspect);
		hasStencil: (depthStencilAttachment ifNil: [false] ifNotNil: #hasStencilAspect);
		isDepthReaded: (depthStencilAttachment ifNil: [false] ifNotNil: #isDepthReaded);
		sampleCount: newSampleCount;
		createFramebuffersWithColorAttachments: colorAttachments depthStencilAttachment: depthStencilAttachment
]

{ #category : #initialization }
WDCRenderTarget >> createFramebuffer [
	| colorBufferUsages description colorAttachments depthStencilAttachment |
	colorBufferUsages := AGPU_TEXTURE_USAGE_COLOR_ATTACHMENT | AGPU_TEXTURE_USAGE_SAMPLED.
	self gpuOnly ifFalse: [
		colorBufferUsages := colorBufferUsages | AGPU_TEXTURE_USAGE_READED_BACK
	].
	
	colorAttachments := self colorAttachmentFormats collect: [ :format |
		description := AGPUTextureDescription new
		type: AGPU_TEXTURE_2D;
		width: width;
		height: height;
		depth: 1;
		layers: 1;
		miplevels: 1;
		format: AGPU_TEXTURE_FORMAT_B8G8R8A8_UNORM_SRGB;
		heap_type: AGPU_MEMORY_HEAP_TYPE_DEVICE_LOCAL;
		usage_modes: colorBufferUsages;
		main_usage_mode: AGPU_TEXTURE_USAGE_SAMPLED;
		sample_count: sampleCount.
		
		engine createTexture: description
	].

	depthStencilAttachment := self createImplicitDepthStencilAttachment.
	^ self createFramebufferWithColorAttachments: colorAttachments views: colorAttachments depthStencilAttachment: depthStencilAttachment view: depthStencilAttachment
]

{ #category : #initialization }
WDCRenderTarget >> createFramebufferWithColorAttachments: colorAttachments views: colorViews depthStencilAttachment: depthStencilAttachment view: depthStencilView [
	| handle |
	self assert: colorAttachments size = colorViews size.

	handle := engine device createFrameBuffer: width height: height colorCount: colorViews size colorViews: (AGPU packListOfReferences: (colorViews collect: #asValidTextureViewHandle)) depthStencilView: (depthStencilView ifNotNil: [depthStencilView asValidTextureViewHandle]).

	^ WDCRenderTargetFramebuffer new
		engine: engine;
		colorAttachments: colorAttachments;
		colorAttachmentViews: colorViews;
		depthStencilAttachment: depthStencilAttachment;
		depthStencilAttachmentView: depthStencilView;
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
	^ self createFramebuffersWithColorAttachments: colorAttachments views: colorAttachments depthStencilAttachment: depthStencilAttachment view: depthStencilAttachment

]

{ #category : #accessing }
WDCRenderTarget >> createFramebuffersWithColorAttachments: colorAttachments views: colorViews depthStencilAttachment: depthStencilAttachment view: depthStencilView [
	self assert: gpuOnly.
	framebuffers := {self createFramebufferWithColorAttachments: colorAttachments views: colorViews depthStencilAttachment: depthStencilAttachment view: depthStencilView}
]

{ #category : #initialization }
WDCRenderTarget >> createImplicitDepthStencilAttachment [
	| depthStencilFlags mainUsageMode depthStencilDesc |
	(hasDepth or: [ hasStencil ]) ifTrue: [
		depthStencilFlags := AGPU_TEXTURE_USAGE_DEPTH_ATTACHMENT.
		hasStencil ifTrue: [ depthStencilFlags := depthStencilFlags | AGPU_TEXTURE_USAGE_STENCIL_ATTACHMENT ].
		mainUsageMode := depthStencilFlags.
		isDepthReaded ifTrue: [
			depthStencilFlags := depthStencilFlags | AGPU_TEXTURE_USAGE_SAMPLED.
			mainUsageMode := AGPU_TEXTURE_USAGE_SAMPLED
		].
		
		depthStencilDesc := AGPUTextureDescription new
			type: AGPU_TEXTURE_2D;
			width: width;
			height: height;
			depth: 1;
			layers: 1;
			miplevels: 1;
			format: self depthStencilFormat;
			heap_type: AGPU_MEMORY_HEAP_TYPE_DEVICE_LOCAL;
			usage_modes: depthStencilFlags;
			main_usage_mode: mainUsageMode;
			sample_count: sampleCount.
			
		^ (engine createTexture: depthStencilDesc)
			checkSession;
			yourself.
	].

	^ nil
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
