Class {
	#name : #WDGSMapExamples,
	#superclass : #Object,
	#category : #'WodenEngine-GameSystem-Examples'
}

{ #category : #'as yet unclassified' }
WDGSMapExamples class >> exampleESUG2016 [
	(WDGSMap loadJsonFromFileNamed: 'core-assets/maps/demos/esug-2016.json') play
]
