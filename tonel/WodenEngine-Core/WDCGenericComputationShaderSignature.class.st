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
				sampler: #Samplers count: 6
		];
		bank: #UniformBuffers with: [ :bank |
			bank
				maxBindings: 1000;
				uniform: #Buffers count: 4
		];
		bank: #SampledTextures with: [ :bank |
			bank
				maxBindings: 1000;
				texture: #Textures count: 4
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

{ #category : #'as yet unclassified' }
WDCGenericComputationShaderSignature >> activeOnStateTracker: stateTracker [
	super activeOnStateTracker: stateTracker.
	stateTracker useShaderResources: self defaultSamplers.
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
			addBindingBankElement: AGPU_SHADER_BINDING_TYPE_SAMPLER bindingPointCount: 6; "Samplers"

		"UniformBuffers"
		beginBindingBank: 1000;
			addBindingBankElement: AGPU_SHADER_BINDING_TYPE_UNIFORM_BUFFER bindingPointCount: 4; "Buffers"

		"SampledTextures"
		beginBindingBank: 1000;
			addBindingBankElement: AGPU_SHADER_BINDING_TYPE_SAMPLED_IMAGE bindingPointCount: 4; "Textures"

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
	| wrapSampler clampSampler bindings borderSampler |
	(defaultSamplersSession == Smalltalk session and: [ defaultSamplers isNotNil ]) ifTrue: [ ^ defaultSamplers ].
	
	"Nearest wrap"
	wrapSampler := AGPUSamplerDescription new
		address_u: AGPU_TEXTURE_ADDRESS_MODE_WRAP;
		address_v: AGPU_TEXTURE_ADDRESS_MODE_WRAP;
		address_w: AGPU_TEXTURE_ADDRESS_MODE_WRAP;
		max_lod: 10000.0;
		maxanisotropy: engine maxAnisotropy;
		yourself.

	clampSampler := AGPUSamplerDescription new
		address_u: AGPU_TEXTURE_ADDRESS_MODE_CLAMP;
		address_v: AGPU_TEXTURE_ADDRESS_MODE_CLAMP;
		address_w: AGPU_TEXTURE_ADDRESS_MODE_CLAMP;
		max_lod: 10000.0;
		maxanisotropy: engine maxAnisotropy;
		yourself.

	borderSampler := AGPUSamplerDescription new
		address_u: AGPU_TEXTURE_ADDRESS_MODE_BORDER;
		address_v: AGPU_TEXTURE_ADDRESS_MODE_BORDER;
		address_w: AGPU_TEXTURE_ADDRESS_MODE_BORDER;
		max_lod: 10000.0;
		maxanisotropy: engine maxAnisotropy;
		yourself.
		
	wrapSampler filter: AGPU_FILTER_MIN_NEAREST_MAG_NEAREST_MIPMAP_NEAREST.
	clampSampler filter: AGPU_FILTER_MIN_NEAREST_MAG_NEAREST_MIPMAP_NEAREST.
	borderSampler filter: AGPU_FILTER_MIN_NEAREST_MAG_NEAREST_MIPMAP_NEAREST.
		
	bindings := self newSamplers.
	bindings
		createSampler: 0 description: wrapSampler;
		createSampler: 1 description: clampSampler;
		createSampler: 2 description: borderSampler.
		
	wrapSampler filter: AGPU_FILTER_MIN_LINEAR_MAG_LINEAR_MIPMAP_NEAREST.
	clampSampler filter: AGPU_FILTER_MIN_LINEAR_MAG_LINEAR_MIPMAP_NEAREST.
	borderSampler filter: AGPU_FILTER_MIN_LINEAR_MAG_LINEAR_MIPMAP_NEAREST.
		
	bindings
		createSampler: 3 description: wrapSampler;
		createSampler: 4 description: clampSampler;
		createSampler: 5 description: borderSampler.

	defaultSamplersSession := Smalltalk session.
	^ defaultSamplers := bindings
]

{ #category : #'generated shader signature methods' }
WDCGenericComputationShaderSignature >> newSampledTextures [
	^ engine createShaderSignature: self resourceBinding: 2 elements: 4
]

{ #category : #'generated shader signature methods' }
WDCGenericComputationShaderSignature >> newSamplers [
	^ engine createShaderSignature: self resourceBinding: 0 elements: 6
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
WDCGenericComputationShaderSignature >> newUniformBuffers [
	^ engine createShaderSignature: self resourceBinding: 1 elements: 4
]
