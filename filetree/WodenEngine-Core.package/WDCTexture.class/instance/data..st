accessing
data: anObject
	data := anObject.
	(self hasValidHandle and: [ self canUploadData ]) ifTrue: [ self uploadTextureData ]