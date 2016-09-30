class parsoid {
    include apt
    include nginx

    apt::source { 'parsoid':
        location => 'http://releases.wikimedia.org/debian',
        release  => 'jessie-mediawiki',
        repos    => 'main',
        key      => {
            'id'     => 'BE0C9EFB1A948BF3C8157E8B811780265C927F7C',
            'server' => 'hkp://keyserver.ubuntu.com:80',
        },
    }

    ssl::cert { 'wildcard.miraheze.org': }

    file { '/etc/nginx/sites-enabled/default':
        ensure  => absent,
        require => Package['nginx'],
    }

    file { '/etc/nginx/nginx.conf':
        ensure  => present,
        content => template('parsoid/nginx.conf.erb'),
        require => Package['nginx'],
    }

    nginx::site { 'parsoid':
        ensure  => present,
        source  => 'puppet:///modules/parsoid/nginx/parsoid',
    }

    package { 'parsoid':
        ensure  => present,
        require => Apt::Source['parsoid'],
    }

    service { 'parsoid':
        ensure    => running,
        require   => Package['parsoid'],
        subscribe => File['/etc/mediawiki/parsoid/settings.js'],
    }

    # The name of the wiki (or the URL in form <wikiname>.miraheze.org. DO NOT INCLUDE WIKI.
    $wikis = [
                '3dicxyz',
                '8station',
                'aacenterpriselearning',
                'adnovum',
                'aescapes',
                'ageofimperialism',
                'ageofimperialists',
                'air',
                'aktpos',
                'alanpedia',
                'algopedia',
                'allbanks2',
                'alwiki',
                'applebranch',
                'arabudland',
                'aryaman',
                'ayrshire',
                'atheneum',
                'augustinianum',
                'aurcusonline',
                'betapurple',
                'bgo',
                'biblicalwiki',
                'biblio',
                'bmed',
                'braindump',
                'casuarina',
                'cbmedia',
                'cec',
                'chandrusweths',
                'christipedia',
                'ciso',
                'civitas',
                'clementsworldbuilding',
                'clicordi',
                'cnv',
                'cssandjsschoolboard',
                'cvsmb',
                'dalar',
                'datachron',
                'detlefs',
                'development',
                'dicfic',
                'dish',
                'dmw',
                'doin',
                'drunkenpeasantswiki',
                'dts',
                'elainarmua',
                'ernaehrungsrathh',
                'essway',
                'etpo',
                'eva',
                'extload',
                'ezdmf',
                'fbwiki',
                'fishpercolator',
                'foodsharinghamburg',
                'frontdesks',
                'games',
                'geirpedia',
                'gen',
                'gnc',
                'grandtheftwiki',
                'hftqms',
                'hobbies',
                'hshsinfoportal',
                'hsooden',
                'hytec',
                'idtest',
                'ilearnthings',
                'imsts',
                'inazumaeleven',
                'irc',
                'islamwissenschaft',
                'izanagi',
                'janesskillspack',
                'justinbieber',
                'kassai',
                'kwiki',
                'lancemedical',
                'lbsges',
                'lclwiki',
                'lingnlang',
                'littlebigplanet',
                'lizard',
                'lovelivewiki',
                'luckandlogic',
                'lunfeng',
                'maiasongcontest',
                'marcoschriek',
                'mecanon',
                'menufeed',
                'meregos',
                'meta',
                'musicarchive',
                'musiclibrary',
                'musictabs',
                'mydegree',
                'ndtest',
                'neuronpedia',
                'newarkmanor',
                'newknowledge',
                'newtrend',
                'nidda23',
                'nwp',
                'ofthevampire',
                'oncproject',
                'openconstitution',
                'opengovpioneers',
                'panorama',
                'paodeaoda',
                'partup',
                'pbm',
                'pflanzen',
                'priyo',
                'pq',
                'pso2',
                'qwerty',
                'rawdata',
                'recherchesdocumentaires',
                'ric',
                'robloxscripters',
                'rpcharacters',
                'safiria',
                'secondcircle',
                'seldir',
                'seton',
                'shopping',
                'simonjon',
                'sirikot',
                'sjuhabitat',
                'skyfireflyff',
                'snowthegame',
                'soshomophobie',
                'starsetonline',
                'stellachronica',
                'studynotekr',
                'taylor',
                'tcc6640',
                'techeducation',
                'teleswiki',
                'thefosters',
                'thehushhushsaga',
                'theworld',
                'tme',
                'tochki',
                'torejorg',
                'touhouengine',
                'unikum',
                'urho3d',
                'videogames',
                'vrgo',
                'walthamstowlabour',
                'webflow',
                'wikibooks',
                'wikicervantes',
                'wikihoyo',
                'worldbuilding',
                'wthsapgov',
                'xdjibi',
                'yacresources',
                'yggdrasilwiki',
                'yourosongcontest',
                'youtube',
    ]

    file { '/etc/mediawiki/parsoid/settings.js':
        ensure  => present,
        content => template('parsoid/settings.js'),
    }
}
