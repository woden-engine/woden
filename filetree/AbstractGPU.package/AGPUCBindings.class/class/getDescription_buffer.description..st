buffer
getDescription_buffer: buffer description: description
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuGetBufferDescription (agpu_buffer* buffer , agpu_buffer_description* description) )
