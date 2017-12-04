resource building
createUniformBuffer: size immutableData: data
	| desc |
	desc := AGPUBufferDescription new
		size: size;
		usage: AGPU_STATIC;
		binding: AGPU_UNIFORM_BUFFER;
		mapping_flags: 0;
		stride: 0.
	^ (WDCBufferResource for: self) description: desc; data: data; yourself