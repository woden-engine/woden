command_list
multiDrawElementsIndirect_command_list: command_list offset: offset drawcount: drawcount
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuMultiDrawElementsIndirect (agpu_command_list* command_list , agpu_size offset , agpu_size drawcount) )
