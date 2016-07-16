rendering
buildWireModelInto: meshBuilder
	2 to: indices size do: [ :i |
		meshBuilder addI1: (indices at: i - 1) + 1 i2: (indices at: i) + 1
	].

	meshBuilder addI1: indices last + 1 i2: indices first + 1
