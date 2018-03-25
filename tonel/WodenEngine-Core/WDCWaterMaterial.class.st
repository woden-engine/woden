Class {
	#name : #WDCWaterMaterial,
	#superclass : #WDCMaterial,
	#instVars : [
		'skyTexture',
		'resourceBindingsAreUpdated',
		'vertexShader',
		'fragmentShader',
		'resourceBinding',
		'stateUniformBuffer',
		'materialState',
		'normalTexture'
	],
	#category : 'WodenEngine-Core-Material'
}

{ #category : #rendering }
WDCWaterMaterial >> activateForwardOn: stateTracker [
	self validateCache.
	resourceBinding ifNotNil: [ 
		stateTracker useShaderResources: resourceBinding.
	].
	
	stateTracker
		vertexShader: vertexShader;
		fragmentShader: fragmentShader;
		materialBlendingMode: WDCBlendingMode alphaOver.
	^ true
]

{ #category : #'state binding' }
WDCWaterMaterial >> bindResources [
	| signature |
	resourceBinding ifNil: [
		signature := WDCForwardRenderingShaderSignature for: engine.
		resourceBinding := signature newMaterialState.
	].

	stateUniformBuffer ifNil: [
		stateUniformBuffer := engine createStreamingUniformBuffer: (materialState class structureSize alignedTo: 256).
		self uploadMaterialStateData.
	].

	resourceBinding bind: 0 uniformBuffer: stateUniformBuffer.
	normalTexture ifNotNil: [ resourceBinding bind: 2 texture: normalTexture startMiplevel: 0 miplevels: -1 lodclamp: 100000.0 ].
	skyTexture ifNotNil: [ resourceBinding bind: 3 texture: skyTexture startMiplevel: 0 miplevels: -1 lodclamp: 100000.0 ].
		
]

{ #category : #'state binding' }
WDCWaterMaterial >> fetchShaders [
	vertexShader ifNil: [
		vertexShader := engine loadVertexShader: 'shaders/surface/waterVertex.dastrel'.
	].

	fragmentShader ifNil: [ 
		skyTexture ifNotNil: [
			fragmentShader := engine loadFragmentShader: 'shaders/surface/waterSkyForward.dastrel'.
		] ifNil: [ 
			fragmentShader := engine loadFragmentShader: 'shaders/surface/waterColorForward.dastrel'.
		].
	].
]

{ #category : #accessing }
WDCWaterMaterial >> harmonicAt: index amplitude: amplitude frequency: frequency center: center [
	materialState harmonicAt: index put: (
		WTWaterHarmonic new
		amplitude: amplitude;
		frequency: frequency;
		center: center;
		radial: true asBit
	).
]

{ #category : #accessing }
WDCWaterMaterial >> harmonicAt: index amplitude: amplitude frequency: frequency direction: direction [
	materialState harmonicAt: index put: (
		WTWaterHarmonic new
		amplitude: amplitude;
		frequency: frequency;
		center: direction;
		radial: false asBit
	).
]

{ #category : #initialization }
WDCWaterMaterial >> initialize [
	materialState := WTWaterMaterialState new
		albedo: Color white asWMVector4F;
		fresnel: (WMVector3F x: 0.03 y: 0.03 z: 0.03);
		smoothness: 0.45;
		propagationSpeed: 2.0;
		yourself.
		
	self invalidateCache.
]

{ #category : #'as yet unclassified' }
WDCWaterMaterial >> invalidateCache [
	resourceBindingsAreUpdated := false.
]

{ #category : #parsing }
WDCWaterMaterial >> parse: materialFileReference data: data [
	materialState
		albedo: (self parse: data at: materialFileReference srgbColor: 'color' ifAbsent: [ Color black ]);
		fresnel: (self parse: data at: materialFileReference vector3: 'fresnel-constant' ifAbsent: [ WMVector3F x: 0.03 y: 0.03 z: 0.03 ]).
	normalTexture := self parse: data at: materialFileReference optionalTexture: 'normal-texture'.
	self invalidateCache.
]

{ #category : #accessing }
WDCWaterMaterial >> skyTexture [
	^ skyTexture
]

{ #category : #accessing }
WDCWaterMaterial >> skyTexture: anObject [
	skyTexture := anObject
]

{ #category : #'state binding' }
WDCWaterMaterial >> uploadMaterialStateData [
	stateUniformBuffer ifNotNil: [ 
		materialState storeBytesIn: stateUniformBuffer validPointer getHandle.
	]
	
]

{ #category : #'state binding' }
WDCWaterMaterial >> validateCache [
	(vertexShader isNil or: [ fragmentShader isNil ]) ifTrue: [ self fetchShaders ].
	resourceBindingsAreUpdated ifFalse: [ self bindResources ].
	resourceBindingsAreUpdated := true.
]
