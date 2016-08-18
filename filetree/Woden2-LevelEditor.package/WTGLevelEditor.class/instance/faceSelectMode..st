selection
faceSelectMode: mode
	faceSelectMode := mode.
	faceSelectMode ifTrue: [
		self selection: selection asElementSelection
	] ifFalse: [
		self selection: selection asBoxSelection
	]