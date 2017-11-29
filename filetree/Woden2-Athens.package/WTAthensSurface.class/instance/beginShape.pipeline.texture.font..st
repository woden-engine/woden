public
beginShape: newShapeType pipeline: newPipelineState texture: newTexture font: newFont
	(currentShapeType ~= newShapeType or: [
		currentPipelineState ~= newPipelineState or: [
				currentTexture ~= newTexture or: [
					currentFont ~= newFont ] ] ]) ifTrue: [ 
		self endSubmesh.
	].

	newPipelineState ~= currentPipelineState ifTrue: [ 
		self deferDrawCommand: [ commandList usePipelineState: newPipelineState handle ].
		currentPipelineState := newPipelineState.
	].

	(newTexture ~= currentTexture and: [newTexture isNotNil ]) ifTrue: [
		self deferDrawCommand: [ commandList useShaderResources: newTexture validHandle ].
		currentTexture := newTexture.
	].

	(newFont ~= currentFont and: [newFont isNotNil ]) ifTrue: [
		self deferDrawCommand: [ commandList useShaderResources: newFont validHandle ].
		currentFont := newFont.
	].
 
	currentShapeType := newShapeType.