as yet unclassified
createVertex: vertexSize elements: elementCount immutableBuffer: data
	| desc |
	desc := AGPUBufferDescription new
		size: vertexSize*elementCount;
		usage: AGPU_STATIC;
		binding: AGPU_ARRAY_BUFFER;
		mapping_flags: 0;
		stride: vertexSize.
	^ engine device createBuffer: desc initial_data: data