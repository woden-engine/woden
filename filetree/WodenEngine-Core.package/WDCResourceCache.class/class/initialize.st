initialization
initialize
	ShaderLanguageTargetMap := Dictionary newFromPairs: {
		AGPU_SHADER_LANGUAGE_GLSL . #glsl.
		AGPU_SHADER_LANGUAGE_EGLSL . #eglsl.
		AGPU_SHADER_LANGUAGE_HLSL . #hlsl.
		AGPU_SHADER_LANGUAGE_SPIR_V . #'spir-v'.
    	AGPU_SHADER_LANGUAGE_METAL . #metal.
	}.
	