Class {
	#name : #WTGSMagnumItemBehavior,
	#superclass : #WTGSItemBehavior,
	#category : 'WodenEngine-GameSystem-Item'
}

{ #category : #'double dispatch' }
WTGSMagnumItemBehavior >> activateOnPlayer: aPlayer [
	super activateOnPlayer: aPlayer.
	aPlayer addAndActivateWeapon: WTGSMagnumWeapon new.
]

{ #category : #accessing }
WTGSMagnumItemBehavior >> modelName [
	^ 'models/demos/magnum.fmdl'
]
