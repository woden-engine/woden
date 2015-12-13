abstract gpu baking
buildPipelineStateObjects
	"Clear the handles"
	pipelineStateObjects valuesDo: [ :pso | pso handle: nil ].
	
	"Build the pso"
	pipelineStateObjects valuesDo: [ :pso | self buildPipelineStateObject: pso ]