factory
createDrawingProcess
	^ [ 
	[ 
	(Delay forMilliseconds: 1000 / self maxFPS) wait.
	self frame ] repeat ] fork "forkAt: Processor lowIOPriority"