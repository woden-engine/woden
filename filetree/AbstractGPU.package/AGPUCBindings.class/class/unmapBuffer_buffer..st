buffer
unmapBuffer_buffer: buffer
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuUnmapBuffer (agpu_buffer* buffer) )
