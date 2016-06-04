paths
createPath: aPathCreatingBlock
	^ WTAthensPath new firstSegment: (AthensSimplePathBuilder createPath:  aPathCreatingBlock )