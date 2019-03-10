Class {
	#name : #WodenCoreAssets,
	#superclass : #Object,
	#classVars : [
		'Session',
		'WodenCoreAssetsLocation'
	],
	#category : #'WodenEngine-Core-Locations'
}

{ #category : #accessing }
WodenCoreAssets class >> findCoreAssets [
	| location |
	location := Smalltalk imageDirectory / 'core-assets'.
	location exists ifFalse: [
		location := IceLibgitRepository repositoriesLocation / #ronsaldo / #woden / #'core-assets'
	].

	location exists ifFalse: [
		location := FileSystem workingDirectory / 'core-assets'
	].
	
	location exists ifFalse: [
		self error: 'Failed to find the Woden Lowtalk sources.'
	].

	^ location
]

{ #category : #accessing }
WodenCoreAssets class >> location [
	Session ~~ Smalltalk session ifTrue: [ 
		WodenCoreAssetsLocation := self findCoreAssets.
		Session := Smalltalk session
	].
	^ WodenCoreAssetsLocation
]
