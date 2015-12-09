buffer
mapBuffer_buffer: buffer flags: flags
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_pointer agpuMapBuffer (agpu_buffer* buffer , agpu_mapping_access flags) )
