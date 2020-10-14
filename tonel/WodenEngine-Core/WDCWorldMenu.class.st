Class {
	#name : #WDCWorldMenu,
	#superclass : #Object,
	#category : #'WodenEngine-Core-Engine'
}

{ #category : #icons }
WDCWorldMenu class >> resetEngineMenuCommandOn: builder [
	<worldMenu>
	(builder item: #'Reset Engine')
		parent: #Woden;
		order: 500;
		icon: (self iconNamed: 'smallCogState3');
		action: [ WDCEngine reset. self inform: 'Done!' ]
]

{ #category : #icons }
WDCWorldMenu class >> wodenIcon [
	^ self iconNamed: 'testNotRun'
]

{ #category : #icons }
WDCWorldMenu class >> wodenMenuCommandOn: builder [
	<worldMenu>
	(builder item: #Woden)
		parent: #Tools;
		order: 504;
		icon: self wodenIcon.
	builder withSeparatorAfter.

]
