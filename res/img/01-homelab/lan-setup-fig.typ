#import "/res/helpers.typ" : *

#let nf(glyph, size: 2.8em) = text(font: "JetBrainsMonoNL NFM", size: size, glyph)
#let dashed = (paint: hei-gray, thickness: 1pt, dash: "dashed")
#let server-app = text(size: 0.8em)[Dashboard/Python \ TCP/8050]
#let client-app = text(size: 0.8em)[Browser]

#let lan-setup-fig = context {
  // Both applications get the width of the wider one, so server and client have the same size
  let app-width = calc.max(measure(server-app).width, measure(client-app).width)
  let app-inset = 5pt
  // Space between the application and the station frame, the ETH box is centred on the frame
  let margin = 18pt
  // Fraction between station and ETH column where the capture arrow drops, half way through the margin
  let half = app-width / 2 + app-inset
  let drop = (half + margin / 2) / (half + margin)
  diagram(
    spacing: (0pt, 8pt),
    node-inset: 6pt,
    node-corner-radius: 6pt,
    node-shape: rect,
    // Stations: a frame enclosing title (row 0), application (row 1) and Wireshark capture point (row 2)
    node((0, 0), inset: 0pt)[#nf([]) *Server*],
    node((6, 0), inset: 0pt)[*Client*],
    node(enclose: ((0, 0), (0, 2)), inset: margin, layer: -2, snap: false, stroke: 1pt + hei-gray),
    node(enclose: ((6, 0), (6, 2)), inset: margin, layer: -2, snap: false, stroke: 1pt + hei-gray),
    node((3, 1), stroke: 1pt + hei-gray)[
      *Edge Router* \
      #text(size: 0.8em)[(switch ports)]
    ],
    // Empty columns to leave room for the cables
    node((2, 1), box(width: 3.5em)),
    node((4, 1), box(width: 3.5em)),
    // Ethernet interface on the edge of each station, selected as Wireshark capture point
    // Edges start at the ETH centre (no snapping) and run under the ETH box
    // The ETH column is twice the margin wide, so the ETH box is centred on the station frame
    ..for (iface, station, inside, app) in ((1, 0, drop, server-app), (5, 6, 6 - drop, client-app)) {(
      node((station, 1), stroke: dashed, inset: app-inset, corner-radius: 4pt, box(width: app-width, app)),
      node((iface, 1), inset: 0pt, box(width: 2 * margin, align(center, box(width: 2em, fill: hei-gray, inset: 4pt, radius: 3pt)[
        #text(size: 0.7em, fill: white)[*ETH*]
      ]))),
      edge((iface, 1), (3, 1), "-", stroke: 1pt + hei-gray, layer: -1, snap-to: (none, auto)),
      edge((iface, 1), (station, 1), "-", stroke: 1pt + hei-gray, layer: -1, snap-to: (none, auto)),
      node((station, 2), stroke: dashed, inset: 4pt, corner-radius: 4pt)[
        #text(size: 0.7em)[#nf("\u{f1673}", size: 1.4em) Wireshark capture]
      ],
      // Starts under the ETH box and drops inside the station frame
      edge((iface, 1), (inside, 1), (inside, 2), (station, 2), "-|>", stroke: dashed, layer: -1, snap-to: (none, auto)),
    )},
  )
}