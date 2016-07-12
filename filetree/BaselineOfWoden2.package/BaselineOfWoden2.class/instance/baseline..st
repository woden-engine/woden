baseline
baseline: spec
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
				project: 'Dastrel' with: [
				spec
					className: #ConfigurationOfDastrel;
					versionString: #'development';
					repository: 'http://smalltalkhub.com/mc/ronsaldo/Dastrel/main' ].
			spec 
				project: 'Lowcode' with: [
				spec
					className: #ConfigurationOfLowcode;
					versionString: #'development';
					repository: 'http://smalltalkhub.com/mc/ronsaldo/Lowcode/main' ].
			spec 
				project: 'WodenMath' with: [
				spec
					className: #ConfigurationOfWodenMath;
					versionString: #'development';
					repository: 'http://smalltalkhub.com/mc/ronsaldo/WodenMath/main' ].
		spec package: #'Woden2-Core' with: [
				spec requires: #('NeoJSON' 'AbstractGPU' 'Dastrel' 'Lowcode' 'WodenMath')].
		spec package: #'Woden2-Athens' with: [
				spec requires: #('Woden2-Core')].
		spec package: #'Woden2-Scene' with: [
				spec requires: #('Woden2-Core')].
		spec package: #'Woden2-Samples' with: [
				spec requires: #('Woden2-Core' 'Woden2-Athens' 'Woden2-Scene')].
		spec group: 'default' with: #('Woden2-Core' 'Woden2-Athens' 'Woden2-Samples')
	]
