accessing
colorAttachmentFormats
	^ colorAttachmentFormats ifNil: [ colorAttachmentFormats := { AGPU_TEXTURE_FORMAT_B8G8R8A8_UNORM_SRGB } ]