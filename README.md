# terminal_link

[![Package Version](https://img.shields.io/hexpm/v/terminal_link)](https://hex.pm/packages/terminal_link)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/terminal_link/)

Easily create clickable terminal hyperlinks in Gleam programs.

`terminal_link` is a loose port of [https://github.com/mainrs/terminal-link-rs](https://github.com/mainrs/terminal-link-rs) and [https://github.com/zkat/supports-hyperlinks](https://github.com/zkat/supports-hyperlinks) to Gleam.

```bash
gleam add terminal_link
```

## Printing a hyperlink to terminal

```gleam
import gleam/io
import gleam/option.{type Option, None}
import terminal_link.{
  TerminalLink, terminal_link_to_string, terminal_supports_links,
}

fn main() {
  let destination = "https://github.com/hougesen"
  let text = "github.com/hougesen"
  let id: Option(String) = None

  let link = TerminalLink(destination, text, id)

  io.println(terminal_link_to_string(link))
}
```

## Validating a terminal supports terminal links

```gleam
import gleam/io
import gleam/option.{None}
import terminal_link.{TerminalLink, terminal_link_to_string}

fn main() {
  let destination = "https://github.com/hougesen"

  let link = TerminalLink(destination, "github.com/hougesen", None)

  case terminal_supports_links() {
    // Print the clickable link if the terminal supports it
    True -> io.println(terminal_link_to_string(link))
    // Or use the full link as fallback
    False -> io.println(destination)
  }
}
```

Further documentation can be found at <https://hexdocs.pm/terminal_link>.

## Development

```bash
# Run the project
gleam run

# Run the tests
gleam test
```
