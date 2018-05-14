Class {
	#name : #WDPPompeiiShaderSignature,
	#superclass : #WDCShaderSignature,
	#instVars : [
		'defaultSamplers'
	],
	#category : #'WodenEngine-Pompeii'
}

{ #category : #'as yet unclassified' }
WDPPompeiiShaderSignature class >> signatureSpec: spec [
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
		yourself
]

{ #category : #'generated shader signature methods' }
WDPPompeiiShaderSignature >> constantColorRampIndexOffset [
	^ 8
]

{ #category : #'generated shader signature methods' }
WDPPompeiiShaderSignature >> constantColorRampIndexSize [
	^ 4
]

{ #category : #'generated shader signature methods' }
WDPPompeiiShaderSignature >> constantColorRampSizeOffset [
	^ 12
]

{ #category : #'generated shader signature methods' }
WDPPompeiiShaderSignature >> constantColorRampSizeSize [
	^ 4
]

{ #category : #'generated shader signature methods' }
WDPPompeiiShaderSignature >> constantModelViewMatrixIndexOffset [
	^ 0
]

{ #category : #'generated shader signature methods' }
WDPPompeiiShaderSignature >> constantModelViewMatrixIndexSize [
	^ 4
]

{ #category : #'generated shader signature methods' }
WDPPompeiiShaderSignature >> constantProjectionMatrixIndexOffset [
	^ 4
]

{ #category : #'generated shader signature methods' }
WDPPompeiiShaderSignature >> constantProjectionMatrixIndexSize [
	^ 4
]

{ #category : #'generated shader signature methods' }
WDPPompeiiShaderSignature >> createHandleForDevice: device [
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
		build

]

{ #category : #accessing }
WDPPompeiiShaderSignature >> defaultSamplers [
	| samplerDesc bindings |
	self flag: 'Add session check.'.
	defaultSamplers ifNotNil: [ ^ defaultSamplers ].
	
	samplerDesc := AGPUSamplerDescription new
		filter: AGPU_FILTER_MIN_LINEAR_MAG_LINEAR_MIPMAP_LINEAR;
		address_u: AGPU_TEXTURE_ADDRESS_MODE_WRAP;
		address_v: AGPU_TEXTURE_ADDRESS_MODE_WRAP;
		address_w: AGPU_TEXTURE_ADDRESS_MODE_WRAP;
		max_lod: 10000.0;
		yourself.
		
	bindings := self newSamplers.
	bindings
		createSampler: 0 description: samplerDesc;
		createSampler: 1 description: samplerDesc.
		
	samplerDesc := AGPUSamplerDescription new
		filter: AGPU_FILTER_MIN_LINEAR_MAG_LINEAR_MIPMAP_LINEAR;
		address_u: AGPU_TEXTURE_ADDRESS_MODE_CLAMP ;
		address_v: AGPU_TEXTURE_ADDRESS_MODE_CLAMP;
		address_w: AGPU_TEXTURE_ADDRESS_MODE_CLAMP;
		max_lod: 10000.0;
		yourself.
	bindings
		createSampler: 2 description: samplerDesc.

	samplerDesc := AGPUSamplerDescription new
		filter: AGPU_FILTER_MIN_LINEAR_MAG_LINEAR_MIPMAP_LINEAR;
		address_u: AGPU_TEXTURE_ADDRESS_MODE_CLAMP;
		address_v: AGPU_TEXTURE_ADDRESS_MODE_CLAMP;
		address_w: AGPU_TEXTURE_ADDRESS_MODE_CLAMP;
		comparison_enabled: 1;
		comparison_function: AGPU_GREATER;
		max_lod: 10000.0;
		yourself.
	bindings
		createSampler: 3 description: samplerDesc.		
	^ defaultSamplers := bindings
]

{ #category : #'generated shader signature methods' }
WDPPompeiiShaderSignature >> newCanvasViewport [
	^ engine createShaderSignature: self resourceBinding: 0 elements: 2
]

{ #category : #'generated shader signature methods' }
WDPPompeiiShaderSignature >> newFont [
	^ engine createShaderSignature: self resourceBinding: 2 elements: 1
]

{ #category : #'generated shader signature methods' }
WDPPompeiiShaderSignature >> newSamplers [
	^ engine createShaderSignature: self resourceBinding: 3 elements: 5
]

{ #category : #'generated shader signature methods' }
WDPPompeiiShaderSignature >> newTexture [
	^ engine createShaderSignature: self resourceBinding: 1 elements: 1
]
