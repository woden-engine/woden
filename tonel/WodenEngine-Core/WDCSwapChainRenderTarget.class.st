Class {
	#name : #WDCSwapChainRenderTarget,
	#superclass : #WDCAbstractRenderTarget,
	#instVars : [
		'windowHandle',
		'swapChain',
		'isOutOfDate'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Window'
}

{ #category : #'as yet unclassified' }
WDCSwapChainRenderTarget class >> for: anEngine extent: anExtent windowHandle: aWindowHandle [
	^ self new engine: anEngine; extent: anExtent; windowHandle: aWindowHandle; yourself
]

{ #category : #accessing }
WDCSwapChainRenderTarget >> createFramebuffers [
	^ self createFramebuffers: engine frameBufferingCount
]

{ #category : #accessing }
WDCSwapChainRenderTarget >> createFramebuffers: bufferCount [
	| swapChainInfo oldFramebuffers oldSwapChain |
	swapChainInfo := AGPUSwapChainCreateInfo new
		buffer_count: bufferCount;
		colorbuffer_format: self colorAttachmentFormats first;
		depth_stencil_format: self depthStencilFormat;
		width: width;
		height: height;
		yourself.
		
	windowHandle window ifNotNil: [ swapChainInfo window: windowHandle window ].
	windowHandle surface ifNotNil: [ swapChainInfo surface: windowHandle surface ].
	
	oldSwapChain := swapChain.
	oldSwapChain ifNotNil: [
		swapChainInfo old_swap_chain: oldSwapChain
	].

	swapChain := engine device createSwapChain: engine graphicsQueue swapChainInfo: swapChainInfo.
	isOutOfDate := false.
	oldSwapChain ifNotNil: [ oldSwapChain release ].
	
	oldFramebuffers := framebuffers.
	framebuffers := (1 to: swapChain getFramebufferCount) collect: [:i |
		WDCRenderTargetFramebuffer new
			engine: engine;
			width: width;
			height: height;
			sampleCount: sampleCount;
			initializeExtraStateFrom: (oldFramebuffers ifNotNil: [oldFramebuffers at: i]);
			yourself
	].
]

{ #category : #accessing }
WDCSwapChainRenderTarget >> currentFramebuffer [
	| result |
	self assert: isOutOfDate not.
	result := framebuffers at: swapChain getCurrentBackBufferIndex + 1.
	result handle ifNil: [ result handle: swapChain getCurrentBackBuffer ].
	^ result
]

{ #category : #testing }
WDCSwapChainRenderTarget >> initialize [
	super initialize.
	isOutOfDate := true.
]

{ #category : #testing }
WDCSwapChainRenderTarget >> isOutOfDate [
	^ isOutOfDate
]

{ #category : #dependencies }
WDCSwapChainRenderTarget >> release [
	super release.
	swapChain ifNotNil: [ swapChain release. ].
	swapChain := nil.
	
]

{ #category : #accessing }
WDCSwapChainRenderTarget >> swapBuffers [
	(swapChain isNil or: [isOutOfDate]) ifTrue: [ ^ self ].

	[ 
		swapChain swapBuffers
	] on: AGPUError do: [ :ex |
		| errorCode |
		errorCode := ex errorCode.
		(errorCode = AGPU_OUT_OF_DATE or: [ errorCode = AGPU_SUBOPTIMAL ]) ifTrue: [
			errorCode = AGPU_OUT_OF_DATE ifTrue: [ isOutOfDate := true].
		] ifFalse: [ 
			ex signal
		]
	]

]

{ #category : #accessing }
WDCSwapChainRenderTarget >> windowHandle [
	^ windowHandle
]

{ #category : #accessing }
WDCSwapChainRenderTarget >> windowHandle: anObject [
	windowHandle := anObject
]
