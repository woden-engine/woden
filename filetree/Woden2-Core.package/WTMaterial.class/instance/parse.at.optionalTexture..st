parsing
parse: data at: fileReference optionalTexture: name
	^ self parse: data at: fileReference texture: name ifAbsent: nil