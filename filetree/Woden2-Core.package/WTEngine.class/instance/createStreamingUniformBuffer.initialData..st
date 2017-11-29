resource building
createStreamingUniformBuffer: size initialData: initialData
	| desc |
	desc := AGPUBufferDescription new
		size: size;
		usage: AGPU_STREAM;
		binding: AGPU_UNIFORM_BUFFER;
		mapping_flags: self streamingMappedBufferMappingFlags;
		stride: 0.
	^ (WTBufferResource for: self) description: desc; data: initialData; checkSession ; yourself