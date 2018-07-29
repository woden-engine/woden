"
I am a floating point property.
"
Class {
	#name : #WDIStanfordPLYPropertyFloatingPoint,
	#superclass : #WDIStanfordPLYProperty,
	#category : #'WodenEngine-Importers-PLY'
}

{ #category : #'instance creation' }
WDIStanfordPLYPropertyFloatingPoint >> readFrom: inputStream [
	^ inputStream next asNumber asFloat
]
