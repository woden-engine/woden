Class {
	#name : #WTBrickApplicationSampleButtons,
	#superclass : #WTBlocApplication,
	#category : 'Woden2-Bloc'
}

{ #category : #rendering }
WTBrickApplicationSampleButtons >> createMainBlocSpace [
	| b1 b2 b3 b4 b5 box space|
	
	BlMaterialTheme load.
	
	b1 := BrButton new 
		text: 'click me!';
		margin:(BlInsets all:5);
		constraintsDo:[:c| c alignCenter];
		addEventHandler: (BlOnClickHandler do:[:evt| evt target text: 'good job!']).
	
	b2 := BrButton new 
		text: 'button with icon';
		margin:(BlInsets all:5);
		constraintsDo:[:c| c alignCenter].
	
	b3 := BrButton new 
		text: 'button outlined';
		addStyleClass: #outlined;
		margin:(BlInsets all:5);
		constraintsDo:[:c| c alignCenter].
		
	b4 := BrButton new
		margin:(BlInsets all:5);
		constraintsDo:[:c| c alignCenter].	
	
	b5 := BrButton new 
		addStyleClass: #outlined;
		margin:(BlInsets all:5);
		constraintsDo:[:c| c alignCenter].	
	
	box := BrHBoxPane new
		constraintsDo:[:c| c vhMatchParent ; alignCenter];
		addChildren:{b1.b2.b3.b4.b5}.
	
	
	space := BlSpace new.
	space hostWindow: (WTBlVirtualWindow new engine: engine).
	space root
		addChild: box.
	
	^ space
	
]
