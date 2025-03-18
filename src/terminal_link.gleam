import gleam/option.{type Option, None, Some}
import gleam/string

pub type TerminalLink {
  TerminalLink(destination: String, title: String, id: Option(String))
}

pub fn terminal_link_to_string(l: TerminalLink) -> String {
  case l.id {
    Some(id) -> {
      string.concat([
        "\u{1b}]8;id=",
        id,
        ";",
        l.destination,
        "\u{1b}\\",
        l.title,
        "\u{1b}]8;;\u{1b}\\",
      ])
    }
    None -> {
      string.concat([
        "\u{1b}]8;;",
        l.destination,
        "\u{1b}\\",
        l.title,
        "\u{1b}]8;;\u{1b}\\",
      ])
    }
  }
}
}
