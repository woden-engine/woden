class initialization
initialize
	"
	self initialize
	"
	super initialize.
	
	ShaderBindingTypeMap := IdentityDictionary newFromPairs: {
		#cbv . AGPU_SHADER_BINDING_TYPE_CBV .
		#srv . AGPU_SHADER_BINDING_TYPE_SRV .
		#uav . AGPU_SHADER_BINDING_TYPE_UAV .
		#sampler . AGPU_SHADER_BINDING_TYPE_SAMPLER .
	}.
	