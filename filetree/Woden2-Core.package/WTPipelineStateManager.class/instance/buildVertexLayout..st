abstract gpu baking
buildVertexLayout: vertexLayout
	| device attribSize numberOfAttributes dest attrib attributeBuffer fieldType attribBuffer agpuLayout |
	device := engine device.
	
	"Compute the total number of attributes"
	attribSize := AGPUVertexAttribDescription instanceSize.
	numberOfAttributes := 0.
	vertexLayout buffers do: [ :buffer |
		numberOfAttributes := numberOfAttributes + buffer fields size.
	].

	"Allocate storage for the attributes"
	attributeBuffer := ByteArray new: numberOfAttributes * attribSize.
	dest := 1.

	"Store the attributes"
	attrib := AGPUVertexAttribDescription new.
	vertexLayout buffers doWithIndex: [ :buffer :i |
		buffer fields do: [ :field |
			fieldType := field type.
			attrib
				buffer: i - 1;
				binding: field binding;
				type: fieldType agpuType;
				components: fieldType components;
				rows: fieldType rows;
				normalized: fieldType normalized;
				divisor: 0;
				offset: field offset.

			"Put the structure in the array."
			attribBuffer := attrib address.
			1 to: attribSize do: [ :j |
				attributeBuffer at: dest put: (attribBuffer at: j).
				dest := dest + 1.
			]
		]
	].
	
	agpuLayout := device createVertexLayout.
	agpuLayout addVertexAttributeBindings: vertexLayout buffers size attribute_count: numberOfAttributes attributes: (AGPUVertexAttribDescription fromPointer: attributeBuffer).
	vertexLayout handle: agpuLayout.


	