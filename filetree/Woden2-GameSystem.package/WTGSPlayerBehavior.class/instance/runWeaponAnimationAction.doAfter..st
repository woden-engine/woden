adding
runWeaponAnimationAction: actionName doAfter: finishBlock
	| animationState |
	animationState := weaponSceneNode renderableSceneData.
	weaponAction := animationState actionNamed: actionName.
	weaponActionFrame := 0.0.
	weaponActionRepeated := false