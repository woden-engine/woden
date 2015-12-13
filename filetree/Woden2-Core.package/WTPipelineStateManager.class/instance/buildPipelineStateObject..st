abstract gpu baking
buildPipelineStateObject: pipelineStateObject
	| device builder |
	pipelineStateObject isAbstract ifTrue: [ ^ self ].
	
	device := engine device.
	builder := device createPipelineBuilder.

	self setPipelineBuilder: builder attributes: pipelineStateObject description scope: pipelineStateObject scope.
	
	"Build the PSO"
	pipelineStateObject handle: builder build.
	builder release.
	