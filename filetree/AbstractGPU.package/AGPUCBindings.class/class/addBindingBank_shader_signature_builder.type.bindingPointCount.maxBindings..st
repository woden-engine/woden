shader_signature_builder
addBindingBank_shader_signature_builder: shader_signature_builder type: type bindingPointCount: bindingPointCount maxBindings: maxBindings
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuAddShaderSignatureBindingBank (agpu_shader_signature_builder* shader_signature_builder , agpu_shader_binding_type type , agpu_uint bindingPointCount , agpu_uint maxBindings) )
