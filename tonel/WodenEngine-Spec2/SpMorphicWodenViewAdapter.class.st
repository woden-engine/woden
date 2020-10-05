Class {
	#name : #SpMorphicWodenViewAdapter,
	#superclass : #SpAbstractMorphicAdapter,
	#category : #'WodenEngine-Spec2'
}

{ #category : #factory }
SpMorphicWodenViewAdapter >> buildWidget [
	| wodenApplication viewClass |
	wodenApplication := self presenter wodenApplication.
	viewClass := self presenter wodenViewClass.
	^ (wodenApplication createWidgetInMorphicWith: viewClass)
		hResizing: #spaceFill;
		vResizing: #spaceFill;
		yourself

]
