#import "@preview/grape-suite:3.1.0": exercise
#import exercise: project, task, subtask
#import "@preview/codelst:2.0.2": sourcecode, code-frame
#import "@preview/cheq:0.4.0": checklist
#import "metadatas.typ": *

#let hei-magenta = rgb(207, 20, 103)
#let hei-gray = rgb(127, 127, 127)
#let bonus = task.with(extra: true, numbering-format: (..n) => "")
#let task = task.with(numbering-format: (..n) => numbering("1", ..n))
#let subtask = subtask.with(markers: ("1.", "1."))
#let important = box.with(
  stroke: hei-magenta,
  fill: hei-magenta.lighten(95%),
  inset: 8pt,
  radius: 8pt
)

#let sourcefile(filename, lang: "go") = {
  set text(
    font: "Jetbrains Mono",
    size: 7pt,
    weight: "light",
    fill: hei-gray
  )

  let content = read(filename)
  sourcecode(raw(lang: lang, content))
}

#let shell(content) = {
  set text(
    font: "Jetbrains Mono",
    weight: "regular",
    fill: white
  )

  sourcecode(
    content,
    lang: "shell",
    numbering: none,
    frame: code-frame.with(
      stroke: hei-gray,
      fill: hei-gray.darken(50%)
    )
  )
}

#let template(
  task_number: none,
  serie_title: none,
  authors: authors,
  pictures: [],
  abstract: [],
  body,
) = {
  let title
  let document_title
  if task_number == none {
    title = serie_title
    document_title = [*#course-name-short - #serie_title*]
  } else {
    title = "Task " + str(task_number) + " - " + serie_title
    document_title = [*#course-name-short - Task #str(task_number) - #serie_title*]

  }
  
  show: checklist

  show raw.where(block:false): it=>box(
    fill: gray.lighten(30%),
    inset: (x: 3pt, y: 0pt),
    outset: (y: 3pt),
    radius: 2pt,
    text(
      fill: black,
      font: "JetBrainsMonoNL NFM",
      it
    )
  )
  
  show: project.with(
    no: task_number,
    type: [Series],
    task-type: [Task],
    extra-task-type: [Bonus Task],
    show-outline: true,
    header-left: none,

    title: [
      #text(font: "Avenir Next", weight: "extralight", fill: hei-gray, 16pt, [#course-name-long])

      #text(font: "Avenir Next", fill: hei-magenta, 32pt, title)
      #align(center)[
        #pictures
      ]
    ],
    document-title: [
      #text(fill: hei-magenta, document_title)
    ],

    author: emph(authors),
    abstract: abstract,
  )
  show link: it => text(fill:rgb("#0095d8").darken(20%), it)
  
  pagebreak()

  body
}

