Class {
	#name : #WTAthensCanvas,
	#superclass : #AthensCanvas,
	#instVars : [
		'currentClipRect',
		'paintOptions'
	],
	#category : 'Woden2-Athens'
}

{ #category : #'bloc clipping' }
WTAthensCanvas >> clipByPath: aPathOrNil during: aBlock [
	"aPathOrNil ifNotNil: [ self setClipPath: aPathOrNil ]."
	aBlock value
]

{ #category : #initialization }
WTAthensCanvas >> initializeWithSurface: anAthensSurface [
	super initializeWithSurface: anAthensSurface.
	paintOptions := WTAthensPaintOptions on: anAthensSurface.
	paintOptions composeDefault
]

{ #category : #'bloc clipping' }
WTAthensCanvas >> isVisible: aRectangle [
	"Return true if the given rectangle is (partially) visible"
	^ true"(currentClipRect ifNil: [ ^ true ]) intersects: aRectangle"
]

{ #category : #accessing }
WTAthensCanvas >> paintMode [
	^ paintMode
]

{ #category : #accessing }
WTAthensCanvas >> paintOptions [
	^ paintOptions
]

{ #category : #'bloc clipping' }
WTAthensCanvas >> preservingClipBy: aRectangle during: aBlock [
	| oldClip  |
	oldClip := currentClipRect.
	" Works only if aRectangle is given according to a global coordinate reference"
	"currentClipRect := oldClip ifNil: [ aRectangle ] ifNotNil: [ oldClip intersect: aRectangle ifNone:[^ self] ]. "
	aBlock ensure: [ 
		currentClipRect := oldClip
	]
]

{ #category : #'bloc clipping' }
WTAthensCanvas >> preservingClipByLocal: aLocalRectangle global: aGlobalRectangle during: aBlock [
	| oldClip |
	oldClip := currentClipRect.
	"currentClipRect := oldClip
		ifNil: [ aGlobalRectangle ]
		ifNotNil: [ oldClip intersect: aGlobalRectangle ifNone: [ ^ self ] ]."
	aBlock ensure: [ 
		currentClipRect := oldClip
	]
]

{ #category : #initialization }
WTAthensCanvas >> setFont: aFont [
	"Set the current font of receiver. Font object should answer a glyph renderer instance,
	compatible with glyph renderer protocol" 
	aFont ifNil: [ ^ nil ].
	^ fontRenderer := aFont glyphRendererOn: surface.
]
