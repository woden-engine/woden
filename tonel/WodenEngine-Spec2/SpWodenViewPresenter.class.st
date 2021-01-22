Class {
	#name : #SpWodenViewPresenter,
	#superclass : #SpAbstractWidgetPresenter,
	#instVars : [
		'wodenApplication',
		'wodenViewClass',
		'activationBlock'
	],
	#category : #'WodenEngine-Spec2'
}

{ #category : #specs }
SpWodenViewPresenter class >> adapterName [
	^ 'WodenViewAdapter'
]

{ #category : #ports }
SpWodenViewPresenter >> activateItem: anItem [
	activationBlock cull: ((SpWodenSingleSelectionMode on: self)
		selectItem: anItem;
		yourself)
]

{ #category : #api }
SpWodenViewPresenter >> activateOnDoubleClick [
]

{ #category : #api }
SpWodenViewPresenter >> activateOnSingleClick [
]

{ #category : #initialization }
SpWodenViewPresenter >> initialize [
	super initialize.
	activationBlock := [].
	
]

{ #category : #ports }
SpWodenViewPresenter >> outputActivationPort [
	
	^ SpActivationPort newPresenter: self
]

{ #category : #accessing }
SpWodenViewPresenter >> view [
	^ wodenApplication views first
]

{ #category : #ports }
SpWodenViewPresenter >> whenActivatedDo: aBlock [
	"Inform when an element has been 'activated'. 
	 `aBlock` receives one argument (a selection object, see `SpAbstractSelectionMode`)"
	
	activationBlock := aBlock
]

{ #category : #accessing }
SpWodenViewPresenter >> wodenApplication [
	^ wodenApplication
]

{ #category : #accessing }
SpWodenViewPresenter >> wodenApplication: anObject [
	wodenApplication := anObject
]

{ #category : #accessing }
SpWodenViewPresenter >> wodenViewClass [
	^ wodenViewClass ifNil: [ wodenViewClass := wodenApplication ifNotNil: [wodenApplication defaultViewClass ] ]
]

{ #category : #accessing }
SpWodenViewPresenter >> wodenViewClass: anObject [
	wodenViewClass := anObject
]
