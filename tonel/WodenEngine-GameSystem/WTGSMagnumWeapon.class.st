Class {
	#name : #WTGSMagnumWeapon,
	#superclass : #WTGSWeapon,
	#category : 'WodenEngine-GameSystem-Item'
}

{ #category : #'as yet unclassified' }
WTGSMagnumWeapon >> fpsModelName [
	^ 'models/demos/magnum_fps.fmdl'
]

{ #category : #'as yet unclassified' }
WTGSMagnumWeapon >> shootSoundNames [
	^ #(
	'sounds/explosion/explosion1.wav'
	'sounds/explosion/explosion2.wav'
	)
]
