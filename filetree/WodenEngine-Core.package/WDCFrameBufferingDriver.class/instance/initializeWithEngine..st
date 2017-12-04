initialization
initializeWithEngine: anEngine
	engine := anEngine.
	frameIndex := -1.
	bufferingFrameIndex := 1.
	frameFences := Array new: self frameBufferingCount.
	renderingProcessesLock := Semaphore forMutualExclusion.
	renderingProcessMutex := Mutex new.
	frontRenderingProcesses := OrderedCollection new.
	backRenderingProcesses := OrderedCollection new.
	self createMainRenderingProcess.