Class {
	#name : #RWObject,
	#superclass : #Object,
	#category : 'Woden2-Roassal-Core'
}

{ #category : #'as yet unclassified' }
RWObject class >> gtExamplesFinder [
	^ RWExampleFinder new
		source: self gtExamplesSource;
		provider: self gtExamplesProvider;
		subjects: self gtExamplesSubjects;
		yourself
]

{ #category : #testing }
RWObject >> isElement [
	^ false
]
