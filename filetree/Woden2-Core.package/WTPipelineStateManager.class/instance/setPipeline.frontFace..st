pipeline state object building
setPipeline: pipeline frontFace: faceName
	| face |
	face := FaceWindingNameMap at: faceName.
	pipeline setFrontFace: face.