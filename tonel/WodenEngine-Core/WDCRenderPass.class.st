Class {
	#name : #WDCRenderPass,
	#superclass : #WDCResourceWithSessionHandle,
	#instVars : [
		'colorAttachments',
		'depthStencilAttachment'
	],
	#category : 'WodenEngine-Core-GPU-Resources'
}

{ #category : #'resource building' }
WDCRenderPass >> buildHandle [
	| colorAttachmentBuffer colorAttachmentSize depthStencilAttachmentBuffer description |
	colorAttachmentBuffer := nil.
	depthStencilAttachmentBuffer := nil.
	colorAttachments ifNotEmpty: [
		colorAttachmentSize := AGPURenderpassColorAttachmentDescription structureSize.
		colorAttachmentBuffer := ExternalAddress allocate: colorAttachmentSize * colorAttachments size.
	].

	[
		"Copy the color attachments to the buffer"
		1 to: colorAttachments size do: [ :i |
			LibC memCopy: (colorAttachments at: i) getHandle to: colorAttachmentBuffer + ((i - 1) * colorAttachmentSize) size: colorAttachmentSize
		].
	
		depthStencilAttachment ifNotNil: [
			depthStencilAttachmentBuffer := ExternalAddress allocate: AGPURenderpassDepthStencilDescription structureSize.
			LibC memCopy: depthStencilAttachment getHandle to: depthStencilAttachmentBuffer size: AGPURenderpassDepthStencilDescription structureSize.
		].
		
		description := AGPURenderpassDescription new
			color_attachment_count: colorAttachments size;
			yourself.
		colorAttachmentBuffer ifNotNil: [ 
			description color_attachments: (AGPURenderpassColorAttachmentDescription fromHandle: colorAttachmentBuffer)
		].
			
		depthStencilAttachment ifNotNil: [ 
			description depth_stencil_attachment: (AGPURenderpassDepthStencilDescription fromHandle: depthStencilAttachmentBuffer).
		].
		handle := engine device createRenderPass: description.
	] ensure: [
		colorAttachmentBuffer ifNotNil: [ colorAttachmentBuffer free ].
		depthStencilAttachmentBuffer ifNotNil: [ depthStencilAttachmentBuffer free ]
	].
]

{ #category : #accessing }
WDCRenderPass >> colorAttachments [
	^ colorAttachments
]

{ #category : #accessing }
WDCRenderPass >> colorAttachments: anObject [
	colorAttachments := anObject
]

{ #category : #accessing }
WDCRenderPass >> depthStencilAttachment [
	^ depthStencilAttachment
]

{ #category : #accessing }
WDCRenderPass >> depthStencilAttachment: anObject [
	depthStencilAttachment := anObject
]

{ #category : #initialization }
WDCRenderPass >> initialize [
	super initialize.
	colorAttachments := #().
]

{ #category : #initialization }
WDCRenderPass >> setColor: colorAttachmentIndex attachmentBeginAction: beginAction endAction: endAction [
	(colorAttachments at: colorAttachmentIndex)
			begin_action: beginAction;
			end_action: endAction.

	self invalidateHandle
]

{ #category : #initialization }
WDCRenderPass >> setColorAttachmentBeginAction: beginAction endAction: endAction [
	colorAttachments do: [ :attachment |
		attachment
			begin_action: beginAction;
			end_action: endAction
	].

	self invalidateHandle
]

{ #category : #'as yet unclassified' }
WDCRenderPass >> setColorClearValue: attachment_index value: value [
	self hasValidHandle ifTrue: [ self validHandle setColorClearValueFrom: attachment_index value: value ].
]

{ #category : #initialization }
WDCRenderPass >> setDepthStencilBeginAction: beginAction endAction: endAction [
	depthStencilAttachment ifNotNil: [ 
		depthStencilAttachment
			begin_action: beginAction;
			end_action: endAction
	].
	self invalidateHandle
]
