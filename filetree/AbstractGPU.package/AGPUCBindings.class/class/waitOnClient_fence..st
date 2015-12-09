fence
waitOnClient_fence: fence
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuWaitOnClient (agpu_fence* fence) )
