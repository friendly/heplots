// Quarto template partial: replaces the default page setup (landscape, small margins, footer)
#set page(
  paper: "us-letter",
  flipped: true,
  margin: (x: 0.3in, top: 0.25in, bottom: 0.35in),
  footer: context [
    #set text(size: 6.5pt, fill: luma(90))
    CC BY-SA 4.0 • Michael Friendly • #link("https://friendly.github.io/heplots")[friendly.github.io/heplots]
    • heplots 1.8.6 • Updated: 2026-10
    #h(1fr) #counter(page).display()
  ],
)
