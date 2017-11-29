as yet unclassified
createInstanceStateBuffer
	^ WTStreamingStorageBufferVector new
			capacity: (32 max: children size);
			elementType: WTGenericObjectState;
			engine: scene engine;
			yourself.