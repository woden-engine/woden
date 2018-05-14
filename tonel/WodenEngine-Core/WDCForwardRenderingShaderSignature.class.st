Class {
	#name : #WDCForwardRenderingShaderSignature,
	#superclass : #WDCShaderSignature,
	#instVars : [
		'defaultSamplers',
		'defaultSamplersSession'
	],
	#category : #'WodenEngine-Core-Shaders'
}

{ #category : #'as yet unclassified' }
WDCForwardRenderingShaderSignature class >> signatureSpec: spec [
	"
	self rebuildShaderSignatureMethods
	"
	spec
		name: #ForwardRenderer;
		bank: #ObjectState with: [ :bank |
			bank
				maxBindings: 100000;
				uniform: #ObjectState;
				storage: #InstanceObjectState;
				storage: #ExtraObjectState
		];
		bank: #CameraState with: [ :bank |
			bank
				maxBindings: 1000;
				uniform: #ObjectState
		];
		bank: #MaterialState with: [ :bank |
			bank
				maxBindings: 10000;
				uniform: #Attributes;
				storage: #BigAttributes;
				texture: #Textures count: 5
		];
		bank: #Samplers with: [ :bank |
			bank
				maxBindings: 10;
				sampler: #Samplers count: 5
		];
		bank: #LightingState with: [ :bank |
			bank
				maxBindings: 1000;
				uniform: #GlobalLightingState;
				texture: #ShadowMaps count: 2
		];
		yourself
]

{ #category : #'generated shader signature methods' }
WDCForwardRenderingShaderSignature >> createHandleForDevice: device [
	^ device createShaderSignatureBuilder

		"ObjectState"
		beginBindingBank: 100000;
			addBindingBankElement: AGPU_SHADER_BINDING_TYPE_UNIFORM_BUFFER bindingPointCount: 1; "ObjectState"
			addBindingBankElement: AGPU_SHADER_BINDING_TYPE_STORAGE_BUFFER bindingPointCount: 1; "InstanceObjectState"
			addBindingBankElement: AGPU_SHADER_BINDING_TYPE_STORAGE_BUFFER bindingPointCount: 1; "ExtraObjectState"

		"CameraState"
		beginBindingBank: 1000;
			addBindingBankElement: AGPU_SHADER_BINDING_TYPE_UNIFORM_BUFFER bindingPointCount: 1; "ObjectState"

		"MaterialState"
		beginBindingBank: 10000;
			addBindingBankElement: AGPU_SHADER_BINDING_TYPE_UNIFORM_BUFFER bindingPointCount: 1; "Attributes"
			addBindingBankElement: AGPU_SHADER_BINDING_TYPE_STORAGE_BUFFER bindingPointCount: 1; "BigAttributes"
			addBindingBankElement: AGPU_SHADER_BINDING_TYPE_SAMPLED_IMAGE bindingPointCount: 5; "Textures"

		"Samplers"
		beginBindingBank: 10;
			addBindingBankElement: AGPU_SHADER_BINDING_TYPE_SAMPLER bindingPointCount: 5; "Samplers"

		"LightingState"
		beginBindingBank: 1000;
			addBindingBankElement: AGPU_SHADER_BINDING_TYPE_UNIFORM_BUFFER bindingPointCount: 1; "GlobalLightingState"
			addBindingBankElement: AGPU_SHADER_BINDING_TYPE_SAMPLED_IMAGE bindingPointCount: 2; "ShadowMaps"

		build

]

{ #category : #accessing }
WDCForwardRenderingShaderSignature >> defaultSamplers [
	| samplerDesc bindings |
	(defaultSamplersSession == Smalltalk session and: [ defaultSamplers isNotNil ]) ifTrue: [ ^ defaultSamplers ].
	
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

	defaultSamplersSession := Smalltalk session.
	^ defaultSamplers := bindings
]

{ #category : #'generated shader signature methods' }
WDCForwardRenderingShaderSignature >> newCameraState [
	^ engine createShaderSignature: self resourceBinding: 1 elements: 1
]

{ #category : #'generated shader signature methods' }
WDCForwardRenderingShaderSignature >> newLightingState [
	^ engine createShaderSignature: self resourceBinding: 4 elements: 3
]

{ #category : #'generated shader signature methods' }
WDCForwardRenderingShaderSignature >> newMaterialState [
	^ engine createShaderSignature: self resourceBinding: 2 elements: 7
]

{ #category : #'generated shader signature methods' }
WDCForwardRenderingShaderSignature >> newObjectState [
	^ engine createShaderSignature: self resourceBinding: 0 elements: 3
]

{ #category : #'generated shader signature methods' }
WDCForwardRenderingShaderSignature >> newSamplers [
	^ engine createShaderSignature: self resourceBinding: 3 elements: 5
]
