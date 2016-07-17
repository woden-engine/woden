selection
selectionBoxChanged
	| halfExtent baseBox manipulatorBox node |
	selectionBoxNode visible: selectionBox isEmpty not.
	selectionBoxNode visible ifFalse: [
		selectionBoxManipulators do: [ :box | box makeEmpty ].
		selectionBoxManipulatorNodes do: [ :mnode | mnode visible: false ].
		^ self.
	].

	halfExtent := 0.08.
	baseBox := WMBox3DD halfExtent: (WMVector3D x: halfExtent y: halfExtent z: halfExtent).
	selectionBoxNode transform setForBox: selectionBox.
	selectionBox manipulationCorners doWithIndex: [ :corner :index |
		manipulatorBox := baseBox translatedBy: corner.
		selectionBoxManipulators at: index put: manipulatorBox.
		node := selectionBoxManipulatorNodes at: index.
		node visible: manipulatorBox isEmpty not.
		node visible ifTrue: [ node transform setForBox: manipulatorBox ]
	].
