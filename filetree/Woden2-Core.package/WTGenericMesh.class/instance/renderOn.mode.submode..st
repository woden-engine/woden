rendering
renderOn: listBuilder mode: renderMode submode: submode
	listBuilder
		useVertexBinding: vertexBinding validHandle;
		useIndexBuffer: indexBuffer validHandle.
	submeshes do: [ :sm | sm renderOn: listBuilder mode: renderMode submode: submode ]