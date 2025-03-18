import gleam/string

pub fn terminal_link(destination: String, title: String) -> String {
  string.concat([
    "\u{1b}]8;;",
    destination,
    "\u{1b}\\",
    title,
    "\u{1b}]8;;\u{1b}\\",
  ])
}

pub fn terminal_link_with_id(
  destination: String,
  title: String,
  id: String,
) -> String {
  string.concat([
    "\u{1b}]8;id=",
    id,
    ";",
    destination,
    "\u{1b}\\",
    title,
    "\u{1b}]8;;\u{1b}\\",
  ])
}
