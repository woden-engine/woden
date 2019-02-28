Class {
	#name : #WDCShaderResourceBinding,
	#superclass : #WDCResourceWithSessionHandle,
	#instVars : [
		'shaderSignature',
		'slots',
		'binding',
		'slotActions'
	],
	#category : 'WodenEngine-Core-GPU-Resources'
}

{ #category : #binding }
WDCShaderResourceBinding >> bind: slot renderTarget: renderTarget startMiplevel: startMipLevel miplevels: mipLevels lodclamp: lodClamp [
	self slotAt: slot + 1 put: renderTarget action: [
		self validHandle bindTexture: slot texture: renderTarget currentFramebuffer colorAttachments first validHandle startMiplevel: startMipLevel miplevels: mipLevels lodclamp: lodClamp
	].
]

{ #category : #binding }
WDCShaderResourceBinding >> bind: slot storageBuffer: storageBuffer [
	self slotAt: slot + 1 put: storageBuffer action: [
		self validHandle bindStorageBuffer: slot storage_buffer: storageBuffer validHandle
	].
]

{ #category : #binding }
WDCShaderResourceBinding >> bind: slot storageBuffer: storageBuffer offset: offset size: size [
	self bind: slot storageBuffer: storageBuffer offset: offset size: size value: storageBuffer
]

{ #category : #binding }
WDCShaderResourceBinding >> bind: slot storageBuffer: storageBuffer offset: offset size: size value: value [
	self slotAt: slot + 1 put: value action: [
		self validHandle bindStorageBufferRange: slot storage_buffer: storageBuffer validHandle offset: offset size: size
	].
]

{ #category : #binding }
WDCShaderResourceBinding >> bind: slot storageBufferElement: bufferElement [
	bufferElement bind: slot storageOn: self
]

{ #category : #binding }
WDCShaderResourceBinding >> bind: slot storageImage: texture level: level layer: layer [
	self bind: slot storageImage: texture validHandle level: level layer: layer access: AGPU_READ_WRITE format: texture description format
]

{ #category : #binding }
WDCShaderResourceBinding >> bind: slot storageImage: texture level: level layer: layer access: access format: format [
	self slotAt: slot + 1 put: texture action: [
		self validHandle bindImage: slot texture: texture level: level layer: layer access: access format: format
	].
]

{ #category : #binding }
WDCShaderResourceBinding >> bind: slot texture: texture startMiplevel: startMipLevel miplevels: mipLevels lodclamp: lodClamp [
	self slotAt: slot + 1 put: texture action: [
		self validHandle bindTexture: slot texture: texture validHandle startMiplevel: startMipLevel miplevels: mipLevels lodclamp: lodClamp
	].
]

{ #category : #binding }
WDCShaderResourceBinding >> bind: slot textureArray: texture startMiplevel: startMipLevel miplevels: mipLevels firstElement: firstElement numberOfElements: numberOfElements lodclamp: lodClamp [
	self slotAt: slot + 1 put: texture action: [
		self validHandle bindTextureArrayRange: slot texture: texture validHandle startMiplevel: startMipLevel miplevels: mipLevels firstElement: firstElement numberOfElements: numberOfElements lodclamp: lodClamp
	].
]

{ #category : #binding }
WDCShaderResourceBinding >> bind: slot uniformBuffer: uniformBuffer [
	self slotAt: slot + 1 put: uniformBuffer action: [
		self validHandle bindUniformBuffer: slot uniform_buffer: uniformBuffer validHandle
	].
]

{ #category : #binding }
WDCShaderResourceBinding >> bind: slot uniformBuffer: uniformBuffer offset: offset size: size [
	self bind: slot uniformBuffer: uniformBuffer offset: offset size: size value: uniformBuffer
]

{ #category : #binding }
WDCShaderResourceBinding >> bind: slot uniformBuffer: uniformBuffer offset: offset size: size value: value [
	self slotAt: slot + 1 put: value action: [
		self validHandle bindUniformBufferRange: slot uniform_buffer: uniformBuffer validHandle offset: offset size: size
	].
]

{ #category : #binding }
WDCShaderResourceBinding >> bind: slot uniformBufferElement: bufferElement [
	bufferElement bind: slot uniformOn: self
]

{ #category : #accessing }
WDCShaderResourceBinding >> binding [
	^ binding
]

{ #category : #accessing }
WDCShaderResourceBinding >> binding: anObject [
	binding := anObject
]

{ #category : #'resource building' }
WDCShaderResourceBinding >> buildHandle [
	handle := shaderSignature handle createShaderResourceBinding: binding.
	slotActions do: [ :slot | slot value ]
]

{ #category : #binding }
WDCShaderResourceBinding >> createSampler: slot description: description [
	self slotAt: slot + 1 put: description action: [
		self validHandle createSampler: slot description: description
	].
]

{ #category : #accessing }
WDCShaderResourceBinding >> elements: numberOfElements [
	self flag: 'Pass an actual descriptor of the elements'.
	slots := Array new: numberOfElements.
	slotActions := Array new: numberOfElements.
]

{ #category : #initialization }
WDCShaderResourceBinding >> initialize [
	super initialize
]

{ #category : #accessing }
WDCShaderResourceBinding >> shaderSignature [
	^ shaderSignature
]

{ #category : #accessing }
WDCShaderResourceBinding >> shaderSignature: anObject [
	shaderSignature := anObject
]

{ #category : #private }
WDCShaderResourceBinding >> slotAt: slot put: aBlock [
	slots at: slot put: aBlock.
	self hasValidHandle ifTrue: [ aBlock value ]
]

{ #category : #accessing }
WDCShaderResourceBinding >> slotAt: slot put: value action: aBlock [
	slots at: slot put: value.
	slotActions at: slot put: aBlock.
	self hasValidHandle ifTrue: [ aBlock value ]
]

{ #category : #accessing }
WDCShaderResourceBinding >> slotValueAt: index [
	^ slots at: index + 1
]
