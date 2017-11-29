parsing
parse: data at: fileReference optionalSRGBTexture: name
	^ self parse: data at: fileReference srgbTexture: name ifAbsent: nil