Extension { #name : #OSKeyboardEvent }

{ #category : #'*WodenEngine-Core' }
OSKeyboardEvent >> asKeyCombination [
	| modifier control command shift alt key |

	control := self modifiers ctrl.
	command := self modifiers cmd.
	shift := self modifiers shift.
	alt := self modifiers alt.
	key := OSKeySymbols mapKeySymbolValueToKeyboardKey: symbol.
	
	(shift | command | control | alt)
		ifFalse: [^ key asKeyCombination ].
	
	modifier := KMNoShortcut new.
	control ifTrue: [ modifier := modifier + KMModifier ctrl ].
	command ifTrue: [ modifier := modifier + KMModifier command ].
	shift ifTrue: [ modifier := modifier + KMModifier shift ].
	alt ifTrue: [ modifier := modifier + KMModifier alt ].

	^ modifier + key
]
