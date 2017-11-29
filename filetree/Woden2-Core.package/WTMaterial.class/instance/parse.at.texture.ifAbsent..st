parsing
parse: data at: fileReference texture: name ifAbsent: aBlock
	^ data at: name
		ifPresent: [ :textureName | engine resourceCache loadTexture: textureName ]
		ifAbsent: aBlock .
	