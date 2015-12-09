command_list
useShaderResources_command_list: command_list binding: binding
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuUseShaderResources (agpu_command_list* command_list , agpu_shader_resource_binding* binding) )
