{ config, pkgs, ... }:

let
  qubesctl = pkgs.writeShellScriptBin "qubesctl" ''
    #!/${pkgs.bash}/bin/bash
    set -e

    AVAILABLE_QUBES=("work" "dev" "net" "untrusted")

    show_help() {
      cat << 'EOF'
    NixQubes Management Utility

    Usage: qubesctl [COMMAND] [QUBE]

    Commands:
      list              List all available qubes
      start <qube>      Start a qube
      stop <qube>       Stop a qube
      status [qube]     Show status of qube(s)
      shell <qube>      Open shell in a running qube
      run <qube> <cmd>  Run command in a qube
      help              Show this help message

    Available Qubes:
      - work       (Work environment with office tools)
      - dev        (Development environment with build tools)
      - net        (Network services qube)
      - untrusted  (Ephemeral untrusted applications)

    Examples:
      qubesctl start work
      qubesctl shell dev
      qubesctl run work firefox
    EOF
    }

    is_valid_qube() {
      local qube=$1
      for q in "''${AVAILABLE_QUBES[@]}"; do
        if [ "$qube" = "$q" ]; then
          return 0
        fi
      done
      return 1
    }

    list_qubes() {
      echo "Available NixQubes:"
      for qube in "''${AVAILABLE_QUBES[@]}"; do
        echo "  - $qube"
      done
    }

    start_qube() {
      local qube=$1
      if ! is_valid_qube "$qube"; then
        echo "Error: Unknown qube '$qube'"
        return 1
      fi
      echo "Starting qube: $qube"
      sudo systemctl start "systemd-nspawn@$qube.service"
      echo "Qube $qube started."
    }

    stop_qube() {
      local qube=$1
      if ! is_valid_qube "$qube"; then
        echo "Error: Unknown qube '$qube'"
        return 1
      fi
      echo "Stopping qube: $qube"
      sudo systemctl stop "systemd-nspawn@$qube.service"
      echo "Qube $qube stopped."
    }

    status_qube() {
      local qube=$1
      if [ -z "$qube" ]; then
        echo "NixQubes Status:"
        for q in "''${AVAILABLE_QUBES[@]}"; do
          if systemctl is-active --quiet "systemd-nspawn@$q.service"; then
            echo "  $q: RUNNING"
          else
            echo "  $q: STOPPED"
          fi
        done
      else
        if ! is_valid_qube "$qube"; then
          echo "Error: Unknown qube '$qube'"
          return 1
        fi
        if systemctl is-active --quiet "systemd-nspawn@$qube.service"; then
          echo "Qube $qube: RUNNING"
        else
          echo "Qube $qube: STOPPED"
        fi
      fi
    }

    shell_qube() {
      local qube=$1
      if ! is_valid_qube "$qube"; then
        echo "Error: Unknown qube '$qube'"
        return 1
      fi
      if ! systemctl is-active --quiet "systemd-nspawn@$qube.service"; then
        echo "Error: Qube $qube is not running"
        return 1
      fi
      echo "Opening shell in qube: $qube"
      sudo machinectl shell "nixos-$qube"
    }

    run_in_qube() {
      local qube=$1
      shift
      local cmd="$@"
      if ! is_valid_qube "$qube"; then
        echo "Error: Unknown qube '$qube'"
        return 1
      fi
      if ! systemctl is-active --quiet "systemd-nspawn@$qube.service"; then
        echo "Error: Qube $qube is not running"
        return 1
      fi
      echo "Running command in qube: $qube"
      sudo machinectl shell "nixos-$qube" -- $cmd
    }

    # Main command parsing
    case "''${1:-help}" in
      list)
        list_qubes
        ;;
      start)
        if [ -z "''${2:-}" ]; then
          echo "Error: qube name required"
          show_help
          exit 1
        fi
        start_qube "$2"
        ;;
      stop)
        if [ -z "''${2:-}" ]; then
          echo "Error: qube name required"
          show_help
          exit 1
        fi
        stop_qube "$2"
        ;;
      status)
        status_qube "''${2:-}"
        ;;
      shell)
        if [ -z "''${2:-}" ]; then
          echo "Error: qube name required"
          show_help
          exit 1
        fi
        shell_qube "$2"
        ;;
      run)
        if [ -z "''${2:-}" ]; then
          echo "Error: qube name required"
          show_help
          exit 1
        fi
        shift
        run_in_qube "$@"
        ;;
      help|--help|-h)
        show_help
        ;;
      *)
        echo "Error: Unknown command '$1'"
        show_help
        exit 1
        ;;
    esac
  '';

in
{

#########################
#NixQubes Manager Setup #
#########################

environment.systemPackages = with pkgs; [
  qubesctl
];

############################
#End NixQubes Manager Setup#
############################

}
