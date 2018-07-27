Class {
	#name : #WDGSMagnumWeapon,
	#superclass : #WDGSWeapon,
	#category : #'WodenEngine-GameSystem-Item'
}

{ #category : #'as yet unclassified' }
WDGSMagnumWeapon >> fpsModelName [
	^ 'models/demos/magnum_fps.fmdl'
]

{ #category : #'as yet unclassified' }
WDGSMagnumWeapon >> shootSoundNames [
	^ #(
	'sounds/explosion/explosion1.wav'
	'sounds/explosion/explosion2.wav'
	)
]
