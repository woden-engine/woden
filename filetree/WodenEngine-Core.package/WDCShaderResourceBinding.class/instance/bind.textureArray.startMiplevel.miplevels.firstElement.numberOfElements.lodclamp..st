binding
bind: slot textureArray: texture startMiplevel: startMipLevel miplevels: mipLevels firstElement: firstElement numberOfElements: numberOfElements lodclamp: lodClamp
	self slotAt: slot + 1 put: texture action: [
		self validHandle bindTextureArrayRange: slot texture: texture validHandle startMiplevel: startMipLevel miplevels: mipLevels firstElement: firstElement numberOfElements: numberOfElements lodclamp: lodClamp
	].