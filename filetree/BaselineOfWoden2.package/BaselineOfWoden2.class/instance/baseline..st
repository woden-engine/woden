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
		spec package: #'Woden2-Core' with: [
				spec requires: #('NeoJSON' 'AbstractGPU' 'Dastrel' 'Lowcode')].
		spec group: 'default' with: #('Woden2-Core')
	]
