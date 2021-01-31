Class {
	#name : #WDACPUFramebufferModel,
	#superclass : #WDAModel,
	#instVars : [
		'form',
		'gpuBuffers',
		'gpuBufferSize',
		'formDecodedTexture',
		'formDecodeRenderTarget',
		'gpuParameterBuffer',
		'formEffectFullscreenPass',
		'formDecodeFullscreenPasses'
	],
	#classVars : [
		'FramebufferDecodeShaderForDepths'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Scene-CPUFramebuffer'
}

{ #category : #examples }
WDACPUFramebufferModel class >> exampleDisplay [
	| model |
	model := WDACPUFramebufferModel for: WDCEngine default form: Display.
	model open.


]

{ #category : #examples }
WDACPUFramebufferModel class >> exampleFrameBufferBitmapModel [
	| model extent |
	model := WDACPUFramebufferModel for: WDCEngine default extent: 160@120 depth: 1.
	extent := model form extent.
	model form
		getCanvas
			fillRectangle: (0@0 extent: extent) color: Color black;
			fillRectangle: (64@15 extent: 15@15) color: Color white;
			fillRectangle: (64@40 extent: 8@8) color: Color white;
			drawImage: Cursor normal at: 15@15.
	
	model open.


]

{ #category : #examples }
WDACPUFramebufferModel class >> for: aWDCEngine extent: anExtent [
	^ self for: aWDCEngine extent: anExtent depth: 32
]

{ #category : #examples }
WDACPUFramebufferModel class >> for: aWDCEngine extent: anExtent depth: aDepth [
	^ self for: aWDCEngine form: (Form extent: anExtent depth: aDepth)
]

{ #category : #examples }
WDACPUFramebufferModel class >> for: aWDCEngine form: aForm [
	^ self basicNew initializeWithEngine: aWDCEngine withForm: aForm
]

{ #category : #'class initialization' }
WDACPUFramebufferModel class >> initialize [
	super initialize.
	FramebufferDecodeShaderForDepths := Dictionary newFromPairs: #(
		1 decode_bitmap
		32 decode_bgra32
	).
]

{ #category : #initialization }
WDACPUFramebufferModel >> createFramebufferDecodePass [
	| fragmentShader |
	fragmentShader := self fragmentShaderForDecodingFramebuffer.
	^ gpuBuffers collect: [ :buffer |
		(WDCCompositionFullScreenPass for: engine)
			fragmentShader: fragmentShader;
			sourceDataStorageBuffer: buffer;
			parametersUniformBuffer: gpuParameterBuffer;
			destinationRenderTarget: formDecodeRenderTarget;
			yourself
	].

]

{ #category : #'as yet unclassified' }
WDACPUFramebufferModel >> currentFormDecodeFullscreenPass [
	^ self useDoubleBuffering
		ifTrue: [ formDecodeFullscreenPasses at: engine bufferingFrameIndex ]
		ifFalse: [ formDecodeFullscreenPasses first ]
]

{ #category : #initialization }
WDACPUFramebufferModel >> currentGPUBuffer [
	^ self useDoubleBuffering
		ifTrue: [ gpuBuffers at: engine bufferingFrameIndex  ]
		ifFalse: [ gpuBuffers first ]
]

{ #category : #'as yet unclassified' }
WDACPUFramebufferModel >> defaultViewClass [
	^ WDACPUFramebufferView
]

{ #category : #accessing }
WDACPUFramebufferModel >> form [
	^ form
]

{ #category : #accessing }
WDACPUFramebufferModel >> formEffectFullscreenPass [
	^ formEffectFullscreenPass
]

{ #category : #initialization }
WDACPUFramebufferModel >> fragmentShaderForDecodingFramebuffer [
	| library |
	library := engine resourceCache loadShaderLibrary: 'shaders/composition/framebuffer-decode.dastrel'.
	^ library getFragmentStage: (FramebufferDecodeShaderForDepths at: self framebufferDepth)
]

{ #category : #initialization }
WDACPUFramebufferModel >> framebufferDepth [
	^ form ifNotNil: [ form depth ] ifNil: [ 32 ]
]

{ #category : #initialization }
WDACPUFramebufferModel >> framebufferExtent [
	^ form ifNotNil: [ form extent ] ifNil: [ 640@480 ]
]

{ #category : #initialization }
WDACPUFramebufferModel >> getFormEffectFragmentShader [
	^ (engine resourceCache loadFragmentShader: 'shaders/composition/passthrough.dastrel')
]

{ #category : #initialization }
WDACPUFramebufferModel >> gpuBufferCount [
	^ self useDoubleBuffering ifTrue: [ engine frameBufferingCount ] ifFalse: [ 1 ]
]

{ #category : #initialization }
WDACPUFramebufferModel >> initializeModel [
	form ifNil: [ form := Form extent: self framebufferExtent depth: self framebufferDepth ].
	
	formDecodedTexture := engine createRenderTargetColorTextureWithExtent: form extent format: AGPU_TEXTURE_FORMAT_B8G8R8A8_UNORM_SRGB.
	formDecodeRenderTarget := WDCRenderTarget for: engine colorAttachments: { formDecodedTexture }.
	
	gpuBufferSize := form bits size * 4.
	gpuParameterBuffer := engine createUniformBuffer: 8 immutableData: {form width . form height} asWordArray.
	gpuBuffers := (1 to: self gpuBufferCount) collect: [ :i |
		engine createStreamingStorageBuffer: gpuBufferSize
	].

	formDecodeFullscreenPasses := self createFramebufferDecodePass.
	formEffectFullscreenPass := (WDCCompositionFullScreenPass for: engine)
		fragmentShader: self getFormEffectFragmentShader;
		sourceTexture: formDecodedTexture;
		yourself.
]

{ #category : #initialization }
WDACPUFramebufferModel >> initializeWithEngine: aWDCEngine withForm: aForm [
	form := aForm.
	^ self initializeWithEngine: aWDCEngine
]

{ #category : #'rendering process stages' }
WDACPUFramebufferModel >> prepareRendering [
	super prepareRendering.
	form unhibernate.
	LibC memCopy: form bits to: self currentGPUBuffer validPointer size: gpuBufferSize.
]

{ #category : #initialization }
WDACPUFramebufferModel >> useDoubleBuffering [
	^ true
]
