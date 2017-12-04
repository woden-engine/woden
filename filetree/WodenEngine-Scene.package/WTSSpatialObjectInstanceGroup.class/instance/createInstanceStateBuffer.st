as yet unclassified
createInstanceStateBuffer
	^ WDCStreamingStorageBufferVector new
			capacity: (32 max: children size);
			elementType: WTGenericObjectState;
			engine: scene engine;
			yourself.