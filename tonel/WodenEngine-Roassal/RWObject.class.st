Class {
	#name : #RWObject,
	#superclass : #Object,
	#traits : 'TRWObject',
	#classTraits : 'TRWObject classTrait',
	#category : 'WodenEngine-Roassal-Core'
}

{ #category : #'as yet unclassified' }
RWObject class >> gtExamplesFinder [
	^ RWExampleFinder new
		source: self gtExamplesSource;
		provider: self gtExamplesProvider;
		subjects: self gtExamplesSubjects;
		yourself
]
