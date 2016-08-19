rendering
makeManipulatorsEmpty
	manipulatorBoxes do: [ :box | box makeEmpty ].
	manipulatorNodes do: [ :mnode | mnode visible: false ].
	