Class {
	#name : #WDCSpecularityGlossinessMaterial,
	#superclass : #WDCAbstractGenericSurfaceMaterial,
	#instVars : [
		'specularityGlossinessTexture'
	],
	#category : #'WodenEngine-Core-Material'
}

{ #category : #'state binding' }
WDCSpecularityGlossinessMaterial >> bindResources [
	super bindResources.
	specularityGlossinessTexture ifNotNil: [ resourceBinding bind: 4 texture: specularityGlossinessTexture].
]

{ #category : #'as yet unclassified' }
WDCSpecularityGlossinessMaterial >> concretizeMaterial [
	super concretizeMaterial.
	specularityGlossinessTexture := engine resourceCache concretizeTexture: specularityGlossinessTexture.
]

{ #category : #shaders }
WDCSpecularityGlossinessMaterial >> forwardFragmentShader [
	^ forwardFragmentShader ifNil: [ 
		forwardFragmentShader := 
		albedoTexture ifNotNil: [ 
			normalTexture ifNotNil: [
				specularityGlossinessTexture ifNotNil: [
					self shaderLibrary getFragmentStage: #forward_albedoNormalSpecularGlossiness
				] ifNil: [
					self shaderLibrary getFragmentStage: #forward_albedoNormal
				]		
			] ifNil: [
				specularityGlossinessTexture ifNotNil: [ 
					self shaderLibrary getFragmentStage: #forward_albedoSpecularGlossiness
			] ifNil: [
					self shaderLibrary getFragmentStage: #forward_albedo
				]
			]	
		] ifNil: [
			self shaderLibrary getFragmentStage: #forward_color
		].
	]

]

{ #category : #accessing }
WDCSpecularityGlossinessMaterial >> glossinessFactor [
	^ materialState glossinessFactor
	
]

{ #category : #accessing }
WDCSpecularityGlossinessMaterial >> glossinessFactor: aFloat [
	^ materialState glossinessFactor: aFloat
	
]

{ #category : #'state binding' }
WDCSpecularityGlossinessMaterial >> materialStateClass [
	^ WDCSpecularityGlossinessMaterialState
]

{ #category : #parsing }
WDCSpecularityGlossinessMaterial >> parse: materialFileReference data: data [
	super parse: materialFileReference data: data.
	materialState
		specularFactor: (self parse: data at: materialFileReference vector3: 'specular-factor' ifAbsent: [ WMVector3F x: 1.0 y: 1.0 z: 1.0 ]);
		glossinessFactor: (data at: 'glossiness-factor' ifAbsent: [ materialState smoothness ]).
	self flag: 'CHECK ME: Is this a linear or a sRGB texture?'.
	specularityGlossinessTexture := self parse: data at: materialFileReference optionalTexture: 'specularity-glossiness-texture'.
	self invalidateCache.
]

{ #category : #shaders }
WDCSpecularityGlossinessMaterial >> shaderLibrary [
	^ shaderLibrary ifNil: [ shaderLibrary := engine loadShaderLibrary: 'shaders/material/specularity-glossiness.dastrel' ].

]

{ #category : #accessing }
WDCSpecularityGlossinessMaterial >> specularFactor [
	^ materialState specularFactor
]

{ #category : #accessing }
WDCSpecularityGlossinessMaterial >> specularFactor: aWMVector3F [
	^ materialState specularFactor: aWMVector3F
]

{ #category : #accessing }
WDCSpecularityGlossinessMaterial >> specularityGlossinessTexture [
	^ specularityGlossinessTexture
]

{ #category : #accessing }
WDCSpecularityGlossinessMaterial >> specularityGlossinessTexture: anObject [
	specularityGlossinessTexture := anObject
]
