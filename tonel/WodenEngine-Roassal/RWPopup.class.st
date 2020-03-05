"
Define a popup on the element. Here is an example:
-=-=-=-=-=-=
v := RWView new.

c := RWCube element.
v add: c.

c addInteraction: RWPopup.

v open
-=-=-=-=-=-=
"
Class {
	#name : #RWPopup,
	#superclass : #RWElementInteraction,
	#instVars : [
		'text',
		'color'
	],
	#category : #'WodenEngine-Roassal-Interaction'
}

{ #category : #visiting }
RWPopup >> accept: aVisitor [
	^ aVisitor visitPopupInteraction: self
]

{ #category : #accessing }
RWPopup >> color [
	^ color
]

{ #category : #accessing }
RWPopup >> color: anObject [
	color := anObject
]

{ #category : #initialization }
RWPopup >> defaultPopupColor [
	^ Color black
]

{ #category : #initialization }
RWPopup >> initialize [
	super initialize.
	color := self defaultPopupColor.
	text := #yourself
]

{ #category : #hooks }
RWPopup >> initializeElement: anElement [
	| popupElement popupMesh builder font extent rectangle |
	popupElement := nil.
	popupMesh := nil.
	anElement
		when: RWMouseEnter do: [ :evt |
			popupMesh := nil.
			popupElement := anElement view createPopupAtViewPosition: evt position drawingWith: [ :canvas |
				popupMesh ifNil: [
					text := self textFor: anElement.
					font := anElement view babylonDefaultFont.
					extent := ((font widthOfString: text) @ font getPreciseAscent) + (20@10).
					rectangle := 0@0 extent: extent.
					builder := canvas driver mesh2DBuilder.
					builder fill
						color: Color white;
						rectangle: rectangle round: 4.
					builder stroke
						color: (Color black alpha: 0.5);
						width: 2;
						rectangle: rectangle round: 4.
					builder text
						color: color;
						font: font;
						draw: text onRectangleCenter: rectangle.
					popupMesh := builder mesh
				].
				
				canvas draw: popupMesh
			].
		];
		when: RWMouseMove do: [ :evt | popupElement view isInVirtualReality ifTrue: [popupElement position: evt position ]];
		when: RWMouseLeave do: [ :evt | popupElement remove ]
]

{ #category : #accessing }
RWPopup >> text [
	^ text
]

{ #category : #accessing }
RWPopup >> text: aBlockOrASymbol [
	"Evaluated against the model of the Roassal element"
	text := aBlockOrASymbol
]

{ #category : #utility }
RWPopup >> textFor: element [
	^ (text rwValue: element model) asString
]
