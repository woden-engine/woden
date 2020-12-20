Class {
	#name : #WDBBabylonShaderSignature,
	#superclass : #WDCShaderSignature,
	#instVars : [
		'defaultSamplers',
		'defaultSamplersSession'
	],
	#category : #'WodenEngine-Babylon'
}

{ #category : #'as yet unclassified' }
WDBBabylonShaderSignature class >> signatureSpec: spec [
	"
	self rebuildShaderSignatureMethods
	"
	spec
		name: #Pompeii;
		bank: #CanvasViewport with: [ :bank |
			bank
				maxBindings: 1024;
				storage: #ViewportState;
				storage: #ColorRamps
		];
		bank: #Texture with: [ :bank |
			bank
				maxBindings: 1024;
				texture: #Texture
		];
		bank: #Font with: [ :bank |
			bank
				maxBindings: 1024;
				texture: #Font
		];
		bank: #Samplers with: [ :bank |
			bank
				maxBindings: 10;
				sampler: #Samplers count: 5
		];
		pushConstant: #ModelViewMatrixIndex;
		pushConstant: #ProjectionMatrixIndex;
		pushConstant: #ColorRampIndex;
		pushConstant: #ColorRampSize;
		pushConstant: #TextureArrayIndex;
		yourself
]

{ #category : #'generated shader signature methods' }
WDBBabylonShaderSignature >> constantColorRampIndexOffset [
	^ 8
]

{ #category : #'generated shader signature methods' }
WDBBabylonShaderSignature >> constantColorRampIndexSize [
	^ 4
]

{ #category : #'generated shader signature methods' }
WDBBabylonShaderSignature >> constantColorRampSizeOffset [
	^ 12
]

{ #category : #'generated shader signature methods' }
WDBBabylonShaderSignature >> constantColorRampSizeSize [
	^ 4
]

{ #category : #'generated shader signature methods' }
WDBBabylonShaderSignature >> constantModelViewMatrixIndexOffset [
	^ 0
]

{ #category : #'generated shader signature methods' }
WDBBabylonShaderSignature >> constantModelViewMatrixIndexSize [
	^ 4
]

{ #category : #'generated shader signature methods' }
WDBBabylonShaderSignature >> constantProjectionMatrixIndexOffset [
	^ 4
]

{ #category : #'generated shader signature methods' }
WDBBabylonShaderSignature >> constantProjectionMatrixIndexSize [
	^ 4
]

{ #category : #'generated shader signature methods' }
WDBBabylonShaderSignature >> constantTextureArrayIndexOffset [
	^ 16
]

{ #category : #'generated shader signature methods' }
WDBBabylonShaderSignature >> constantTextureArrayIndexSize [
	^ 4
]

{ #category : #'generated shader signature methods' }
WDBBabylonShaderSignature >> createHandleForDevice: device [
	^ device createShaderSignatureBuilder

		"CanvasViewport"
		beginBindingBank: 1024;
			addBindingBankElement: AGPU_SHADER_BINDING_TYPE_STORAGE_BUFFER bindingPointCount: 1; "ViewportState"
			addBindingBankElement: AGPU_SHADER_BINDING_TYPE_STORAGE_BUFFER bindingPointCount: 1; "ColorRamps"

		"Texture"
		beginBindingBank: 1024;
			addBindingBankElement: AGPU_SHADER_BINDING_TYPE_SAMPLED_IMAGE bindingPointCount: 1; "Texture"

		"Font"
		beginBindingBank: 1024;
			addBindingBankElement: AGPU_SHADER_BINDING_TYPE_SAMPLED_IMAGE bindingPointCount: 1; "Font"

		"Samplers"
		beginBindingBank: 10;
			addBindingBankElement: AGPU_SHADER_BINDING_TYPE_SAMPLER bindingPointCount: 5; "Samplers"

		addBindingConstant; "ModelViewMatrixIndex"
		addBindingConstant; "ProjectionMatrixIndex"
		addBindingConstant; "ColorRampIndex"
		addBindingConstant; "ColorRampSize"
		addBindingConstant; "TextureArrayIndex"
		build

]

{ #category : #accessing }
WDBBabylonShaderSignature >> defaultSamplers [
	| samplerDesc bindings |
	(defaultSamplersSession == Smalltalk session and: [ defaultSamplers isNotNil ]) ifTrue: [ ^ defaultSamplers ].
	
	samplerDesc := AGPUSamplerDescription new
		filter: AGPU_FILTER_MIN_LINEAR_MAG_LINEAR_MIPMAP_NEAREST;
		address_u: AGPU_TEXTURE_ADDRESS_MODE_WRAP;
		address_v: AGPU_TEXTURE_ADDRESS_MODE_WRAP;
		address_w: AGPU_TEXTURE_ADDRESS_MODE_WRAP;
		max_lod: 10000.0;
		maxanisotropy: engine maxAnisotropy asFloat;
		yourself.
		
	bindings := self newSamplers.
	bindings
		createSampler: 0 description: samplerDesc;
		createSampler: 1 description: samplerDesc.
		
	defaultSamplersSession := Smalltalk session.
	^ defaultSamplers := bindings
]

{ #category : #'generated shader signature methods' }
WDBBabylonShaderSignature >> newCanvasViewport [
	^ engine createShaderSignature: self resourceBinding: 0 elements: 2
]

{ #category : #'generated shader signature methods' }
WDBBabylonShaderSignature >> newFont [
	^ engine createShaderSignature: self resourceBinding: 2 elements: 1
]

{ #category : #'generated shader signature methods' }
WDBBabylonShaderSignature >> newSamplers [
	^ engine createShaderSignature: self resourceBinding: 3 elements: 5
]

{ #category : #'generated shader signature methods' }
WDBBabylonShaderSignature >> newTexture [
	^ engine createShaderSignature: self resourceBinding: 1 elements: 1
]
