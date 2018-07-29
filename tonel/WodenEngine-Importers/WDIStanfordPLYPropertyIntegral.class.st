"
I am an integral property.
"
Class {
	#name : #WDIStanfordPLYPropertyIntegral,
	#superclass : #WDIStanfordPLYProperty,
	#category : #'WodenEngine-Importers-PLY'
}

{ #category : #'instance creation' }
WDIStanfordPLYPropertyIntegral >> readFrom: inputStream [
	^ inputStream next asInteger
]
