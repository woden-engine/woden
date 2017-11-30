rendering
pickGun
	"Add the picked FPS magnum .357"
	| magnumMesh animationState |
	magnumMesh := engine resourceCache loadMesh: 'models/demos/magnum_fps.wmjson'.	
	magnumMesh combineSubmeshesWithMaterial: 'materials/demos/magnum_fps.json'.
		
	pickedGun := WTSSpatialObject new.
	pickedGun renderable: magnumMesh.
	camera addChild: pickedGun.
	
	animationState := pickedGun renderableSceneData.
	gunAction := animationState actionNamed: 'Draw'.
	gunActionFrame := 0.0.
	gunActionRepeated := false.