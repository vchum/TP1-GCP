# tp1-gcp

ansible
│   └── openlites
│       ├── ansible.cfg
│       ├── FILES.json
│       ├── gcp_compute.yml
│       ├── MANIFEST.json
│       ├── meta
│       │   └── runtime.yml
│       ├── playbook.yml
│       ├── plugins
│       │   └── README.md
│       ├── README.md
│       ├── roles
│       │   ├── mysql
│       │   │   ├── defaults
│       │   │   │   └── main.yml
│       │   │   ├── meta
│       │   │   │   └── main.yml
│       │   │   ├── README.md
│       │   │   └── tasks
│       │   │       └── main.yml
│       │   ├── openlitespeed
│       │   │   ├── defaults
│       │   │   │   └── main.yml
│       │   │   ├── files
│       │   │   │   ├── httpd-config.conf.j2
│       │   │   │   └── vhconf.conf.j2
│       │   │   ├── handlers
│       │   │   │   └── main.yml
│       │   │   ├── meta
│       │   │   │   └── main.yml
│       │   │   ├── README.md
│       │   │   └── tasks
│       │   │       └── main.yml
│       │   ├── php
│       │   │   ├── defaults
│       │   │   │   └── main.yml
│       │   │   ├── meta
│       │   │   │   └── main.yml
│       │   │   ├── README.md
│       │   │   └── tasks
│       │   │       └── main.yml
│       │   └── wordpress
│       │       ├── files
│       │       │   ├── add-lscache.sh.j2
│       │       │   └── wp-config.php.j2
│       │       ├── meta
│       │       │   └── main.yml
│       │       ├── README.md
│       │       └── tasks
│       │           └── main.yml
│       └── vars
│           └── default.yml
├── start.sh
├── terraform
│   ├── gcp-wordpress-mysql
│   │   ├── main.tf
│   │   └── variables.tf
│   ├── main.tf
│   └── outputs.tf
├── tuto gcp - wordpress.txt
└── zone_list

