memory pools
streamingStorageBufferPoolFor: aClass
	poolsMutex critical: [ 
		^ streamingStorageBufferPools at: aClass ifAbsentPut: [ WDCStreamingStorageBufferPool engine: engine elementType: aClass ]
	]
