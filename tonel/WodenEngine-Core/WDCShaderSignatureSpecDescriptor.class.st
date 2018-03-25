Class {
	#name : #WDCShaderSignatureSpecDescriptor,
	#superclass : #Object,
	#instVars : [
		'index',
		'name',
		'count',
		'type'
	],
	#classVars : [
		'ShaderBindingTypeMap'
	],
	#category : 'WodenEngine-Core-Shaders'
}

{ #category : #initialization }
WDCShaderSignatureSpecDescriptor class >> initialize [
	ShaderBindingTypeMap := Dictionary newFromPairs: {
		#'uniform' . #AGPU_SHADER_BINDING_TYPE_UNIFORM_BUFFER .
		#'storage' . #AGPU_SHADER_BINDING_TYPE_STORAGE_BUFFER .
		#'uniform-texel-buffer' . #AGPU_SHADER_BINDING_TYPE_UNIFORM_TEXEL_BUFFER .
		#'storage-texel-buffer' . #AGPU_SHADER_BINDING_TYPE_STORAGE_TEXEL_BUFFER .
		#'texture' . #AGPU_SHADER_BINDING_TYPE_SAMPLED_IMAGE .
		#'storage-image' . #AGPU_SHADER_BINDING_TYPE_STORAGE_IMAGE .
		#sampler . #AGPU_SHADER_BINDING_TYPE_SAMPLER .
	}.
]

{ #category : #accessing }
WDCShaderSignatureSpecDescriptor >> count [
	^ count
]

{ #category : #accessing }
WDCShaderSignatureSpecDescriptor >> count: anObject [
	count := anObject
]

{ #category : #accessing }
WDCShaderSignatureSpecDescriptor >> index [
	^ index
]

{ #category : #accessing }
WDCShaderSignatureSpecDescriptor >> index: anObject [
	index := anObject
]

{ #category : #accessing }
WDCShaderSignatureSpecDescriptor >> name [
	^ name
]

{ #category : #accessing }
WDCShaderSignatureSpecDescriptor >> name: anObject [
	name := anObject
]

{ #category : #accessing }
WDCShaderSignatureSpecDescriptor >> type [
	^ type
]

{ #category : #accessing }
WDCShaderSignatureSpecDescriptor >> type: anObject [
	type := anObject
]

{ #category : #writing }
WDCShaderSignatureSpecDescriptor >> writeCreateHandleCodeOn: out [
	out tab tab tab << 'addBindingBankElement: ' << (ShaderBindingTypeMap at: type) << ' bindingPointCount: ' << count << '; "' << name << '"'; cr
]
