parsing
parse: materialFileReference data: data
	materialState
		albedo: (self parse: data at: materialFileReference srgbColor: 'color' ifAbsent: [ Color black ]);
		fresnel: (self parse: data at: materialFileReference vector3: 'fresnel-constant' ifAbsent: [ WMVector3F x: 0.03 y: 0.03 z: 0.03 ]).
	normalTexture := self parse: data at: materialFileReference optionalTexture: 'normal-texture'.
	self invalidateCache.