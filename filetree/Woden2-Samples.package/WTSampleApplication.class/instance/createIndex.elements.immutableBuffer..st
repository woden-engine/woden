as yet unclassified
createIndex: indexSize elements: elementCount immutableBuffer: data
	| desc |
	desc := AGPUBufferDescription new
		size: indexSize*elementCount;
		usage: AGPU_STATIC;
		binding: AGPU_ELEMENT_ARRAY_BUFFER;
		mapping_flags: 0;
		stride: indexSize.
	^ engine device createBuffer: desc initial_data: data