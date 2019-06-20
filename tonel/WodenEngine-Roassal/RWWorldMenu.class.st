"
I am the class that add a basic commands for woden
"
Class {
	#name : #RWWorldMenu,
	#superclass : #RWObject,
	#category : #'WodenEngine-Roassal-WorldMenu'
}

{ #category : #'world menu' }
RWWorldMenu class >> menuCommandOn: builder [
	<worldMenu>
	(builder item: #'Woden')
		parent: #Tools;
		order: 504;
		icon: self wodenIcon.
	builder withSeparatorAfter.
	(builder item: #'Reset Engine')
		parent: #Woden;
		order: 0;
		icon: (self iconNamed: 'smallCogState3');
		action: [ WDCEngine reset. self inform: 'Done!' ].
]

{ #category : #icons }
RWWorldMenu class >> wodenIcon [
	^ self iconNamed: 'testNotRun'
]
