Class {
	#name : #RWCityBuildingBuilder,
	#superclass : #RWCityElementBuilder,
	#instVars : [
		'shape'
	],
	#category : #'WodenEngine-Roassal-Builder-CityBuilder'
}

{ #category : #'as yet unclassified' }
RWCityBuildingBuilder >> buildElementsFor: aCollectionOfElements [
	| elements |
	elements := shape elementsOn: aCollectionOfElements.
	elements do: [ :each | each addInteractions: interactions ].
	^ elements
]

{ #category : #accessing }
RWCityBuildingBuilder >> color: color [
	shape color: color
]

{ #category : #accessing }
RWCityBuildingBuilder >> depth: depth [
	shape depth: depth
]

{ #category : #accessing }
RWCityBuildingBuilder >> height: height [
	shape height: height
]

{ #category : #initialization }
RWCityBuildingBuilder >> initialize [
	super initialize.
	shape := RWCube new.
]

{ #category : #accessing }
RWCityBuildingBuilder >> width: width [
	shape width: width
]
