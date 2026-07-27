#import "/res/helpers.typ" : *

#show: template.with(
  authors: authors,
  task_number: 1,
  serie_title: "Basic network",
  pictures: none, //image("res/Task2.png", width: 75%),
  abstract: [
    #lorem(20)
  ]
)


= Open repo on PyCharm
#todo[
  [R]
]

= webpage on laptop (python script), localhost, WS 
#todo[
  [R]
  - explain interface loopback for localhost
]


= laptop dhcp on IIoT Rack, find ip in laptop and router config
#todo[
  [R]
  - get ip with ip/if config and note eth interface
  - connect to router and note both laptop are connected
  - note lease time?
]

= 1 student client, 1 student server, both WS
#todo[
  [R]
  - Explain to switch to eth interface
  - warning anti-virus
]

= something with fix ip by mac for RPI, with short lease or small range, student should increase range / fix ip with static DHCP for RPI MAC
#todo[
  [R]
]

= DNS for webpage on RPI
#todo[
  [R]
]
