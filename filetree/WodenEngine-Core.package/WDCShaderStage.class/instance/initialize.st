initialization
initialize
	super initialize.
	dependantPipelinesMutex := Semaphore forMutualExclusion.
	dependantPipelines := IdentitySet new.
	