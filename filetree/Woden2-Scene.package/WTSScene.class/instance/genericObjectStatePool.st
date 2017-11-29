accessing
genericObjectStatePool
	genericObjectStatePool ifNil: [
		genericObjectStatePool := WTStreamingUniformBufferPool new
			elementType: WTGenericObjectState;
			engine: engine;
			yourself ].
	^ genericObjectStatePool