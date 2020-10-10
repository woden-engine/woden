Class {
	#name : #SpWodenViewPresenter,
	#superclass : #SpAbstractWidgetPresenter,
	#instVars : [
		'wodenApplication',
		'wodenViewClass'
	],
	#category : #'WodenEngine-Spec2'
}

{ #category : #specs }
SpWodenViewPresenter class >> adapterName [
	^ 'WodenViewAdapter'
]

{ #category : #accessing }
SpWodenViewPresenter >> view [
	^ wodenApplication views first
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
	^ wodenViewClass
]

{ #category : #accessing }
SpWodenViewPresenter >> wodenViewClass: anObject [
	wodenViewClass := anObject
]
