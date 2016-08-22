as yet unclassified
shootWithPlayer: aPlayer
	aPlayer runWeaponAnimationAction: 'Shoot' speed: 4.5 doAfter: [
		aPlayer runRepeatedWeaponAnimation: 'Idle'
	]