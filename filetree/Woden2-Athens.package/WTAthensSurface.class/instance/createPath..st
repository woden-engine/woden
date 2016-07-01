paths
createPath: aPathCreatingBlock
	^ WTAthensPath new firstSegment: (WTAthensSimplePathBuilder createPath: aPathCreatingBlock )