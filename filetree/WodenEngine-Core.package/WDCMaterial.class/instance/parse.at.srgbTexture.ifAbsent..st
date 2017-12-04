parsing
parse: data at: fileReference srgbTexture: name ifAbsent: aBlock
	^ data at: name
		ifPresent: [ :textureName | engine resourceCache loadSRGBTexture: textureName ]
		ifAbsent: aBlock .
	