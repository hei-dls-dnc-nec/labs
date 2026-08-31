#import "/res/helpers.typ" : *

#show: template.with(
  task_number: 3,
  serie_title: "Wifi",
  pictures: none, //image("res/Task2.png", width: 75%),
  abstract: [
    #lorem(20)
  ]
)

// Week 10: 2h


#todo[
  Find something we can do with wifi. Initial idea was: 
  + connection to 23N32x, WS
  + connection to secure-hevs, WS

  goals:
  - see difference home (23N32x), entreprise (secure-hevs)
  - 1 password, specific credentials
  - see certificats

  But not possible because we need a wifi interface on monitor mode

]
