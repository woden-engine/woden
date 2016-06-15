factory
createDrawingProcess
	^ [ 
	[ 
	self drawingProcessCycle ] repeat ] forkAt: Processor lowIOPriority