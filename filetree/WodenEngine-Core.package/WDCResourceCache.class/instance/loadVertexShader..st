shaders
loadVertexShader: aFileNameOrReference
	| shaderFile |
	shaderFile := self resolveResourceFileReference: aFileNameOrReference.
	^ self resourceAt: shaderFile -> #vertexShader ifAbsentPut: [ self performShaderLoading: shaderFile stage: AGPU_VERTEX_SHADER ].