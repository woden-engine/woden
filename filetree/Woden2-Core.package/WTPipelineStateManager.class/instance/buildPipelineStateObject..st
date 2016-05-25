abstract gpu baking
buildPipelineStateObject: pipelineStateObject
	| device builder |
	pipelineStateObject isAbstract ifTrue: [ ^ self ].
	
	device := engine device.
	builder := device createPipelineBuilder.

	self setPipelineBuilder: builder attributes: pipelineStateObject description scope: pipelineStateObject scope.
	
	"Build the PSO"
	FileStream stdout nextPutAll: pipelineStateObject name; lf.
	pipelineStateObject handle: builder build.
	builder release.
	