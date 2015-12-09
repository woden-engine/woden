command_list
useVertexBinding_command_list: command_list vertex_binding: vertex_binding
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuUseVertexBinding (agpu_command_list* command_list , agpu_vertex_binding* vertex_binding) )
