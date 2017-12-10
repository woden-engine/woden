accessing
defaultSamplers
	| samplerDesc bindings |
	self flag: 'Add session check.'.
	defaultSamplers ifNotNil: [ ^ defaultSamplers ].
	
	samplerDesc := AGPUSamplerDescription new
		filter: AGPU_FILTER_MIN_LINEAR_MAG_LINEAR_MIPMAP_NEAREST;
		address_u: AGPU_TEXTURE_ADDRESS_MODE_CLAMP;
		address_v: AGPU_TEXTURE_ADDRESS_MODE_CLAMP;
		address_w: AGPU_TEXTURE_ADDRESS_MODE_CLAMP;
		max_lod: 10000.0;
		yourself.
		
	bindings := self shaderSignature newSamplers.
	bindings
		createSampler: 0 description: samplerDesc.
		
	^ defaultSamplers := bindings