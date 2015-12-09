fence
release_fence: fence
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuReleaseFenceReference (agpu_fence* fence) )
