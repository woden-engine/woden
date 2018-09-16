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
		'normalTexture',
		'useClipMap',
		'albedoTexture'
	],
	#category : #'WodenEngine-Core-Material'
}

{ #category : #rendering }
WDCWaterMaterial >> activateForwardOn: stateTracker [
	self validateCache.
	resourceBinding ifNotNil: [ stateTracker useShaderResources: resourceBinding ].
	stateTracker
		vertexShader: self vertexShader;
		fragmentShader: self fragmentShader;
		materialBlendingMode: WDCBlendingMode alphaOver;
		materialCullMode: AGPU_CULL_MODE_NONE.
	stateTracker submode == #solid ifTrue: [
		stateTracker fragmentShader: self solidFragmentShader
	].
	stateTracker submode == #wire ifTrue: [
		stateTracker
			materialPolygonMode: AGPU_POLYGON_MODE_LINE;
			materialCullMode: AGPU_CULL_MODE_NONE;
			fragmentShader: self wireFragmentShader
	].
	^ true
]

{ #category : #accessing }
WDCWaterMaterial >> albedoColor [
	^ materialState albedo
]

{ #category : #'state binding' }
WDCWaterMaterial >> bindResources [
	| signature resourceCache |
	resourceBinding ifNil: [
		signature := WDCForwardRenderingShaderSignature for: engine.
		resourceBinding := signature newMaterialState.
	].

	stateUniformBuffer ifNil: [
		stateUniformBuffer := engine createStreamingUniformBuffer: (materialState class structureSize alignedTo: 256).
		self uploadMaterialStateData.
	].

	resourceCache := engine resourceCache.
	resourceBinding
		bind: 0 uniformBuffer: stateUniformBuffer;
		bind: 2 texture: (albedoTexture ifNil: [resourceCache whiteTexture]) startMiplevel: 0 miplevels: -1 lodclamp: 100000.0;
		bind: 3 texture: (normalTexture ifNil: [resourceCache defaultNormalTexture]) startMiplevel: 0 miplevels: -1 lodclamp: 100000.0.
	skyTexture ifNotNil: [ resourceBinding bind: 4 texture: skyTexture startMiplevel: 0 miplevels: -1 lodclamp: 100000.0 ].
		
]

{ #category : #accessing }
WDCWaterMaterial >> clipMapPeriod: aVector2 [
	materialState clipMapPeriod: aVector2
]

{ #category : #'terrain mesh building' }
WDCWaterMaterial >> createTerrainMeshForSceneNode: sceneNode boundingBox: boundingBox [
	self flag: 'TODO: Support parameterizing this.'.
	^ (WDCTerrainMeshBuilder for: self engine)
		material: self;
		createGridWithSize: (WMVector2F x: boundingBox width y: boundingBox depth)
			subdivisions: 64;
		mesh
]

{ #category : #shaders }
WDCWaterMaterial >> fragmentShader [
	^ fragmentShader ifNil: [
		fragmentShader := skyTexture ifNotNil: [
			engine loadFragmentShader: 'shaders/surface/waterSkyForward.dastrel'
		]
		ifNil: [
			 engine loadFragmentShader: 'shaders/surface/waterColorForward.dastrel' 
		]
	]
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
		textureScale: (WMVector2F x: 1.0 y: 1.0);
		yourself.
		
	self invalidateCache.
]

{ #category : #'as yet unclassified' }
WDCWaterMaterial >> invalidateCache [
	resourceBindingsAreUpdated := false.
]

{ #category : #'resource reloading' }
WDCWaterMaterial >> loadStateFromOldVersion: oldVersion [
	| oldMaterialState |
	super loadStateFromOldVersion: oldVersion.
	self skyTexture: oldVersion skyTexture.
	oldMaterialState := oldVersion materialState.
	materialState
		clipMapPeriod: oldMaterialState clipMapPeriod;
		harmonics: oldMaterialState harmonics;
		yourself
]

{ #category : #accessing }
WDCWaterMaterial >> materialState [
	^ materialState
]

{ #category : #parsing }
WDCWaterMaterial >> parse: materialFileReference data: data [
	materialState
		textureOffset: (self parse: data at: materialFileReference vector2: 'texture-offset' ifAbsent: [ WMVector2F zero ]);
		textureScale: (self parse: data at: materialFileReference vector2: 'texture-scale' ifAbsent: [ WMVector2F x: 1.0 y: 1.0 ]);

		albedo: (self parse: data at: materialFileReference srgbColor: 'albedo' ifAbsent: [ Color white ]);
		fresnel: (self parse: data at: materialFileReference vector3: 'fresnel-constant' ifAbsent: [ WMVector3F x: 0.03 y: 0.03 z: 0.03 ]).
	albedoTexture := self parse: data at: materialFileReference optionalSRGBTexture: 'albedo-texture'.
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

{ #category : #shaders }
WDCWaterMaterial >> solidFragmentShader [
	^ self fragmentShader
]

{ #category : #preview }
WDCWaterMaterial >> thumbnail [
	^ WDCResourceThumbnail type: #water value: self albedoColor asColor
]

{ #category : #'state binding' }
WDCWaterMaterial >> uploadMaterialStateData [
	stateUniformBuffer ifNotNil: [ 
		materialState storeBytesIn: stateUniformBuffer validPointer getHandle.
	]
	
]

{ #category : #'state binding' }
WDCWaterMaterial >> validateCache [
	resourceBindingsAreUpdated ifFalse: [ self bindResources ].
	resourceBindingsAreUpdated := true.
]

{ #category : #shaders }
WDCWaterMaterial >> vertexShader [
	^  vertexShader ifNil: [ vertexShader := engine loadVertexShader: 'shaders/surface/waterVertex.dastrel' ]
]

{ #category : #shaders }
WDCWaterMaterial >> wireFragmentShader [
	^ self fragmentShader
]
