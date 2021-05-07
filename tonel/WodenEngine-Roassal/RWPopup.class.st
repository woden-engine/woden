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
RWPopup >> buildUISceneGraphWith: builder for: anElement onlyText: onlyText [
	| textExtent textRectangle backgroundRectangle |

	text := self textFor: anElement.
	textExtent := ((font widthOfString: text) @ font getPreciseHeight).

	textRectangle := borderExtent + marginExtent extent: textExtent.
	backgroundRectangle := 0@0 extent: textExtent + ((borderExtent + marginExtent) * 2).
	
	onlyText ifTrue: [ ^ builder string: text in: textRectangle font: font color: color ].

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

{ #category : #hooks }
RWPopup >> initializeElement: anElement [
	| popupElement |
	popupElement := nil.
	anElement
		when: RWMouseEnter do: [ :evt |
			popupElement := anElement view createPopupAtViewPosition: evt position drawingWith: [ :builder |
				self buildUISceneGraphWith: builder for: anElement onlyText: false
			].
		];
		when: RWMouseMove do: [ :evt | popupElement view isInVirtualReality ifTrue: [popupElement position: evt position ]];
		when: RWMouseLeave do: [ :evt | popupElement remove ];
		when: RWTouch3DCursorEnter do: [ :evt |
			evt device displayUIWith: [ :builder |
				self buildUISceneGraphWith: builder for: anElement onlyText: true
			]
		]
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
