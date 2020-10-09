Class {
	#name : #WDCRenderTargetFramebuffer,
	#superclass : #Object,
	#instVars : [
		'engine',
		'handle',
		'colorAttachments',
		'colorAttachmentViews',
		'depthStencilAttachment',
		'depthStencilAttachmentView',
		'commandAllocator',
		'commandList',
		'properties',
		'width',
		'height',
		'extent',
		'sampleCount'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Window'
}

{ #category : #accessing }
WDCRenderTargetFramebuffer >> colorAttachmentViews [
	^ colorAttachmentViews
]

{ #category : #accessing }
WDCRenderTargetFramebuffer >> colorAttachmentViews: anObject [
	colorAttachmentViews := anObject
]

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
WDCRenderTargetFramebuffer >> depthStencilAttachmentView [
	^ depthStencilAttachmentView
]

{ #category : #accessing }
WDCRenderTargetFramebuffer >> depthStencilAttachmentView: anObject [
	depthStencilAttachmentView := anObject
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
WDCRenderTargetFramebuffer >> extent [
	^ extent
]

{ #category : #accessing }
WDCRenderTargetFramebuffer >> extent: anObject [
	extent := anObject
]

{ #category : #accessing }
WDCRenderTargetFramebuffer >> handle [
	^ handle
]

{ #category : #accessing }
WDCRenderTargetFramebuffer >> handle: anObject [
	handle := anObject
]

{ #category : #accessing }
WDCRenderTargetFramebuffer >> height [
	^ height
]

{ #category : #accessing }
WDCRenderTargetFramebuffer >> height: anObject [
	height := anObject
]

{ #category : #initialization }
WDCRenderTargetFramebuffer >> initializeExtraStateFrom: previousFramebuffer [
	previousFramebuffer ifNil: [ ^ self ].
	
	commandAllocator := previousFramebuffer commandAllocator.
	commandList := previousFramebuffer commandList.
	properties := previousFramebuffer properties copy.
]

{ #category : #accessing }
WDCRenderTargetFramebuffer >> properties [
	^ properties ifNil: [ properties := Dictionary new ]
]

{ #category : #accessing }
WDCRenderTargetFramebuffer >> propertyAt: aName [
	^ self properties at: aName
]

{ #category : #accessing }
WDCRenderTargetFramebuffer >> propertyAt: aName ifAbsent: absentBlock [
	^ self properties at: aName ifAbsent: absentBlock
]

{ #category : #accessing }
WDCRenderTargetFramebuffer >> propertyAt: aName ifAbsentPut: absentBlock [
	^ self properties at: aName ifAbsentPut: absentBlock
]

{ #category : #dependencies }
WDCRenderTargetFramebuffer >> release [
	handle ifNotNil: [ handle release. handle := nil. ].
	colorAttachments ifNotNil: [ colorAttachments do: #release. colorAttachments ].
	depthStencilAttachment ifNotNil: [ depthStencilAttachment release . depthStencilAttachment ].
	

]

{ #category : #accessing }
WDCRenderTargetFramebuffer >> sampleCount [
	^ sampleCount
]

{ #category : #accessing }
WDCRenderTargetFramebuffer >> sampleCount: anObject [
	sampleCount := anObject
]

{ #category : #accessing }
WDCRenderTargetFramebuffer >> validHandle [
	self flag: 'Check the session'.
	^ handle
]

{ #category : #accessing }
WDCRenderTargetFramebuffer >> width [
	^ width
]

{ #category : #accessing }
WDCRenderTargetFramebuffer >> width: anObject [
	width := anObject
]
