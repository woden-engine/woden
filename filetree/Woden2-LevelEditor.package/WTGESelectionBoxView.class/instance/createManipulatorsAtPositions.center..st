as yet unclassified
createManipulatorsAtPositions: positions center: center
	| halfExtent baseBox manipulatorBox manip |
	halfExtent := 0.08.
	baseBox := WMBox3DD halfExtent: (WMVector3D x: halfExtent y: halfExtent z: halfExtent).
	positions doWithIndex: [ :corner :index |
		manipulatorBox := baseBox translatedBy: corner.
		manipulatorBoxes at: index put: manipulatorBox.
		manip := manipulatorNodes at: index.
		manip model direction: (corner - center) normalized.
		manip visible: manipulatorBox isEmpty not.
		manip visible ifTrue: [ manip transform setForBox: manipulatorBox ]
	].