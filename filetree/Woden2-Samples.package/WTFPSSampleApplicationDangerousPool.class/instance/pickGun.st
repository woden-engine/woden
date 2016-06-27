rendering
pickGun
	"Add the picked FPS magnum .357"
	| magnumMesh |
	magnumMesh := engine resourceCache loadMesh: 'models/demos/magnum_fps.fmdl'.	
	pickedGun := WTSSpatialObject new.
	pickedGun renderable: magnumMesh.
	camera addChild: pickedGun.
