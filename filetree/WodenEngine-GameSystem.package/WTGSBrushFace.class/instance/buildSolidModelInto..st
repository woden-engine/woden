rendering
buildSolidModelInto: meshBuilder
	| positions position normal |
	meshBuilder
		beginTriangles;
		currentColor: self currentColor asWMVector4F.
		
	positions := brush positions.
	normal := plane normal asWMVector3F.
	indices do: [ :i |
		position := (positions at: i + 1) asWMVector3F.
		meshBuilder addP: position N: normal.
	].

	3 to: indices size do:[ :i |
		meshBuilder addI1: 1 i2: i - 1 i3: i
	].
