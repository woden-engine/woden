parsing
parse: materialFileReference data: data
	materialState
		albedo: (self parse: data at: materialFileReference srgbColor: 'albedo-color' ifAbsent: [ Color white ]);
		smoothness: (data at: 'smoothness' ifAbsent: [ materialState smoothness ]).
	albedoTexture := self parse: data at: materialFileReference optionalSRGBTexture: 'albedo-texture'.
	normalTexture := self parse: data at: materialFileReference optionalTexture: 'normal-texture'.
	fresnelTexture := self parse: data at: materialFileReference optionalSRGBTexture: 'fresnel-texture'.
	self invalidateCache.