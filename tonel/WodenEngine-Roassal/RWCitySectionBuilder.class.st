Class {
	#name : #RWCitySectionBuilder,
	#superclass : #RWCityElementBuilder,
	#instVars : [
		'element'
	],
	#category : #'WodenEngine-Roassal-Builder-CityBuilder'
}

{ #category : #'instance creation' }
RWCitySectionBuilder class >> on: anElement [
	^ self new element: anElement; yourself
]

{ #category : #building }
RWCitySectionBuilder >> build [
	self subclassResponsibility
]

{ #category : #accessing }
RWCitySectionBuilder >> element [

	^ element
]

{ #category : #accessing }
RWCitySectionBuilder >> element: anObject [

	element := anObject
]
