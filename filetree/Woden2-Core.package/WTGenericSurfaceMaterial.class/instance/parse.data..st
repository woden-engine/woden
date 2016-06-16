parsing
parse: materialFileReference data: data
	albedoColor := self parse: data at: materialFileReference srgbColor: 'albedo-color' ifAbsent: [ Color white ].
	albedoTexture := self parse: data at: materialFileReference optionalTexture: 'albedo-texture'.
	normalTexture := self parse: data at: materialFileReference optionalTexture: 'normal-texture'.
	metalTexture := self parse: data at: materialFileReference optionalTexture: 'metal-texture'.
	self invalidateCache.