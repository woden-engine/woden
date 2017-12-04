resource building
uploadTexture2DData
	data isForm ifTrue: [ ^ self uploadTexture2DFormData ].
	self uploadWodenTextureData
