Class {
	#name : #WTAthensStrokePaint,
	#superclass : #AthensStrokePaint,
	#category : 'Woden2-Athens-Paint'
}

{ #category : #rendering }
WTAthensStrokePaint >> athensFillPath: aPath on: aCanvas [
	^ aCanvas surface strokePath: aPath withStrokePaint: self
]

{ #category : #'setting cap styles' }
WTAthensStrokePaint >> capButt [
	self flag:#todo
]

{ #category : #'setting cap styles' }
WTAthensStrokePaint >> capRound [
	self flag:#todo
]

{ #category : #'setting cap styles' }
WTAthensStrokePaint >> capSquare [
	self flag:#todo
]

{ #category : #'setting cap styles' }
WTAthensStrokePaint >> dashes: anAlternateCollectionOfLenghts offset: anOffset [
	self flag: 'todo'
]

{ #category : #accessing }
WTAthensStrokePaint >> fillPaint [
	^ fillPaint
]

{ #category : #'setting join styles' }
WTAthensStrokePaint >> joinBevel [
	self flag:#todo
]

{ #category : #'setting join styles' }
WTAthensStrokePaint >> joinMiter [
	self flag:#todo
]

{ #category : #'setting join styles' }
WTAthensStrokePaint >> joinRound [
	self flag:#todo
]
