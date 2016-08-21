as yet unclassified
runLocalStepMethods
	| now morphToStep stepTime priorWorld |
	now := Time millisecondClockValue.
	priorWorld := ActiveWorld.
	ActiveWorld := self.
	self triggerAlarmsBefore: now.
	stepList isEmpty 
		ifTrue: 
			[ActiveWorld := priorWorld.
			^self].
	(now < lastStepTime or: [now - lastStepTime > 5000]) 
		ifTrue: [self adjustWakeupTimes: now].	"clock slipped"
	[stepList isEmpty not and: [stepList first scheduledTime < now]] 
		whileTrue: 
			[lastStepMessage := stepList removeFirst.
			morphToStep := lastStepMessage receiver.
			(morphToStep shouldGetStepsFrom: self) 
				ifTrue: 
					[lastStepMessage value: now.
					lastStepMessage ifNotNil: 
							[stepTime := lastStepMessage stepTime ifNil: [morphToStep stepTime].
							lastStepMessage scheduledTime: now + (stepTime max: 1).
							stepList add: lastStepMessage]].
			lastStepMessage := nil].
	lastStepTime := now.
	ActiveWorld := priorWorld