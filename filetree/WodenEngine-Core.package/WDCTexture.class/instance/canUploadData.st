resource building
canUploadData
	^ data isNotNil and: [ description flags anyMask: AGPU_TEXTURE_FLAG_UPLOADED ]