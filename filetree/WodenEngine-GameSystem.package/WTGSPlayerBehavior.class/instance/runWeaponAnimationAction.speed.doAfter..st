weapon animation
runWeaponAnimationAction: actionName speed: animationSpeed doAfter: finishBlock
	| animationState |
	animationState := weaponSceneNode renderableSceneData.
	weaponAction := animationState actionNamed: actionName.
	weaponActionFrame := 0.0.
	weaponActionRepeated := false.
	weaponAnimationSpeed := animationSpeed.