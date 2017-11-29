adding
activateWeapon: aWeapon
	currentWeapon := aWeapon.
	weaponSceneNode ifNotNil: [
		self flag: 'Try to avoid removing the old scene node.'.
		weaponSceneNode removeFromScene
	].
	
	weaponSceneNode := WTSSpatialObject new.
	currentWeapon precacheResourcesFor: self engine.
	weaponSceneNode renderable: (currentWeapon fpsModelFor: self engine).
	self levelPlayer camera addChild: weaponSceneNode.

	self runWeaponAnimationAction: 'Draw'.