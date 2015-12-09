as yet unclassified
initializeForNewSession
	super initializeForNewSession.
	
	commandQueue := device getDefaultCommandQueue.
	commandAllocator := device createCommandAllocator.
	commandList := device createCommandList: commandAllocator initial_pipeline_state: nil.
	commandList close.
	