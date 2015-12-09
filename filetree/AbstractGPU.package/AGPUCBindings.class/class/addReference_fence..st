fence
addReference_fence: fence
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuAddFenceReference (agpu_fence* fence) )
