accessing
neutralGenericObjectInstanceState
	neutralObjectInstanceStatePool ifNil: [
		neutralObjectInstanceStatePool := WDCStreamingStorageBufferPool new
			heapSize: 1;
			elementType: WTGenericObjectState;
			engine: engine;
			yourself.
			
		neutralObjectInstanceState := neutralObjectInstanceStatePool allocate.
		neutralObjectInstanceState value: WTGenericObjectState neutralState
	].
	^ neutralObjectInstanceState