device
createFrameBuffer_device: device width: width height: height renderTargetCount: renderTargetCount hasDepth: hasDepth hasStencil: hasStencil
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_framebuffer* agpuCreateFrameBuffer (agpu_device* device , agpu_uint width , agpu_uint height , agpu_uint renderTargetCount , agpu_bool hasDepth , agpu_bool hasStencil) )
