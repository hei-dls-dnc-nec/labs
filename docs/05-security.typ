#import "/res/helpers.typ" : *

#show: template.with(
  authors: authors,
  task_number: 5,
  serie_title: "Security",
  pictures: none, //image("res/Task2.png", width: 75%),
  abstract: [
    #lorem(20)
  ]
)
#todo[
  + Run ARP poisonning, WS
  + Add certificat self-signed on wago (command given)
  + Run preconfigurer script to attack modbus TLS, WS hanshake, look the certificate replacement
  + Observe alarme not emitted
  + Add certificat sign by CA (teacher?, pre-signed and distributed?)
  + Observe connexion close if new attack (no attack possible)
]
