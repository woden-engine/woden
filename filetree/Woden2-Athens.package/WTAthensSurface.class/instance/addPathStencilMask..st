as yet unclassified
addPathStencilMask: aPath
	self
		beginWithNewBaseVertex;
		beginShape: AGPU_TRIANGLES pipeline: stencilNonZeroPipeline. 
	pathTessellator reset.
	aPath sendCommandsTo: pathTessellator.