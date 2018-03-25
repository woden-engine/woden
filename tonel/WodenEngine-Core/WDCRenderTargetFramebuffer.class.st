Class {
	#name : #WDCRenderTargetFramebuffer,
	#superclass : #Object,
	#instVars : [
		'colorAttachments',
		'depthStencilAttachment',
		'engine',
		'handle',
		'commandAllocator',
		'commandList'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : 'WodenEngine-Core-Window'
}

{ #category : #accessing }
WDCRenderTargetFramebuffer >> colorAttachments [
	^ colorAttachments
]

{ #category : #accessing }
WDCRenderTargetFramebuffer >> colorAttachments: anObject [
	colorAttachments := anObject
]

{ #category : #accessing }
WDCRenderTargetFramebuffer >> commandAllocator [
	^ commandAllocator
]

{ #category : #accessing }
WDCRenderTargetFramebuffer >> commandAllocator: anObject [
	commandAllocator := anObject
]

{ #category : #accessing }
WDCRenderTargetFramebuffer >> commandList [
	^ commandList
]

{ #category : #accessing }
WDCRenderTargetFramebuffer >> commandList: anObject [
	commandList := anObject
]

{ #category : #accessing }
WDCRenderTargetFramebuffer >> depthStencilAttachment [
	^ depthStencilAttachment
]

{ #category : #accessing }
WDCRenderTargetFramebuffer >> depthStencilAttachment: anObject [
	depthStencilAttachment := anObject
]

{ #category : #accessing }
WDCRenderTargetFramebuffer >> engine [
	^ engine
]

{ #category : #accessing }
WDCRenderTargetFramebuffer >> engine: anObject [
	engine := anObject
]

{ #category : #accessing }
WDCRenderTargetFramebuffer >> handle [
	^ handle
]

{ #category : #accessing }
WDCRenderTargetFramebuffer >> handle: anObject [
	handle := anObject
]

{ #category : #initialization }
WDCRenderTargetFramebuffer >> initializeExtraStateFrom: previousFramebuffer [
	previousFramebuffer ifNil: [ ^ self ].
	
	commandAllocator := previousFramebuffer commandAllocator.
	commandList := previousFramebuffer commandList.
]

{ #category : #dependencies }
WDCRenderTargetFramebuffer >> release [
	handle ifNotNil: [ handle release. handle := nil. ].
	colorAttachments ifNotNil: [ colorAttachments do: #release. colorAttachments ].
	depthStencilAttachment ifNotNil: [ depthStencilAttachment release . depthStencilAttachment ].
	

]

{ #category : #'as yet unclassified' }
WDCRenderTargetFramebuffer >> validCommandAllocator [
	^ commandAllocator ifNil: [ commandAllocator := engine createGraphicsDirectCommandListAllocator ]
]

{ #category : #accessing }
WDCRenderTargetFramebuffer >> validCommandList [
	^ commandList ifNil: [ commandList := self validCommandAllocator createListNow ]
]

{ #category : #accessing }
WDCRenderTargetFramebuffer >> validHandle [
	self flag: 'Check the session'.
	^ handle
]
