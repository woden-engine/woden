global c functions
getPlatforms_numplatforms: numplatforms platforms: platforms ret_numplatforms: ret_numplatforms
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuGetPlatforms (agpu_size numplatforms , agpu_platform** platforms , agpu_size* ret_numplatforms) )
