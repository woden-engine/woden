parsing
parse: materialFileReference data: data
	skyTexture := self parse: data at: materialFileReference optionalSRGBTexture: 'texture'.
	self invalidateCache.