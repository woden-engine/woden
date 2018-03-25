Class {
	#name : #RWGridLayoutTest,
	#superclass : #TestCase,
	#category : 'WodenEngine-Roassal-Tests'
}

{ #category : #'as yet unclassified' }
RWGridLayoutTest >> testEmpty [
	RWXZGridLayout on: #()
]

{ #category : #'as yet unclassified' }
RWGridLayoutTest >> testGap [
	| layout |
	layout := RWXZGridLayout new.
	self assert: layout gap = 1.
	layout gap: 2.
	self assert: layout gap = 2.
]

{ #category : #'as yet unclassified' }
RWGridLayoutTest >> testGap2 [
	| layout |
	layout := RWXZGridLayout gap: 2.
	self assert: layout gap = 2.
]
