viewport composition
samplerBindings
	| samplerDesc |
	samplerBindings ifNotNil: [ ^ samplerBindings ].
	
		samplerDesc := AGPUSamplerDescription new
		filter: AGPU_FILTER_MIN_LINEAR_MAG_LINEAR_MIPMAP_NEAREST;
		address_u: AGPU_TEXTURE_ADDRESS_MODE_CLAMP;
		address_v: AGPU_TEXTURE_ADDRESS_MODE_CLAMP;
		address_w: AGPU_TEXTURE_ADDRESS_MODE_CLAMP;
		max_lod: 10000.0;
		yourself.
		
	samplerBindings := self shaderSignature newSampler.
	samplerBindings
		createSampler: 0 description: samplerDesc.
		
	^ samplerBindings