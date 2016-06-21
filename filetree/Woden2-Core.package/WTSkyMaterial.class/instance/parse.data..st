parsing
parse: materialFileReference data: data
	skyTexture := self parse: data at: materialFileReference optionalTexture: 'texture'.
	self invalidateCache.