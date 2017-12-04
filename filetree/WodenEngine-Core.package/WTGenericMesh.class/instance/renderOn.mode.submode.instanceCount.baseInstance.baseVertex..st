rendering
renderOn: listBuilder mode: renderMode submode: submode instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex 
	listBuilder
		useVertexBinding: vertexBinding validHandle;
		useIndexBuffer: indexBuffer validHandle.
	submeshes do: [ :sm | sm renderOn: listBuilder mode: renderMode submode: submode instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex ]