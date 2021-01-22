Class {
	#name : #SpWodenSingleSelectionMode,
	#superclass : #SpAbstractWodenSelectionMode,
	#instVars : [
		'#selectedItem => SpObservableSlot'
	],
	#category : #'WodenEngine-Spec2'
}

{ #category : #initialization }
SpWodenSingleSelectionMode >> initialize [
	
	self class initializeSlots: self.
	super initialize.
]

{ #category : #api }
SpWodenSingleSelectionMode >> selectItem: anItem [
	selectedItem := anItem
]

{ #category : #accessing }
SpWodenSingleSelectionMode >> selectedItem [
	^ selectedItem
]

{ #category : #accessing }
SpWodenSingleSelectionMode >> transmission [
	^ self selectedItem
]
