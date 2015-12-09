shader_signature_builder
addBindingElement_shader_signature_builder: shader_signature_builder type: type maxBindings: maxBindings
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuAddShaderSignatureBindingElement (agpu_shader_signature_builder* shader_signature_builder , agpu_shader_binding_type type , agpu_uint maxBindings) )
