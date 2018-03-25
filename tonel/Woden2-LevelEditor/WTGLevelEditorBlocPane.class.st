Class {
	#name : #WTGLevelEditorBlocPane,
	#superclass : #Object,
	#instVars : [
		'bloc'
	],
	#category : 'Woden2-LevelEditor'
}

{ #category : #'as yet unclassified' }
WTGLevelEditorBlocPane >> addLabel: label [
	bloc addChild: (BrLabel new
		text: label;
		constraintsDo:[:c| c alignCenter.])
	
]

{ #category : #'as yet unclassified' }
WTGLevelEditorBlocPane >> addLabel: label inputAction: inputAction plusAction: plusAction minusAction: minusAction [
	| row labelBrick inputBrick plusButton minusButton |
	row := BrHBoxPane new
		constraintsDo:[:c| c hMatchParent ; alignCenter.].
		
	labelBrick := BrLabel new 
		text: label;
		margin:(BlInsets all:5);
		constraintsDo:[:c| c alignCenter].
	inputBrick := BrTextField new 
		constraintsDo: [:c|c hMatchParent; alignCenter].
	plusButton := BrButton new 
		text: '+';
		constraintsDo: [:c|c alignCenter];
		addEventHandler: (BlOnClickHandler do:[:evt| plusAction value]).
	minusButton := BrButton new 
		text: '-';
		constraintsDo: [:c|c alignCenter];
		addEventHandler: (BlOnClickHandler do:[:evt| minusAction value]).
		
	row addChildren: { labelBrick . inputBrick . plusButton . minusButton }.
	bloc addChild: row.
	
	^ inputBrick
]

{ #category : #accessing }
WTGLevelEditorBlocPane >> bloc [
	^ bloc
]

{ #category : #accessing }
WTGLevelEditorBlocPane >> bloc: anObject [
	bloc := anObject
]
