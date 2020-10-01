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
	specularityGlossinessTexture ifNotNil: [ resourceBinding bind: 5 texture: specularityGlossinessTexture].
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
	specularityGlossinessTexture := self parse: data at: materialFileReference optionalTexture: 'specularity-glossiness-texture'.
	materialState
		specularFactor: (self parse: data at: materialFileReference vector3: 'specular-factor'
			ifAbsent: [
				specularityGlossinessTexture
					ifNil: [ Float32x3 ones * 0.04 ]
					ifNotNil: [ Float32x3 ones ]
		]);
		glossinessFactor: (data at: 'glossiness-factor' ifAbsent: [ materialState smoothness ]).
	self flag: 'CHECK ME: Is this a linear or a sRGB texture?'.
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
WDCSpecularityGlossinessMaterial >> specularFactor: aFloat32x3 [
	^ materialState specularFactor: aFloat32x3
]

{ #category : #accessing }
WDCSpecularityGlossinessMaterial >> specularityGlossinessTexture [
	^ specularityGlossinessTexture
]

{ #category : #accessing }
WDCSpecularityGlossinessMaterial >> specularityGlossinessTexture: anObject [
	specularityGlossinessTexture := anObject
]
