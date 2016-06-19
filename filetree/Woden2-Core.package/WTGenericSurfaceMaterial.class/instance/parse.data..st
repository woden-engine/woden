parsing
parse: materialFileReference data: data
	materialState
		albedo: (self parse: data at: materialFileReference srgbColor: 'albedo-color' ifAbsent: [ Color white ]).
	albedoTexture := self parse: data at: materialFileReference optionalTexture: 'albedo-texture'.
	normalTexture := self parse: data at: materialFileReference optionalTexture: 'normal-texture'.
	fresnelTexture := self parse: data at: materialFileReference optionalTexture: 'fresnel-texture'.
	self invalidateCache.