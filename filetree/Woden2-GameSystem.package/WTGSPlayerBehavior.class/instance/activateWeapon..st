adding
activateWeapon: aWeapon
	currentWeapon := aWeapon.
	weaponSceneNode ifNotNil: [
		self flag: 'Try to avoid removing the old scene node.'.
		weaponSceneNode removeFromScene
	].
	
	weaponSceneNode := WTSSpatialObject new.
	weaponSceneNode renderable: (currentWeapon fpsModelFor: self engine).
	self levelPlayer camera addChild: weaponSceneNode.

	self runWeaponAnimationAction: 'Draw'.