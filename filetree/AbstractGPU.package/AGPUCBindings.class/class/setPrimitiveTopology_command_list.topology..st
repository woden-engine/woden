command_list
setPrimitiveTopology_command_list: command_list topology: topology
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuSetPrimitiveTopology (agpu_command_list* command_list , agpu_primitive_topology topology) )
