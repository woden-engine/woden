rendering
buildWireModelInto: aMeshBuilder
	aMeshBuilder
		beginLines;
		currentColor: self currentColor asWMVector4F.
	positions do: [ :position |
		aMeshBuilder addP: position asWMVector3F.
	].

	faces do: [ :face | face buildWireModelInto: aMeshBuilder ].