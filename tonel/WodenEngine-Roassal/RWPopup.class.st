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
	#superclass : #RWAbstractPopup,
	#instVars : [
		'text',
		'color',
		'font',
		'borderExtent',
		'marginExtent'
	],
	#category : #'WodenEngine-Roassal-Interaction'
}

{ #category : #visiting }
RWPopup >> accept: aVisitor [
	^ aVisitor visitPopupInteraction: self
]

{ #category : #hooks }
RWPopup >> buildUISceneGraphWith: builder for: anElement in3DBillboard: in3DBillboard [
	| textExtent textRectangle backgroundRectangle |

	text := self textFor: anElement.
	textExtent := ((font widthOfString: text) @ font getPreciseHeight).

	textRectangle := borderExtent + marginExtent extent: textExtent.
	backgroundRectangle := 0@0 extent: textExtent + ((borderExtent + marginExtent) * 2).
	
	in3DBillboard ifTrue: [ ^ builder string: text in: textRectangle font: font color: color ].

	^ (builder rectangle: backgroundRectangle color: Color white) ,
	(builder string: text in: textRectangle font: font color: color) ,
	(builder borderRectangle: backgroundRectangle color: (Color black alpha: 0.5)
		leftWidth: borderExtent x rightWidth: borderExtent x
		bottomWidth: borderExtent y topWidth: borderExtent y)

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
	text := #yourself.
	
	font := TextStyle defaultFont.
	borderExtent := 2@2.
	marginExtent := 4@4.

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
