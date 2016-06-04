as yet unclassified
addPathStencilMask: aPath
	self
		beginWithNewBaseVertex;
		beginShape: AGPU_TRIANGLES pipeline: stencilEvenOddPipeline. 
	pathTessellator reset.
	aPath sendCommandsTo: pathTessellator.