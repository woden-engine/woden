binding
bind: slot texture: texture startMiplevel: startMipLevel miplevels: mipLevels lodclamp: lodClamp
	self slotAt: slot + 1 put: texture action: [
		self validHandle bindTexture: slot texture: texture validHandle startMiplevel: startMipLevel miplevels: mipLevels lodclamp: lodClamp
	].