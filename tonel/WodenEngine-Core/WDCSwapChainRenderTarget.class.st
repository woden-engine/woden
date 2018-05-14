Class {
	#name : #WDCSwapChainRenderTarget,
	#superclass : #WDCAbstractRenderTarget,
	#instVars : [
		'windowHandle',
		'swapChain'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : 'WodenEngine-Core-Window'
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
	| swapChainInfo oldFramebuffers |
	swapChainInfo := AGPUSwapChainCreateInfo new
		buffer_count: bufferCount;
		colorbuffer_format: self colorAttachmentFormats first;
		depth_stencil_format: self depthStencilFormat;
		width: width;
		height: height;
		yourself.
		
	windowHandle window ifNotNil: [ swapChainInfo window: windowHandle window ].
	windowHandle surface ifNotNil: [ swapChainInfo surface: windowHandle surface ].
	
	swapChain ifNotNil: [ swapChain release ].
	swapChain := engine device createSwapChain: engine graphicsQueue swapChainInfo: swapChainInfo.
	
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
	result := framebuffers at: swapChain getCurrentBackBufferIndex + 1.
	result handle ifNil: [ result handle: swapChain getCurrentBackBuffer ].
	^ result
]

{ #category : #dependencies }
WDCSwapChainRenderTarget >> release [
	super release.
	swapChain ifNotNil: [ swapChain release. ].
	swapChain := nil.
	
]

{ #category : #accessing }
WDCSwapChainRenderTarget >> swapBuffers [
	swapChain swapBuffers
]

{ #category : #accessing }
WDCSwapChainRenderTarget >> windowHandle [
	^ windowHandle
]

{ #category : #accessing }
WDCSwapChainRenderTarget >> windowHandle: anObject [
	windowHandle := anObject
]
