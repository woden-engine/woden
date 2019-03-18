Class {
	#name : #WDCAmbientOcclusionShaderSignature,
	#superclass : #WDCShaderSignature,
	#instVars : [
		'defaultSamplers',
		'defaultSamplersSession'
	],
	#category : #'WodenEngine-Core-Shaders'
}

{ #category : #'as yet unclassified' }
WDCAmbientOcclusionShaderSignature class >> signatureSpec: spec [
	"
	self rebuildShaderSignatureMethods
	"
	spec
		name: #GenericComputation;
		bank: #Samplers with: [ :bank |
			bank
				maxBindings: 10;
				sampler: #Samplers count: 2
		];
		bank: #CameraState with: [ :bank |
			bank
				maxBindings: 1000;
				uniform: #ObjectState count: 1
		];
		bank: #ComputeSources with: [ :bank |
			bank
				maxBindings: 1000;
				texture: #DepthBuffer count: 1;
				texture: #NormalBuffer count: 1
		];
		yourself
]

{ #category : #'as yet unclassified' }
WDCAmbientOcclusionShaderSignature >> activeOnStateTracker: stateTracker [
	super activeOnStateTracker: stateTracker.
	stateTracker useShaderResources: self defaultSamplers.
]

{ #category : #'generated shader signature methods' }
WDCAmbientOcclusionShaderSignature >> createHandleForDevice: device [
	^ device createShaderSignatureBuilder

		"Samplers"
		beginBindingBank: 10;
			addBindingBankElement: AGPU_SHADER_BINDING_TYPE_SAMPLER bindingPointCount: 2; "Samplers"

		"CameraState"
		beginBindingBank: 1000;
			addBindingBankElement: AGPU_SHADER_BINDING_TYPE_UNIFORM_BUFFER bindingPointCount: 1; "ObjectState"

		"ComputeSources"
		beginBindingBank: 1000;
			addBindingBankElement: AGPU_SHADER_BINDING_TYPE_SAMPLED_IMAGE bindingPointCount: 1; "DepthBuffer"
			addBindingBankElement: AGPU_SHADER_BINDING_TYPE_SAMPLED_IMAGE bindingPointCount: 1; "NormalBuffer"

		build

]

{ #category : #accessing }
WDCAmbientOcclusionShaderSignature >> defaultSamplers [
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

	"Normal sample. Use nearest to preserve sharp corners."
	samplerDesc := AGPUSamplerDescription new
		filter: AGPU_FILTER_MIN_LINEAR_MAG_LINEAR_MIPMAP_NEAREST;
		address_u: AGPU_TEXTURE_ADDRESS_MODE_CLAMP;
		address_v: AGPU_TEXTURE_ADDRESS_MODE_CLAMP;
		address_w: AGPU_TEXTURE_ADDRESS_MODE_CLAMP;
		max_lod: 10000.0;
		maxanisotropy: 1;
		yourself.
	bindings
		createSampler: 1 description: samplerDesc.
		
	defaultSamplersSession := Smalltalk session.
	^ defaultSamplers := bindings
]

{ #category : #'generated shader signature methods' }
WDCAmbientOcclusionShaderSignature >> newCameraState [
	^ engine createShaderSignature: self resourceBinding: 1 elements: 1
]

{ #category : #'generated shader signature methods' }
WDCAmbientOcclusionShaderSignature >> newComputeSources [
	^ engine createShaderSignature: self resourceBinding: 2 elements: 2
]

{ #category : #'generated shader signature methods' }
WDCAmbientOcclusionShaderSignature >> newSamplers [
	^ engine createShaderSignature: self resourceBinding: 0 elements: 2
]
