Class {
	#name : #BaselineOfWodenEngine,
	#superclass : #BaselineOf,
	#category : 'BaselineOfWodenEngine'
}

{ #category : #baselines }
BaselineOfWodenEngine >> baseline: spec [
    <baseline>
    spec for: #'common' do: [
			spec blessing: #baseline.
			spec 
				project: 'NeoJSON' with: [
				spec
					className: #ConfigurationOfNeoJSON;
					versionString: #'stable';
					repository: 'http://mc.stfx.eu/Neo' ].
			spec 
				project: 'AbstractGPU' with: [
				spec
					className: #ConfigurationOfAbstractGPU;
					versionString: #'stable';
					repository: 'http://smalltalkhub.com/mc/ronsaldo/AbstractGPU/main' ].
			spec 
				project: 'AbstractPhysics' with: [
				spec
					className: #ConfigurationOfAbstractPhysics;
					versionString: #'development';
					repository: 'http://smalltalkhub.com/mc/ronsaldo/AbstractPhysics/main' ].
			spec 
				project: 'Dastrel' with: [
				spec
					className: #ConfigurationOfDastrel;
					versionString: #'development';
					repository: 'http://smalltalkhub.com/mc/ronsaldo/Dastrel/main' ].
			spec 
				project: 'OpenAL' with: [
				spec
					className: #ConfigurationOfOpenAL;
					versionString: #'development';
					repository: 'http://smalltalkhub.com/mc/ronsaldo/OpenAL/main' ].
			spec project: 'Roassal2' with: [
				spec
					className: #ConfigurationOfRoassal2;
					versionString: #'development';
					repository: 'http://smalltalkhub.com/mc/ObjectProfile/Roassal2/main' ].
		spec package: #'WodenEngine-Core' with: [
				spec requires: #('NeoJSON' 'AbstractGPU' 'Dastrel')].
		spec package: #'WodenEngine-Pompeii' with: [
				spec requires: #('WodenEngine-Core')].
		spec package: #'WodenEngine-Scene' with: [
				spec requires: #('WodenEngine-Core')].
		spec package: #'WodenEngine-Samples' with: [
				spec requires: #('WodenEngine-Core' 'WodenEngine-Pompeii' 'WodenEngine-Scene' 'WodenEngine-GameSystem')].
		spec package: #'WodenEngine-Physics' with: [
				spec requires: #('WodenEngine-Core' 'AbstractPhysics')].
		spec package: #'WodenEngine-OpenAL' with: [
				spec requires: #('WodenEngine-Core' 'OpenAL')].
		spec package: #'WodenEngine-GameSystem' with: [
				spec requires: #('WodenEngine-Core' 'WodenEngine-Pompeii' 'WodenEngine-Scene' 'WodenEngine-Physics' 'WodenEngine-OpenAL')].
		spec package: #'WodenEngine-Roassal' with: [
				spec requires: #('Roassal2' 'WodenEngine-Core' 'WodenEngine-Pompeii' 'WodenEngine-Scene' 'WodenEngine-Physics')].

		spec group: 'default' with: #('WodenEngine-Core' 'WodenEngine-Pompeii' 'WodenEngine-Samples' 'WodenEngine-GameSystem' 'WodenEngine-Roassal')
	]

]
