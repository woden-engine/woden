as yet unclassified
withPipelineState: pipelineState isCached: isCached rebuild: aBlock
	isCached ifFalse: [ self withPipelineState: pipelineState rebuild: aBlock ]