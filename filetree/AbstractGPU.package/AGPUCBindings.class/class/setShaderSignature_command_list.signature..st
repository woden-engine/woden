command_list
setShaderSignature_command_list: command_list signature: signature
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuSetShaderSignature (agpu_command_list* command_list , agpu_shader_signature* signature) )
