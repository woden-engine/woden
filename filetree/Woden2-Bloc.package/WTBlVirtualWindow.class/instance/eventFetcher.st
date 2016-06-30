as yet unclassified
eventFetcher
	^ eventFetcher ifNil:[eventFetcher := BlOSWindowEventFetcher new]