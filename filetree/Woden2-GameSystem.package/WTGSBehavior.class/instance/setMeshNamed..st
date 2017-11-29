utility
setMeshNamed: meshName
	| mesh |
	mesh := self loadMesh: meshName.
	entity ensureSpatialObject node renderable: mesh.
	^ mesh