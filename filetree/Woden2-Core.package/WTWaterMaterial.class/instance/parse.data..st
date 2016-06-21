parsing
parse: materialFileReference data: data
	materialState
		albedo: (self parse: data at: materialFileReference srgbColor: 'color' ifAbsent: [ Color white ]).
	normalTexture := self parse: data at: materialFileReference optionalTexture: 'normal-texture'.
	self invalidateCache.