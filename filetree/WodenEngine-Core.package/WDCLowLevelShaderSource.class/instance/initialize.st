initialization
initialize
	super initialize.
	stagesMutex := Semaphore forMutualExclusion.
	stages := IdentitySet new.