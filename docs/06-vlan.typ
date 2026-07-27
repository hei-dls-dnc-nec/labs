#import "/res/helpers.typ" : *

#show: template.with(
  authors: authors,
  task_number: 6,
  serie_title: "VLANs",
  pictures: none, //image("res/Task2.png", width: 75%),
  abstract: [
    #lorem(20)
  ]
)

#todo[
  VLAN for ISMA, WS not accssible by laptop
  - VLAN1: RPI, Wago
  - VLAN2: Wago, ISMA (Modus)

  Depend if possible to configure both eth on Wago. Need to be confirmed by cm0x4d
]
