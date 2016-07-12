parsing
parse: materialFileReference data: data
	materialState
		albedo: (self parse: data at: materialFileReference srgbColor: 'albedo-color' ifAbsent: [ Color white ]);
		fresnel: (self parse: data at: materialFileReference vector3: 'fresnel-constant' ifAbsent: [ WMVector3F x: 0.03 y: 0.03 z: 0.03 ]);
		smoothness: (data at: 'smoothness' ifAbsent: [ materialState smoothness ]).
	albedoTexture := self parse: data at: materialFileReference optionalSRGBTexture: 'albedo-texture'.
	normalTexture := self parse: data at: materialFileReference optionalTexture: 'normal-texture'.
	fresnelTexture := self parse: data at: materialFileReference optionalSRGBTexture: 'fresnel-texture'.
	isSkinned := data at: 'skinned' ifAbsent: [ false ].
	self invalidateCache.