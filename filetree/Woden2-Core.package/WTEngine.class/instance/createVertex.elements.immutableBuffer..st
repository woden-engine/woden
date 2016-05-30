resource building
createVertex: vertexSize elements: elementCount immutableBuffer: data
	| desc |
	desc := AGPUBufferDescription new
		size: vertexSize*elementCount;
		usage: AGPU_STATIC;
		binding: AGPU_ARRAY_BUFFER;
		mapping_flags: 0;
		stride: vertexSize.
	^ (WTBufferResource for: self) description: desc; data: data; yourself