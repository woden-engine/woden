resource building
buildHandle
	self assert: description isNotNil.
	handle := engine device createTexture: description.
	self canUploadData ifTrue: [ 
		self uploadTextureData.
	].
