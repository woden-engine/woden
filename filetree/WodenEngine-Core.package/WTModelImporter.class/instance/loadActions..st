as yet unclassified
loadActions: actionsData
	| actions |
	actions := Dictionary new.
	actionsData do: [ :actionData |
		actions at: (actionData at: 'name') put: (self loadAction: actionData).
	].

	^ actions