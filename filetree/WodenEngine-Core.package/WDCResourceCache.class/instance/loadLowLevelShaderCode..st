shaders
loadLowLevelShaderCode: aFileNameOrReference
	| shaderFile |
	shaderFile := self resolveResourceFileReference: aFileNameOrReference.
	^ self resourceAt: shaderFile -> #lowLevelShader ifAbsentPut: [ self performLowLevelShaderLoading: shaderFile ].