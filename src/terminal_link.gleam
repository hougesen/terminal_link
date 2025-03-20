import envoy
import gleam/int
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/string

pub type TerminalLink {
  TerminalLink(destination: String, text: String, id: Option(String))
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
        l.text,
        "\u{1b}]8;;\u{1b}\\",
      ])
    }
    None -> {
      string.concat([
        "\u{1b}]8;;",
        l.destination,
        "\u{1b}\\",
        l.text,
        "\u{1b}]8;;\u{1b}\\",
      ])
    }
  }
}

fn force_hyperlink_enabled() -> Option(Bool) {
  case envoy.get("FORCE_HYPERLINK") {
    Ok("0") -> Some(False)
    Ok(_) -> Some(True)
    Error(_) -> None
  }
}

fn is_domterm() -> Bool {
  envoy.get("DOMTERM")
  |> result.is_ok
}

fn is_windows_terminal() -> Bool {
  envoy.get("WT_SESSION")
  |> result.is_ok
}

fn check_vte_version() -> Bool {
  case envoy.get("VTE_VERSION") {
    Ok(value) -> {
      int.parse(value)
      |> result.map(fn(version) { version >= 5000 })
      |> result.unwrap(False)
    }
    Error(_) -> False
  }
}

fn check_term_program_env() -> Bool {
  case envoy.get("TERM_PROGRAM") {
    Ok("Hyper") -> True
    Ok("iTerm.app") -> True
    Ok("terminology") -> True
    Ok("WezTerm") -> True
    Ok("vscode") -> True
    Ok("ghostty") -> True
    Ok(_) -> False
    Error(_) -> False
  }
}

fn check_term_env() -> Bool {
  case envoy.get("TERM") {
    Ok("xterm-kitty") -> True
    Ok("alacritty") -> True
    Ok("alacritty-direct") -> True
    Ok(_) -> False
    Error(_) -> False
  }
}

fn check_colorterm_env() -> Bool {
  case envoy.get("COLORTERM") {
    Ok("xfce4-terminal") -> True
    Ok(_) -> False
    Error(_) -> False
  }
}

fn konsole_version_is_set() -> Bool {
  envoy.get("KONSOLE_VERSION")
  |> result.is_ok
}

/// Check if the terminal emulator supports clickable hyperlinks  
pub fn terminal_supports_links() -> Bool {
  case force_hyperlink_enabled() {
    Some(value) -> value
    None -> {
      is_domterm()
      || check_vte_version()
      || check_term_program_env()
      || check_term_env()
      || check_colorterm_env()
      || is_windows_terminal()
      || konsole_version_is_set()
    }
  }
}
