#import "/res/helpers.typ" : *

#show: template.with(
  authors: authors,
  task_number: 4,
  serie_title: "Modbus & MQTT",
  pictures: none, //image("res/Task2.png", width: 75%),
  abstract: [
    #lorem(20)
  ]
)

// Week 11: 1h +
// Week 12: 3h

#todo[
  + Modbus to read bottom flow of source 2 and quality of source 2
  + Modbus to write the bottom valve of source 2
  + MQTT to read top flow of source 2
  + MQTT to write top valve of source 2
  + Close both valve if quality under treshold
  + Send modbus alarm to general controller if delta between both flow higher than treshold
]
