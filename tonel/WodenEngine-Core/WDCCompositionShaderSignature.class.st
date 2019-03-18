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
				sampler: #Sampler
		];
		bank: #Sources with: [ :bank |
			bank
				maxBindings: 1000;
				texture: #Textures count: 5
		];
		bank: #Parameters with: [ :bank |
			bank
				maxBindings: 1000;
				uniform: #Parameters
		];
		yourself
]

{ #category : #'as yet unclassified' }
WDCCompositionShaderSignature >> activeOnStateTracker: stateTracker [
	super activeOnStateTracker: stateTracker.
	stateTracker useShaderResources: self defaultSamplers.
]

{ #category : #'generated shader signature methods' }
WDCCompositionShaderSignature >> createHandleForDevice: device [
	^ device createShaderSignatureBuilder

		"Samplers"
		beginBindingBank: 10;
			addBindingBankElement: AGPU_SHADER_BINDING_TYPE_SAMPLER bindingPointCount: 1; "Sampler"

		"Sources"
		beginBindingBank: 1000;
			addBindingBankElement: AGPU_SHADER_BINDING_TYPE_SAMPLED_IMAGE bindingPointCount: 5; "Textures"

		"Parameters"
		beginBindingBank: 1000;
			addBindingBankElement: AGPU_SHADER_BINDING_TYPE_UNIFORM_BUFFER bindingPointCount: 1; "Parameters"

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
		maxanisotropy: 1;
		yourself.
		
	bindings := self newSamplers.
	bindings
		createSampler: 0 description: samplerDesc.

	defaultSamplersSession := Smalltalk session.
	^ defaultSamplers := bindings
]

{ #category : #'generated shader signature methods' }
WDCCompositionShaderSignature >> newParameters [
	^ engine createShaderSignature: self resourceBinding: 2 elements: 1
]

{ #category : #'generated shader signature methods' }
WDCCompositionShaderSignature >> newSamplers [
	^ engine createShaderSignature: self resourceBinding: 0 elements: 1
]

{ #category : #'generated shader signature methods' }
WDCCompositionShaderSignature >> newSources [
	^ engine createShaderSignature: self resourceBinding: 1 elements: 5
]
