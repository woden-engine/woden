Class {
	#name : #WDESUseActuationBoxVolumeComponent,
	#superclass : #WDESRayCastingBoxVolumeComponent,
	#category : #'WodenEngine-EntitySystem-Nodes'
}

{ #category : #notifications }
WDESUseActuationBoxVolumeComponent >> rayCastingSetForSector: aSector [
	^ aSector usableVolumeRayCastingSet
]
