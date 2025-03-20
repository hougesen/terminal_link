import envoy
import gleam/dict
import gleam/option.{None, Some}
import gleam/string
import gleeunit
import gleeunit/should
import terminal_link.{
  TerminalLink, terminal_link_to_string, terminal_supports_links,
}

pub fn main() {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn terminal_link_to_string_test() {
  let destination = "https://mhouge.dk"
  let text = "mhouge.dk"
  let id = "hougesen"

  TerminalLink(destination, text, None)
  |> terminal_link_to_string
  |> should.equal(
    string.concat([
      "\u{1b}]8;;",
      destination,
      "\u{1b}\\",
      text,
      "\u{1b}]8;;\u{1b}\\",
    ]),
  )

  TerminalLink(destination, text, Some(id))
  |> terminal_link_to_string
  |> should.equal(
    string.concat([
      "\u{1b}]8;id=",
      id,
      ";",
      destination,
      "\u{1b}\\",
      text,
      "\u{1b}]8;;\u{1b}\\",
    ]),
  )
}

pub fn terminal_supports_links_test() {
  dict.each(envoy.all(), fn(k, _v) { envoy.unset(k) })

  // force_hyperlink_enabled
  envoy.set("FORCE_HYPERLINK", "")
  terminal_supports_links() |> should.be_true

  envoy.set("FORCE_HYPERLINK", "0")
  terminal_supports_links() |> should.be_false

  envoy.unset("FORCE_HYPERLINK")
  terminal_supports_links() |> should.be_false

  // is_domterm
  envoy.set("DOMTERM", "")
  terminal_supports_links() |> should.be_true

  envoy.unset("DOMTERM")
  terminal_supports_links() |> should.be_false

  // is_windows_terminal
  envoy.set("WT_SESSION", "")
  terminal_supports_links() |> should.be_true

  envoy.unset("WT_SESSION")
  terminal_supports_links() |> should.be_false

  // check_vte_version
  envoy.set("VTE_VERSION", "5000")
  terminal_supports_links() |> should.be_true

  envoy.set("VTE_VERSION", "")
  terminal_supports_links() |> should.be_false

  envoy.set("VTE_VERSION", "123")
  terminal_supports_links() |> should.be_false

  envoy.unset("VTE_VERSION")
  terminal_supports_links() |> should.be_false

  // check_term_program_env
  envoy.set("TERM_PROGRAM", "Hyper")
  terminal_supports_links() |> should.be_true

  envoy.set("TERM_PROGRAM", "iTerm.app")
  terminal_supports_links() |> should.be_true

  envoy.set("TERM_PROGRAM", "terminology")
  terminal_supports_links() |> should.be_true

  envoy.set("TERM_PROGRAM", "WezTerm")
  terminal_supports_links() |> should.be_true

  envoy.set("TERM_PROGRAM", "vscode")
  terminal_supports_links() |> should.be_true

  envoy.set("TERM_PROGRAM", "ghostty")
  terminal_supports_links() |> should.be_true

  envoy.unset("TERM_PROGRAM")
  terminal_supports_links() |> should.be_false

  // check_term_env
  envoy.set("TERM", "xterm-kitty")
  terminal_supports_links() |> should.be_true

  envoy.set("TERM", "alacritty")
  terminal_supports_links() |> should.be_true

  envoy.set("TERM", "alacritty-direct")
  terminal_supports_links() |> should.be_true

  envoy.unset("TERM")
  terminal_supports_links() |> should.be_false

  // check_colorterm_env
  envoy.set("COLORTERM", "xfce4-terminal")
  terminal_supports_links() |> should.be_true

  envoy.unset("COLORTERM")
  terminal_supports_links() |> should.be_false

  // konsole_version_is_set
  envoy.set("KONSOLE_VERSION", "")
  terminal_supports_links() |> should.be_true

  envoy.unset("KONSOLE_VERSION")
  terminal_supports_links() |> should.be_false
}
