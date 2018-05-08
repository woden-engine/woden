Class {
	#name : #RWGridLayoutTest,
	#superclass : #TestCase,
	#category : 'WodenEngine-Roassal-Tests'
}

{ #category : #tests }
RWGridLayoutTest >> testEmpty [
	RWXZGridLayout on: #()
]

{ #category : #tests }
RWGridLayoutTest >> testGap [
	| layout |
	layout := RWXZGridLayout new.
	self assert: layout gap = 1.
	layout gap: 2.
	self assert: layout gap = 2.
]

{ #category : #tests }
RWGridLayoutTest >> testGap2 [
	| layout |
	layout := RWXZGridLayout gap: 2.
	self assert: layout gap = 2.
]

{ #category : #tests }
RWGridLayoutTest >> testNoGap [
	| layout |
	layout := RWXZGridLayout nogap.
	self assert: layout gap = 0.
]
