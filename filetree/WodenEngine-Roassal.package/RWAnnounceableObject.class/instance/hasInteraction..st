testing
hasInteraction: anInteractionClass
	self announcer subscriptions ifNil: [ ^ false ].
	
	^ self announcer subscriptions handleSubscriberClass: anInteractionClass