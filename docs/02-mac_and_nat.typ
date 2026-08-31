#import "/res/helpers.typ" : *

#show: template.with(
  authors: authors,
  task_number: 2,
  serie_title: "MAC and NAT",
  pictures: none, //image("res/Task2.png", width: 75%),
  abstract: [
    #lorem(20)
  ]
)

// Week 9: 2h

#todo[
  [R]
  + RPI webpage accesible trough NAT (read only webpage)
  + MAC / ARP, WS
]
