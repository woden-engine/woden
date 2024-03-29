Class {
	#name : #WDCSkyMaterial,
	#superclass : #WDCMaterial,
	#instVars : [
		'skyTexture',
		'resourceBindingsAreUpdated',
		'resourceBinding',
		'shaderLibrary',
		'forwardFragmentShader',
		'objectSpace',
		'rgbm'
	],
	#category : #'WodenEngine-Core-Material'
}

{ #category : #'state binding' }
WDCSkyMaterial >> activateForwardOn: stateTracker [
	self validateCache.
	resourceBinding ifNotNil: [ 
		stateTracker useShaderResources: resourceBinding.
	].
	
	stateTracker
		vertexShader: self vertexShader;
		fragmentShader: self forwardFragmentShader;
		materialDepthWriteMask: false.
	^ true
]

{ #category : #'state binding' }
WDCSkyMaterial >> bindResources [
	| signature |
	resourceBinding ifNil: [ 
		signature := WDCSceneRenderingShaderSignature for: engine.
		resourceBinding := signature newMaterialState.
	].
	skyTexture ifNotNil: [ resourceBinding bind: 2 texture: skyTexture ].
]

{ #category : #shaders }
WDCSkyMaterial >> forwardFragmentShader [
	^ forwardFragmentShader ifNil: [ forwardFragmentShader :=
		self shaderLibrary getFragmentStage:
			(rgbm
				ifTrue: [#forward_cubeMapRGBM]
				ifFalse: [#forward_cubeMap])
	]
]

{ #category : #initialization }
WDCSkyMaterial >> initialize [
	self invalidateCache.
	objectSpace := false.
]

{ #category : #'state binding' }
WDCSkyMaterial >> invalidateCache [
	resourceBindingsAreUpdated := false.
]

{ #category : #accessing }
WDCSkyMaterial >> objectSpace [
	^ objectSpace
]

{ #category : #accessing }
WDCSkyMaterial >> objectSpace: aBoolean [
	objectSpace := aBoolean
]

{ #category : #parsing }
WDCSkyMaterial >> parseInFolder: parentFolderFileReference data: data [
	skyTexture := self parse: data at: parentFolderFileReference optionalSRGBTexture: #texture.
	rgbm := data at: #rgbm ifAbsent: [ false ].
	self invalidateCache.
]

{ #category : #enumerating }
WDCSkyMaterial >> precacheResources [
	self shaderLibrary
]

{ #category : #accessing }
WDCSkyMaterial >> rgbm [

	^ rgbm
]

{ #category : #accessing }
WDCSkyMaterial >> rgbm: anObject [

	rgbm := anObject
]

{ #category : #shaders }
WDCSkyMaterial >> shaderLibrary [
	^ shaderLibrary ifNil: [ shaderLibrary := engine loadShaderLibrary: 'shaders/material/sky.dastrel' ].

]

{ #category : #accessing }
WDCSkyMaterial >> skyTexture [
	^ skyTexture
]

{ #category : #accessing }
WDCSkyMaterial >> skyTexture: anObject [
	skyTexture := anObject.
	self invalidateCache
]

{ #category : #preview }
WDCSkyMaterial >> thumbnail [
	skyTexture ifNotNil: [ ^ WDCResourceThumbnail type: #sky value: skyTexture thumbnail ].
	^ WDCResourceThumbnail type: #sky value: Color blue
]

{ #category : #'state binding' }
WDCSkyMaterial >> validateCache [
	resourceBindingsAreUpdated ifFalse: [ self bindResources ].
	resourceBindingsAreUpdated := true.
]

{ #category : #shaders }
WDCSkyMaterial >> vertexShader [
	^ objectSpace
		ifTrue: [ self shaderLibrary getVertexStage: #vertexObject ]
		ifFalse: [ self shaderLibrary getVertexStage: #vertex ]
]
