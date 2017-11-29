resource building
createVertex: vertexSize elements: elementCount streamingData: data
	| desc |
	desc := AGPUBufferDescription new
		size: vertexSize*elementCount;
		usage: AGPU_STATIC;
		binding: AGPU_ARRAY_BUFFER;
		mapping_flags: self streamingMappedBufferMappingFlags;
		stride: vertexSize.
	^ (WTBufferResource for: self) description: desc; data: data; checkSession; yourself