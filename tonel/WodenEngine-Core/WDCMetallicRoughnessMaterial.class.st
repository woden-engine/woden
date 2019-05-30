Class {
	#name : #WDCMetallicRoughnessMaterial,
	#superclass : #WDCAbstractGenericSurfaceMaterial,
	#instVars : [
		'metallicRoughnessTexture'
	],
	#category : #'WodenEngine-Core-Material'
}

{ #category : #'state binding' }
WDCMetallicRoughnessMaterial >> bindResources [
	super bindResources.
	metallicRoughnessTexture ifNotNil: [ resourceBinding bind: 4 texture: metallicRoughnessTexture].
]

{ #category : #'as yet unclassified' }
WDCMetallicRoughnessMaterial >> concretizeMaterial [
	super concretizeMaterial.
	metallicRoughnessTexture := engine resourceCache concretizeTexture: metallicRoughnessTexture.
]

{ #category : #rendering }
WDCMetallicRoughnessMaterial >> forwardFragmentShader [
	^ forwardFragmentShader ifNil: [ 
		forwardFragmentShader := 
		albedoTexture ifNotNil: [ 
			normalTexture ifNotNil: [
				metallicRoughnessTexture ifNotNil: [
					self shaderLibrary getFragmentStage: #forward_albedoNormalMetallicRoughness
				] ifNil: [
					self shaderLibrary getFragmentStage: #forward_albedoNormal
				]		
			] ifNil: [
				metallicRoughnessTexture ifNotNil: [ 
					self shaderLibrary getFragmentStage: #forward_albedoMetallicRoughness
			] ifNil: [
					self shaderLibrary getFragmentStage: #forward_albedo
				]
			]	
		] ifNil: [
			self shaderLibrary getFragmentStage: #forward_color
		].
	]

]

{ #category : #initialization }
WDCMetallicRoughnessMaterial >> initialize [
	super initialize.
	materialState
		metallicFactor: 0.0;
		roughnessFactor: 0.55
]

{ #category : #'state binding' }
WDCMetallicRoughnessMaterial >> materialStateClass [
	^ WDCMetallicRoughnessMaterialState
]

{ #category : #accessing }
WDCMetallicRoughnessMaterial >> metallicFactor [
	^ materialState metallicFactor
]

{ #category : #accessing }
WDCMetallicRoughnessMaterial >> metallicFactor: factor [
	materialState metallicFactor: factor asFloat.
	self uploadMaterialStateData
]

{ #category : #accessing }
WDCMetallicRoughnessMaterial >> metallicRoughnessTexture [
	^ metallicRoughnessTexture
]

{ #category : #accessing }
WDCMetallicRoughnessMaterial >> metallicRoughnessTexture: anObject [
	metallicRoughnessTexture := anObject
]

{ #category : #parsing }
WDCMetallicRoughnessMaterial >> parse: materialFileReference data: data [
	super parse: materialFileReference data: data.
	materialState
		roughnessFactor: (data at: 'roughness-factor' ifAbsent: [ materialState roughnessFactor ]);
		metallicFactor: (data at: 'metallic-factor' ifAbsent: [ materialState metallicFactor ]).
	metallicRoughnessTexture := self parse: data at: materialFileReference optionalTexture: 'metallic-roughness-texture'.
	self invalidateCache.
]

{ #category : #accessing }
WDCMetallicRoughnessMaterial >> roughnessFactor [
	^ materialState
]

{ #category : #accessing }
WDCMetallicRoughnessMaterial >> roughnessFactor: factor [
	materialState roughnessFactor: factor asFloat.
	self uploadMaterialStateData
]

{ #category : #accessing }
WDCMetallicRoughnessMaterial >> shaderLibrary [
	^ shaderLibrary ifNil: [ shaderLibrary := engine loadShaderLibrary: 'shaders/material/metallic-roughness.dastrel' ].

]
