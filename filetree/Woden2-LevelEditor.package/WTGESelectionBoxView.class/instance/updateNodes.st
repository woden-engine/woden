rendering
updateNodes
	| halfExtent baseBox manipulatorBox manip |
	node visible: editor selectionBox isEmpty not.
	node visible ifFalse: [
		manipulatorBoxes do: [ :box | box makeEmpty ].
		manipulatorNodes do: [ :mnode | mnode visible: false ].
		^ self.
	].

	halfExtent := 0.08.
	baseBox := WMBox3DD halfExtent: (WMVector3D x: halfExtent y: halfExtent z: halfExtent).
	node transform setForBox: editor selectionBox box.
	editor selectionBox box manipulationCorners doWithIndex: [ :corner :index |
		manipulatorBox := baseBox translatedBy: corner.
		manipulatorBoxes at: index put: manipulatorBox.
		manip := manipulatorNodes at: index.
		manip visible: manipulatorBox isEmpty not.
		manip visible ifTrue: [ manip transform setForBox: manipulatorBox ]
	].

	self updateColors.