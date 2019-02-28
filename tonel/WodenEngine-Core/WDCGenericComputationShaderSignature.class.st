Class {
	#name : #WDCGenericComputationShaderSignature,
	#superclass : #WDCShaderSignature,
	#instVars : [
		'defaultSamplers',
		'defaultSamplersSession'
	],
	#category : #'WodenEngine-Core-Shaders'
}

{ #category : #'as yet unclassified' }
WDCGenericComputationShaderSignature class >> signatureSpec: spec [
	"
	self rebuildShaderSignatureMethods
	"
	spec
		name: #GenericComputation;
		bank: #Samplers with: [ :bank |
			bank
				maxBindings: 10;
				sampler: #Samplers count: 4
		];
		bank: #UniformBuffers with: [ :bank |
			bank
				maxBindings: 1000;
				uniform: #Buffers count: 4
		];
		bank: #Textures with: [ :bank |
			bank
				maxBindings: 1000;
				texture: #ObjectState count: 4
		];
		bank: #StorageBuffers with: [ :bank |
			bank
				maxBindings: 10000;
				storage: #Buffers count: 4
		];
		bank: #StorageImages with: [ :bank |
			bank
				maxBindings: 10000;
				storageImage: #Images count: 4
		];
		pushConstant: #Arguments size: 128;
		yourself
]

{ #category : #'generated shader signature methods' }
WDCGenericComputationShaderSignature >> constantArgumentsOffset [
	^ 0
]

{ #category : #'generated shader signature methods' }
WDCGenericComputationShaderSignature >> constantArgumentsSize [
	^ 128
]

{ #category : #'generated shader signature methods' }
WDCGenericComputationShaderSignature >> createHandleForDevice: device [
	^ device createShaderSignatureBuilder

		"Samplers"
		beginBindingBank: 10;
			addBindingBankElement: AGPU_SHADER_BINDING_TYPE_SAMPLER bindingPointCount: 4; "Samplers"

		"UniformBuffers"
		beginBindingBank: 1000;
			addBindingBankElement: AGPU_SHADER_BINDING_TYPE_UNIFORM_BUFFER bindingPointCount: 4; "Buffers"

		"Textures"
		beginBindingBank: 1000;
			addBindingBankElement: AGPU_SHADER_BINDING_TYPE_SAMPLED_IMAGE bindingPointCount: 4; "ObjectState"

		"StorageBuffers"
		beginBindingBank: 10000;
			addBindingBankElement: AGPU_SHADER_BINDING_TYPE_STORAGE_BUFFER bindingPointCount: 4; "Buffers"

		"StorageImages"
		beginBindingBank: 10000;
			addBindingBankElement: AGPU_SHADER_BINDING_TYPE_STORAGE_IMAGE bindingPointCount: 4; "Images"

		addBindingConstant; "Arguments"
		addBindingConstant; "Arguments"
		addBindingConstant; "Arguments"
		addBindingConstant; "Arguments"
		addBindingConstant; "Arguments"
		addBindingConstant; "Arguments"
		addBindingConstant; "Arguments"
		addBindingConstant; "Arguments"
		addBindingConstant; "Arguments"
		addBindingConstant; "Arguments"
		addBindingConstant; "Arguments"
		addBindingConstant; "Arguments"
		addBindingConstant; "Arguments"
		addBindingConstant; "Arguments"
		addBindingConstant; "Arguments"
		addBindingConstant; "Arguments"
		addBindingConstant; "Arguments"
		addBindingConstant; "Arguments"
		addBindingConstant; "Arguments"
		addBindingConstant; "Arguments"
		addBindingConstant; "Arguments"
		addBindingConstant; "Arguments"
		addBindingConstant; "Arguments"
		addBindingConstant; "Arguments"
		addBindingConstant; "Arguments"
		addBindingConstant; "Arguments"
		addBindingConstant; "Arguments"
		addBindingConstant; "Arguments"
		addBindingConstant; "Arguments"
		addBindingConstant; "Arguments"
		addBindingConstant; "Arguments"
		addBindingConstant; "Arguments"
		build

]

{ #category : #accessing }
WDCGenericComputationShaderSignature >> defaultSamplers [
	| wrapSampler clampSampler bindings |
	(defaultSamplersSession == Smalltalk session and: [ defaultSamplers isNotNil ]) ifTrue: [ ^ defaultSamplers ].
	
	"Nearest wrap"
	wrapSampler := AGPUSamplerDescription new
		address_u: AGPU_TEXTURE_ADDRESS_MODE_WRAP;
		address_v: AGPU_TEXTURE_ADDRESS_MODE_WRAP;
		address_w: AGPU_TEXTURE_ADDRESS_MODE_WRAP;
		max_lod: 10000.0;
		maxanisotropy: 1;
		yourself.

	clampSampler := AGPUSamplerDescription new
		address_u: AGPU_TEXTURE_ADDRESS_MODE_CLAMP;
		address_v: AGPU_TEXTURE_ADDRESS_MODE_CLAMP;
		address_w: AGPU_TEXTURE_ADDRESS_MODE_CLAMP;
		max_lod: 10000.0;
		maxanisotropy: 1;
		yourself.

	wrapSampler filter: AGPU_FILTER_MIN_NEAREST_MAG_NEAREST_MIPMAP_NEAREST.
	clampSampler filter: AGPU_FILTER_MIN_NEAREST_MAG_NEAREST_MIPMAP_NEAREST.
		
	bindings := self newSamplers.
	bindings
		createSampler: 0 description: wrapSampler;
		createSampler: 1 description: clampSampler.
		
	wrapSampler filter: AGPU_FILTER_MIN_LINEAR_MAG_LINEAR_MIPMAP_NEAREST.
	clampSampler filter: AGPU_FILTER_MIN_LINEAR_MAG_LINEAR_MIPMAP_NEAREST.
		
	bindings
		createSampler: 2 description: wrapSampler;
		createSampler: 3 description: clampSampler.

	defaultSamplersSession := Smalltalk session.
	^ defaultSamplers := bindings
]

{ #category : #'generated shader signature methods' }
WDCGenericComputationShaderSignature >> newSamplers [
	^ engine createShaderSignature: self resourceBinding: 0 elements: 4
]

{ #category : #'generated shader signature methods' }
WDCGenericComputationShaderSignature >> newStorageBuffers [
	^ engine createShaderSignature: self resourceBinding: 3 elements: 4
]

{ #category : #'generated shader signature methods' }
WDCGenericComputationShaderSignature >> newStorageImages [
	^ engine createShaderSignature: self resourceBinding: 4 elements: 4
]

{ #category : #'generated shader signature methods' }
WDCGenericComputationShaderSignature >> newTextures [
	^ engine createShaderSignature: self resourceBinding: 2 elements: 4
]

{ #category : #'generated shader signature methods' }
WDCGenericComputationShaderSignature >> newUniformBuffers [
	^ engine createShaderSignature: self resourceBinding: 1 elements: 4
]
