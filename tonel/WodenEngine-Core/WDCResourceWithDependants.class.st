Class {
	#name : #WDCResourceWithDependants,
	#superclass : #Object,
	#instVars : [
		'dependants'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-GPU-Resources'
}

{ #category : #adding }
WDCResourceWithDependants >> addWodenResourceDependant: dep [
	self validDependants add: dep
]

{ #category : #adding }
WDCResourceWithDependants >> changed [
	dependants ifNotNil: [
		dependants do: [ :dep | dep dependencyChange: self ]
	]
]

{ #category : #accessing }
WDCResourceWithDependants >> dependants: aSetOfDependants [
	dependants := aSetOfDependants
]

{ #category : #'resource reloading' }
WDCResourceWithDependants >> loadStateFromOldVersion: oldVersion [
]

{ #category : #'resource reloading' }
WDCResourceWithDependants >> reloadReplacement: aReplacement [
	aReplacement dependants: dependants.
	self class == aReplacement class ifTrue: [ aReplacement loadStateFromOldVersion: self ].
	self becomeForward: aReplacement copyHash: true.
	aReplacement changed.

]

{ #category : #adding }
WDCResourceWithDependants >> removeWodenResourceDependant: dep [
	self validDependants remove: dep
]

{ #category : #path }
WDCResourceWithDependants >> sessionChanged [
]

{ #category : #'resource reloading' }
WDCResourceWithDependants >> validDependants [
	^ dependants ifNil: [ dependants := WeakSet new ]
]
