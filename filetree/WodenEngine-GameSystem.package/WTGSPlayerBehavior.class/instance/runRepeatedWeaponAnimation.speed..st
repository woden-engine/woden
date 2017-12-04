weapon animation
runRepeatedWeaponAnimation: actionName speed: animationSpeed
	| animationState |
	animationState := weaponSceneNode renderableSceneData.
	weaponAction := animationState actionNamed: actionName.
	weaponActionFrame := 0.0.
	weaponActionRepeated := true.
	weaponAnimationSpeed := animationSpeed.