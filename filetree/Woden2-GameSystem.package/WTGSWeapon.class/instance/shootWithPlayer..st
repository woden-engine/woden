as yet unclassified
shootWithPlayer: player
	player playRandomShootSound: shootSounds.
	player runWeaponAnimationAction: 'Shoot' speed: 4.5 doAfter: [
		player runRepeatedWeaponAnimation: 'Idle'
	].

	player fireBulletSpeed: 30.0 