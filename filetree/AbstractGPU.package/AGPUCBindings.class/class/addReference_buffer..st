buffer
addReference_buffer: buffer
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuAddBufferReference (agpu_buffer* buffer) )
