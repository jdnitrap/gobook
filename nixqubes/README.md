# NixQubes - Qubes OS-like Security on NixOS

NixQubes implements Qubes OS security principles on NixOS:
- **Isolation by default**: Each "qube" (container) runs in isolation
- **Minimal attack surface**: Containerized applications
- **Network compartmentalization**: Controlled inter-container communication
- **Reproducible security**: Nix ensures identical, auditable configurations

## Architecture

- **Management Qube** (host system) - Central management and coordination
- **AppQubes** (containers) - Isolated application containers
- **NetQube** (container) - Isolated network services
- **DisposableQubes** - Temporary containers for untrusted tasks

## Key Features

1. **Container Isolation** - Using systemd-nspawn for lightweight VMs
2. **Network Isolation** - Firewall rules between containers
3. **Bind Mounts** - Controlled file sharing between domains
4. **Resource Limits** - CPU/Memory constraints per container
5. **Automatic cleanup** - Disposable containers removed after use

## Configuration Files

- `configuration.nix` - Main system configuration
- `qubes-manager.nix` - Management scripts for creating/destroying qubes
- `containers.nix` - Container definitions (AppQubes, NetQube)
- `networking.nix` - Inter-container networking and firewall rules
- `security.nix` - Security hardening options
