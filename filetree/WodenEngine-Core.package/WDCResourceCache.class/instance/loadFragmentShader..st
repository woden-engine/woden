shaders
loadFragmentShader: aFileNameOrReference
	| shaderFile |
	shaderFile := self resolveResourceFileReference: aFileNameOrReference.
	^ self resourceAt: shaderFile -> #fragmentShader ifAbsentPut: [ self performShaderLoading: shaderFile stage: AGPU_FRAGMENT_SHADER ].