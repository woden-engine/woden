Extension { #name : #SubscriptionRegistry }

{ #category : #'*WodenEngine-Roassal' }
SubscriptionRegistry >> handleSubscriberClass: eventClass [
	"Return true if the receiver has a callback subscripbed for the event class"
	^ subscriptions anySatisfy: [ :sub | 
		(sub subscriber class == eventClass) or: 
			[ sub subscriber class inheritsFrom: eventClass ] ]
]
