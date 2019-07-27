Class {
	#name : #WDCCompositionShaderSignature,
	#superclass : #WDCShaderSignature,
	#instVars : [
		'defaultSamplers',
		'defaultSamplersSession'
	],
	#category : #'WodenEngine-Core-Shaders'
}

{ #category : #'as yet unclassified' }
WDCCompositionShaderSignature class >> signatureSpec: spec [
	"
	self rebuildShaderSignatureMethods
	"
	spec
		name: #Composition;
		bank: #Samplers with: [ :bank |
			bank
				maxBindings: 10;
				sampler: #Sampler;
				sampler: #CubeSampler
		];
		bank: #Sources with: [ :bank |
			bank
				maxBindings: 1000;
				texture: #Textures count: 5;
				storage: #Data
		];
		bank: #Parameters with: [ :bank |
			bank
				maxBindings: 1000;
				uniform: #Parameters
		];
		pushConstant: #QuickArguments size: 128;
		yourself
]

{ #category : #'as yet unclassified' }
WDCCompositionShaderSignature >> activeOnStateTracker: stateTracker [
	super activeOnStateTracker: stateTracker.
	stateTracker useShaderResources: self defaultSamplers.
]

{ #category : #'generated shader signature methods' }
WDCCompositionShaderSignature >> constantQuickArgumentsOffset [
	^ 0
]

{ #category : #'generated shader signature methods' }
WDCCompositionShaderSignature >> constantQuickArgumentsSize [
	^ 128
]

{ #category : #'generated shader signature methods' }
WDCCompositionShaderSignature >> createHandleForDevice: device [
	^ device createShaderSignatureBuilder

		"Samplers"
		beginBindingBank: 10;
			addBindingBankElement: AGPU_SHADER_BINDING_TYPE_SAMPLER bindingPointCount: 1; "Sampler"
			addBindingBankElement: AGPU_SHADER_BINDING_TYPE_SAMPLER bindingPointCount: 1; "CubeSampler"

		"Sources"
		beginBindingBank: 1000;
			addBindingBankElement: AGPU_SHADER_BINDING_TYPE_SAMPLED_IMAGE bindingPointCount: 5; "Textures"
			addBindingBankElement: AGPU_SHADER_BINDING_TYPE_STORAGE_BUFFER bindingPointCount: 1; "Data"

		"Parameters"
		beginBindingBank: 1000;
			addBindingBankElement: AGPU_SHADER_BINDING_TYPE_UNIFORM_BUFFER bindingPointCount: 1; "Parameters"

		addBindingConstant; "QuickArguments"
		addBindingConstant; "QuickArguments"
		addBindingConstant; "QuickArguments"
		addBindingConstant; "QuickArguments"
		addBindingConstant; "QuickArguments"
		addBindingConstant; "QuickArguments"
		addBindingConstant; "QuickArguments"
		addBindingConstant; "QuickArguments"
		addBindingConstant; "QuickArguments"
		addBindingConstant; "QuickArguments"
		addBindingConstant; "QuickArguments"
		addBindingConstant; "QuickArguments"
		addBindingConstant; "QuickArguments"
		addBindingConstant; "QuickArguments"
		addBindingConstant; "QuickArguments"
		addBindingConstant; "QuickArguments"
		addBindingConstant; "QuickArguments"
		addBindingConstant; "QuickArguments"
		addBindingConstant; "QuickArguments"
		addBindingConstant; "QuickArguments"
		addBindingConstant; "QuickArguments"
		addBindingConstant; "QuickArguments"
		addBindingConstant; "QuickArguments"
		addBindingConstant; "QuickArguments"
		addBindingConstant; "QuickArguments"
		addBindingConstant; "QuickArguments"
		addBindingConstant; "QuickArguments"
		addBindingConstant; "QuickArguments"
		addBindingConstant; "QuickArguments"
		addBindingConstant; "QuickArguments"
		addBindingConstant; "QuickArguments"
		addBindingConstant; "QuickArguments"
		build

]

{ #category : #accessing }
WDCCompositionShaderSignature >> defaultSamplers [
	| samplerDesc bindings |
	(defaultSamplersSession == Smalltalk session and: [ defaultSamplers isNotNil ]) ifTrue: [ ^ defaultSamplers ].
	
	samplerDesc := AGPUSamplerDescription new
		filter: AGPU_FILTER_MIN_LINEAR_MAG_LINEAR_MIPMAP_NEAREST;
		address_u: AGPU_TEXTURE_ADDRESS_MODE_CLAMP;
		address_v: AGPU_TEXTURE_ADDRESS_MODE_CLAMP;
		address_w: AGPU_TEXTURE_ADDRESS_MODE_CLAMP;
		max_lod: 10000.0;
		maxanisotropy: engine maxAnisotropy;
		yourself.
		
	bindings := self newSamplers.
	bindings
		createSampler: 0 description: samplerDesc.

	samplerDesc := AGPUSamplerDescription new
		filter: AGPU_FILTER_MIN_LINEAR_MAG_LINEAR_MIPMAP_NEAREST;
		address_u: AGPU_TEXTURE_ADDRESS_MODE_BORDER;
		address_v: AGPU_TEXTURE_ADDRESS_MODE_BORDER;
		address_w: AGPU_TEXTURE_ADDRESS_MODE_BORDER;
		max_lod: 10000.0;
		maxanisotropy: engine maxAnisotropy;
		yourself.
	bindings
		createSampler: 1 description: samplerDesc.

	defaultSamplersSession := Smalltalk session.
	^ defaultSamplers := bindings
]

{ #category : #'generated shader signature methods' }
WDCCompositionShaderSignature >> newParameters [
	^ engine createShaderSignature: self resourceBinding: 2 elements: 1
]

{ #category : #'generated shader signature methods' }
WDCCompositionShaderSignature >> newSamplers [
	^ engine createShaderSignature: self resourceBinding: 0 elements: 2
]

{ #category : #'generated shader signature methods' }
WDCCompositionShaderSignature >> newSources [
	^ engine createShaderSignature: self resourceBinding: 1 elements: 6
]
