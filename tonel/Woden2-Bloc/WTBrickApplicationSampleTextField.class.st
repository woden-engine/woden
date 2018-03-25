Class {
	#name : #WTBrickApplicationSampleTextField,
	#superclass : #WTBlocApplication,
	#category : 'Woden2-Bloc'
}

{ #category : #rendering }
WTBrickApplicationSampleTextField >> createMainBlocSpace [
	| b1 b2 box space|
	
	BlMaterialTheme load.
	
	b1 := BrTextField new 
		placeholder: 'i am a text field';
		constraintsDo: [:c|c hMatchParent];
		margin:(BlInsets all:5);
		fontColor: Color black;
		constraintsDo:[:c| c alignCenter].	
			
	b2 := BrTextField new 
		placeholder: 'i am a fixed text field';
		margin:(BlInsets all:5);
		fontColor: Color black;
		width: 150;
		constraintsDo:[:c| c alignCenter].	
			
	box := BrVBoxPane new
		constraintsDo:[:c| c vhMatchParent ; alignCenter];
		addChildren:{b1.b2}.
	
	space := BlSpace new.
	space hostWindow: (WTBlVirtualWindow new engine: engine).
	space root
		addChild: box.
	
	^ space
	
]
