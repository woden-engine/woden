Class {
	#name : #WDCAbstractRenderTarget,
	#superclass : #Object,
	#instVars : [
		'hasDepth',
		'hasStencil',
		'isDepthReaded',
		'engine',
		'width',
		'height',
		'framebuffers',
		'colorAttachmentFormats',
		'depthStencilFormat',
		'sampleCount',
		'mainRenderPass',
		'mainContinueRenderPass'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Window'
}

{ #category : #accessing }
WDCAbstractRenderTarget >> bounds [
	^ (0@0 extent: self extent)
]

{ #category : #accessing }
WDCAbstractRenderTarget >> colorAttachmentFormats [
	^ colorAttachmentFormats ifNil: [ colorAttachmentFormats := { AGPU_TEXTURE_FORMAT_B8G8R8A8_UNORM_SRGB } ]
]

{ #category : #accessing }
WDCAbstractRenderTarget >> colorAttachmentFormats: anArrayOfFormats [
	colorAttachmentFormats := anArrayOfFormats
]

{ #category : #'render pass creation' }
WDCAbstractRenderTarget >> createContinueRenderPass [
	| passColorAttachments passDepthStencilAttachment |
	passColorAttachments := self colorAttachmentFormats collectWithIndex: [ :format :index |
		AGPURenderpassColorAttachmentDescription new
			format: format;
			sample_count: sampleCount;
			begin_action: AGPU_ATTACHMENT_KEEP;
			end_action: AGPU_ATTACHMENT_KEEP;
			yourself
	].

	passDepthStencilAttachment := nil.
	(hasDepth or: [ hasStencil ]) ifTrue: [
		passDepthStencilAttachment := AGPURenderpassDepthStencilDescription new
			format: self depthStencilFormat;
			sample_count: sampleCount;
			begin_action: AGPU_ATTACHMENT_KEEP;
			end_action: AGPU_ATTACHMENT_KEEP;
			yourself.
	].

	^ (WDCRenderPass for: engine)
		colorAttachments: passColorAttachments;
		depthStencilAttachment: passDepthStencilAttachment;
		checkSession;
		yourself
]

{ #category : #accessing }
WDCAbstractRenderTarget >> createFramebuffers [
	self subclassResponsibility
]

{ #category : #'render pass creation' }
WDCAbstractRenderTarget >> createRenderPassWithColor: initialColor [
	^ self createRenderPassWithColors: {initialColor}
]

{ #category : #'render pass creation' }
WDCAbstractRenderTarget >> createRenderPassWithColors: initialColors [
	^ self createRenderPassWithColors: initialColors depth: 0.0 stencil: 0
]

{ #category : #'render pass creation' }
WDCAbstractRenderTarget >> createRenderPassWithColors: initialColors depth: initialDepth stencil: initialStencil [
	| color passColorAttachments passDepthStencilAttachment |
	passColorAttachments := self colorAttachmentFormats collectWithIndex: [ :format :index |
		color := initialColors at: index.
		color ifNil: [ 
			AGPURenderpassColorAttachmentDescription new
				format: format;
				sample_count: sampleCount;
				begin_action: AGPU_ATTACHMENT_KEEP;
				end_action: AGPU_ATTACHMENT_KEEP;
				yourself
		] ifNotNil: [ 
			AGPURenderpassColorAttachmentDescription new
				format: format;
				sample_count: sampleCount;
				begin_action: AGPU_ATTACHMENT_CLEAR;
				end_action: AGPU_ATTACHMENT_KEEP;
				clear_value: color asAGPUColor4f;
				yourself
		].
	].

	passDepthStencilAttachment := nil.
	(hasDepth or: [ hasStencil ]) ifTrue: [
		initialDepth ifNil: [ 
			passDepthStencilAttachment := AGPURenderpassDepthStencilDescription new
				format: self depthStencilFormat;
				sample_count: sampleCount;
				begin_action: AGPU_ATTACHMENT_KEEP;
				end_action: AGPU_ATTACHMENT_KEEP;
				yourself.
		] ifNotNil: [ 
			passDepthStencilAttachment := AGPURenderpassDepthStencilDescription new
				format: self depthStencilFormat;
				sample_count: sampleCount;
				begin_action: AGPU_ATTACHMENT_CLEAR;
				end_action: AGPU_ATTACHMENT_KEEP;
				clear_value: (AGPUDepthStencilValue new depth: initialDepth; stencil: initialStencil; yourself);
				yourself.
		]
	].

	^ (WDCRenderPass for: engine)
		colorAttachments: passColorAttachments;
		depthStencilAttachment: passDepthStencilAttachment;
		checkSession;
		yourself
]

{ #category : #accessing }
WDCAbstractRenderTarget >> currentFramebuffer [
	framebuffers size == 1 ifTrue: [ framebuffers first ].
	^ framebuffers at: (engine bufferingFrameIndexModule: framebuffers size) + 1
]

{ #category : #accessing }
WDCAbstractRenderTarget >> depthStencilFormat [
	depthStencilFormat ifNil: [
		(hasDepth or: [ hasStencil ]) ifTrue: [
			depthStencilFormat := hasStencil ifTrue: [ engine preferredDepthStencilFormat ] ifFalse: [ engine preferredDepthFormat ]
		] ifFalse: [
			depthStencilFormat := AGPU_TEXTURE_FORMAT_UNKNOWN
		]
	].
	^ depthStencilFormat
]

{ #category : #accessing }
WDCAbstractRenderTarget >> depthStencilFormat: aDepthStencilFormat [
	depthStencilFormat := aDepthStencilFormat
]

{ #category : #accessing }
WDCAbstractRenderTarget >> engine [
	^ engine
]

{ #category : #accessing }
WDCAbstractRenderTarget >> engine: anObject [
	engine := anObject
]

{ #category : #accessing }
WDCAbstractRenderTarget >> extent [
	^ width @ height
]

{ #category : #accessing }
WDCAbstractRenderTarget >> extent: anExtent [
	| extentChanged frameBufferCount |
	engine renderingProcessCritical: [ 
		extentChanged := (width ~= anExtent x) or: [height ~= anExtent y].
		width := anExtent x.
		height := anExtent y.
	
		(extentChanged and: [ framebuffers isNotNil ]) ifTrue: [
			engine trace: 'Framebuffer extent changed'.
			frameBufferCount := framebuffers size.
			self release.
			self createFramebuffers: frameBufferCount
		]
	].

]

{ #category : #accessing }
WDCAbstractRenderTarget >> framebuffers [
	^ framebuffers
]

{ #category : #accessing }
WDCAbstractRenderTarget >> hasDepth [
	^ hasDepth
]

{ #category : #accessing }
WDCAbstractRenderTarget >> hasDepth: anObject [
	hasDepth := anObject
]

{ #category : #accessing }
WDCAbstractRenderTarget >> hasStencil [
	^ hasStencil
]

{ #category : #accessing }
WDCAbstractRenderTarget >> hasStencil: anObject [
	hasStencil := anObject
]

{ #category : #accessing }
WDCAbstractRenderTarget >> height [
	^ height
]

{ #category : #initialization }
WDCAbstractRenderTarget >> initialize [
	super initialize.
	hasDepth := false.
	hasStencil := false.
	isDepthReaded := false.
	sampleCount := 1
]

{ #category : #accessing }
WDCAbstractRenderTarget >> isDepthReaded [
	^ isDepthReaded
]

{ #category : #accessing }
WDCAbstractRenderTarget >> isDepthReaded: anObject [
	isDepthReaded := anObject
]

{ #category : #accessing }
WDCAbstractRenderTarget >> mainRenderPass [
	^ mainRenderPass
]

{ #category : #accessing }
WDCAbstractRenderTarget >> mainRenderPass: anObject [
	mainRenderPass := anObject
]

{ #category : #dependencies }
WDCAbstractRenderTarget >> release [
	framebuffers ifNotNil: [
		engine ifNotNil: [ engine graphicsQueue finishExecution ].
		framebuffers do: #release
	].
	framebuffers := nil.
]

{ #category : #accessing }
WDCAbstractRenderTarget >> sampleCount [
	^ sampleCount
]

{ #category : #accessing }
WDCAbstractRenderTarget >> sampleCount: aSampleCount [
	sampleCount := aSampleCount
]

{ #category : #accessing }
WDCAbstractRenderTarget >> validMainContinueRenderPass [
	^ mainContinueRenderPass ifNil: [ mainContinueRenderPass := self createContinueRenderPass ].
]

{ #category : #accessing }
WDCAbstractRenderTarget >> validMainRenderPass [
	^ mainRenderPass ifNil: [ mainRenderPass := self createRenderPassWithColor: Color transparent ].
]

{ #category : #accessing }
WDCAbstractRenderTarget >> width [
	^ width
]

{ #category : #accessing }
WDCAbstractRenderTarget >> width: anObject [
	width := anObject
]
