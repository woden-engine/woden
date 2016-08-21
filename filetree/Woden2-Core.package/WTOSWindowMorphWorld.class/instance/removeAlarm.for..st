alarm-scheduler
removeAlarm: aSelector for: aTarget
	self alarms
		detect: [ :any | any receiver == aTarget and: [ any selector == aSelector ] ]
		ifFound: [ :alarm | self alarms remove: alarm ]