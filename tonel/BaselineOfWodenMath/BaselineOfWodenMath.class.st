Class {
	#name : #BaselineOfWodenMath,
	#superclass : #BaselineOf,
	#category : #BaselineOfWodenMath
}

{ #category : #baselines }
BaselineOfWodenMath >> baseline: spec [
    <baseline>
    spec for: #'common' do: [
		spec blessing: #baseline.
		spec postLoadDoIt: #postLoadActions.
		spec 
			baseline: #'Lowtalk' with: [
				spec
				repository: 'github://ronsaldo/lowtalk/tonel' ].
		spec package: #'WodenMath-SourceLoader' with: [
			spec requires: #(#Lowtalk)].
	]

]

{ #category : #baselines }
BaselineOfWodenMath >> postLoadActions [
	(Smalltalk globals at: #WodenMathSourceLoader) loadWodenMathSources
]
