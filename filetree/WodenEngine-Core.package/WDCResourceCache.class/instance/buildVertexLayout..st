resource loading
buildVertexLayout: vertexLayout
	| device attribSize numberOfAttributes dest attrib attributeBuffer fieldType attribBuffer agpuLayout strideBuffer |
	device := engine device.
	
	"Compute the total number of attributes"
	attribSize := AGPUVertexAttribDescription structureSize.
	numberOfAttributes := 0.
	vertexLayout buffers do: [ :buffer |
		numberOfAttributes := numberOfAttributes + buffer fields size.
	].

	"Allocate storage for the attributes"
	attributeBuffer := ByteArray new: numberOfAttributes * attribSize.
	strideBuffer := ByteArray new: vertexLayout buffers size * 4.
	dest := 1.

	"Store the attributes"
	attrib := AGPUVertexAttribDescription new.
	vertexLayout buffers doWithIndex: [ :buffer :i |
		strideBuffer unsignedLongAt: i*4 - 3 put: buffer size.
		buffer fields do: [ :field |
			fieldType := field type.
			attrib
				buffer: i - 1;
				binding: field binding;
				format: fieldType format;
				rows: fieldType rows;
				divisor: 0;
				offset: field offset.

			"Put the structure in the array."
			attribBuffer := attrib getHandle.
			1 to: attribSize do: [ :j |
				attributeBuffer at: dest put: (attribBuffer at: j).
				dest := dest + 1.
			]
		]
	].
	
	agpuLayout := device createVertexLayout.
	agpuLayout addVertexAttributeBindings: vertexLayout buffers size vertex_strides: strideBuffer attribute_count: numberOfAttributes attributes: (AGPUVertexAttribDescription fromHandle: attributeBuffer).
	vertexLayout handle: agpuLayout.
