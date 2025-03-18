import gleam/option.{None, Some}
import gleam/string
import gleeunit
import gleeunit/should
import terminal_link.{TerminalLink}

pub fn main() {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn terminal_link_to_string_test() {
  let destination = "https://mhouge.dk"
  let title = "mhouge.dk"
  let id = "hougesen"

  TerminalLink(destination, title, None)
  |> terminal_link.terminal_link_to_string
  |> should.equal(
    string.concat([
      "\u{1b}]8;;",
      destination,
      "\u{1b}\\",
      title,
      "\u{1b}]8;;\u{1b}\\",
    ]),
  )

  TerminalLink(destination, title, Some(id))
  |> terminal_link.terminal_link_to_string
  |> should.equal(
    string.concat([
      "\u{1b}]8;id=",
      id,
      ";",
      destination,
      "\u{1b}\\",
      title,
      "\u{1b}]8;;\u{1b}\\",
    ]),
  )
}
