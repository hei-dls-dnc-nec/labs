// PDF feedback of one student, laid out from the data written by `grade render`
// (<output>/feedback-data/<Last>_<First>_<handle>.json, see the gitlab.com/hei-tools/grader README).
// It is selected by feedback_template in the year config.
//
//   typst watch --root .. template/template-feedback-grape.typ \
//     --input data=/Admin/2026/grading/RPC/feedback-data/<file>.json   (from the repository root)
//
// --root must contain both this repository and the data. Without --input data, the template shows
// template/feedback-sample.json (`typst watch --root . template/template-feedback-grape.typ`). Course
// title, professors and logo come from metadata.typ.
#import "@preview/grape-suite:3.1.0": exercise
#import exercise: project
#import "@preview/cmarker:0.1.6"
#import "metadatas.typ": *

#let hei-magenta = rgb(207, 20, 103)
#let hei-gray = rgb(127, 127, 127)
#let important = block.with(stroke: hei-magenta, fill: hei-magenta.lighten(95%), inset: 8pt, radius: 8pt, width: 100%)
#let note = block.with(stroke: hei-gray, fill: hei-gray.lighten(92%), inset: 8pt, radius: 8pt, width: 100%)

#let d = json(sys.inputs.at("data", default: "feedback-sample.json"))
#let exercise-title = d.at("title", default: d.exercise)
#let md(s) = cmarker.render(s)
// reviewed adds "(reviewed by …)" below a Markdown text
#let reviewed(body, by) = if by == "" { body } else [#body #emph[(reviewed by #by)]]
#let course = course-name-long
// doc.logo.main is relative to the repository root; --root may be a parent of it
#let logo = none //".." + doc.logo.main

#show: project.with(
  type: [Feedback],
  show-outline: false,
  //header-left: [#image(logo, width: 24pt)],
  title: [
    #text(font: "Avenir Next", weight: "extralight", fill: hei-gray, 16pt, course)

    #text(font: "Avenir Next", fill: hei-magenta, 32pt, [#exercise-title Feedback])

    #text(font: "Avenir Next", 16pt, d.student.display)
    #let partners = d.at("partners", default: ()).map(p => p.display)
    #if partners.len() > 0 [

      #text(font: "Avenir Next", weight: "extralight", fill: hei-gray, 12pt)[in collaboration with #partners.join(", ", last: " and ")]
    ]
  ],
  document-title: text(fill: hei-magenta, [*#course-name-short - #exercise-title Feedback*]),
  author: emph(authors),
  semester: str(d.year),
)

#set heading(numbering: none)
#show link: it => text(fill: rgb("#0095d8").darken(20%), it)
#show raw.where(block: false): it => box(
  fill: gray.lighten(70%), inset: (x: 2pt, y: 0pt), outset: (y: 2pt), radius: 2pt,
  text(font: "JetBrains Mono", size: 0.9em, it),
)
#show table: set par(justify: false)
#set table(stroke: (x, y) => (top: if y > 0 { 0.5pt + hei-gray.lighten(50%) }), inset: 5pt)
#show table.cell.where(y: 0): set text(weight: "bold", fill: hei-gray)

// ---- grade ----

// points below the maximum are shown in magenta (task section)
#let pts(points, max) = if float(points) < max { text(fill: hei-magenta, points) } else { points }

#let grade-box(body) = block(width: 100%, inset: 12pt, radius: 8pt, fill: hei-magenta.lighten(92%), body)

#if d.no_submission {
  grade-box[
    #text(28pt, weight: "bold", fill: hei-magenta, d.grade) #h(6pt) #text(14pt)[no submission]
  ]
  [No repository was found for this exercise, so it is graded with the minimum grade.]
} else {
  grade-box(grid(columns: (auto, 1fr), gutter: 16pt, align: horizon,
    text(28pt, weight: "bold", fill: hei-magenta, d.grade),
    [
      *#d.total / #d.max points* \
      #d.kinds.filter(k => k.max > 0).map(k => [#k.name #k.points/#k.max]).join([ #sym.dot.c ])
    ],
  ))
  text(size: 0.85em, fill: hei-gray, d.formula)

  if "cap" in d { important(md(d.cap)) }
  note(md(d.note))

  if d.rules.len() > 0 [The grading rules are listed at the end of this report (#link(<grading-rules>)[Grading rules]).]

  table(
    columns: (1fr, auto, auto),
    align: (left, right, right),
    [Task], [Points], [Max],
    ..d.tasks.map(t => (if t.kind == "bonus" [#t.name (bonus)] else [#t.name], t.points, str(t.max))).flatten(),
    [*Total*], [*#d.total*], [*#d.max*],
    [*Grade*], [*#d.grade*], [*#d.grade_max*],
  )
  if "would" in d [
    #important[Had all tags been set in time, the tasks would have scored *#d.would.points/#d.would.max* (grade #d.would.grade).]
  ]

  if d.notes != "" [
    == Notes
    #md(d.notes)
  ]

  // ---- tasks ----

  pagebreak()

  let section = none
  for t in d.tasks {
    let name = if t.kind == "bonus" [#t.name (bonus)] else [#t.name]
    // a bonus task among the tasks stays in the Tasks section
    if t.kind == "task" or (t.kind == "bonus" and section == "task") {
      if section != "task" [== Tasks]
      section = "task"
      [=== #name #h(1fr) #text(weight: "regular", [#pts(t.points, t.max)/#t.max])]
    } else {
      section = t.kind
      [== #name #h(1fr) #text(weight: "regular", [#pts(t.points, t.max)/#t.max])]
    }
    if t.status != "" or "commit_url" in t {
      block[
        #if t.status != "" { md(t.status) }
        #if "commit_url" in t [#text(size: 0.85em)[Browse the graded code: #link(t.commit_url)[commit #raw(t.commit)]]]
      ]
    }
    if "comment" in t {
      // one level below the task heading
      heading(level: if t.kind == "task" { 4 } else { 3 }, [Comments and Remarks])
      reviewed(md(t.comment), t.at("comment_by", default: ""))
    }
    let cols = if t.show_would { (2fr, auto, auto, auto, 3fr) } else { (2fr, auto, auto, 3fr) }
    let head = if t.show_would { ([Criterion], [Points], [Would have], [Max], [Note]) } else { ([Criterion], [Points], [Max], [Note]) }
    table(
      columns: cols,
      align: (x, y) => if x > 0 and x < cols.len() - 1 { right } else { left },
      ..head,
      ..t.criteria.map(c => {
        let row = (md(c.text), pts(c.points, c.max))
        if t.show_would { row.push([#c.would]) }
        row + ([#c.max], text(size: 0.9em, reviewed(md(c.note), c.at("by", default: ""))))
      }).flatten(),
    )
    if "penalty" in t { md(t.penalty) }
  }
}

#if d.rules.len() > 0 [
  == Grading rules <grading-rules>
  #for r in d.rules [- #md(r)]
]
