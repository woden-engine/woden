baseline
baseline: spec
    <baseline>
    spec
        for: #'common'
        do: [ 
            spec
                package: 'Woden2-Core';
                yourself.
            spec
                group: 'default' with: #('Woden2-Core');
                yourself ]
