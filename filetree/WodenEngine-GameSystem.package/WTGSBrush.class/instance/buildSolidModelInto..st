rendering
buildSolidModelInto: aMeshBuilder
	faces do: [ :face | face buildSolidModelInto: aMeshBuilder ].