initialization
initialize
	ShaderBindingTypeMap := Dictionary newFromPairs: {
		#'uniform' . #AGPU_SHADER_BINDING_TYPE_UNIFORM_BUFFER .
		#'storage' . #AGPU_SHADER_BINDING_TYPE_STORAGE_BUFFER .
		#'uniform-texel-buffer' . #AGPU_SHADER_BINDING_TYPE_UNIFORM_TEXEL_BUFFER .
		#'storage-texel-buffer' . #AGPU_SHADER_BINDING_TYPE_STORAGE_TEXEL_BUFFER .
		#'texture' . #AGPU_SHADER_BINDING_TYPE_SAMPLED_IMAGE .
		#'storage-image' . #AGPU_SHADER_BINDING_TYPE_STORAGE_IMAGE .
		#sampler . #AGPU_SHADER_BINDING_TYPE_SAMPLER .
	}.