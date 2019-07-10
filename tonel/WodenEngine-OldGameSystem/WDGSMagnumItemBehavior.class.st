Class {
	#name : #WDGSMagnumItemBehavior,
	#superclass : #WDGSItemBehavior,
	#category : #'WodenEngine-OldGameSystem-Item'
}

{ #category : #'double dispatch' }
WDGSMagnumItemBehavior >> activateOnPlayer: aPlayer [
	super activateOnPlayer: aPlayer.
	aPlayer addAndActivateWeapon: WDGSMagnumWeapon new.
]

{ #category : #accessing }
WDGSMagnumItemBehavior >> modelName [
	^ 'models/demos/magnum.fmdl'
]
