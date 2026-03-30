### Make sure Nix Daemon is running
`sudo launchctl list | grep nix`

if not try restarting it
`sudo launchctl kickstart -k system/org.nixos.nix-daemon`

then try to rebuild
`sudo darwin-rebuild switch --flake . --impure`


