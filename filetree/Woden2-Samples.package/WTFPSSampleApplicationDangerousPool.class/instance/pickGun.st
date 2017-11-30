rendering
pickGun
	"Add the picked FPS magnum .357"
	| magnumMesh animationState |
	magnumMesh := (engine resourceCache loadModel: 'models/demos/magnum_fps.wmjson')
		combineSubmeshesWithMaterial: 'materials/demos/magnum_fps.json';
		meshFor: engine.
		
	pickedGun := WTSSpatialObject new.
	pickedGun renderable: magnumMesh.
	camera addChild: pickedGun.
	
	animationState := pickedGun renderableSceneData.
	gunAction := animationState actionNamed: 'Draw'.
	gunActionFrame := 0.0.
	gunActionRepeated := false.