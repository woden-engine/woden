rendering
renderOn: stateTracker instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex 
	stateTracker
		useVertexBinding: vertexBinding;
		useIndexBuffer: indexBuffer.
	submeshes do: [ :sm | sm renderOn: stateTracker instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex ]