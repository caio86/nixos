{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.C410l.dev.k8s.enable = lib.mkEnableOption "Kubernetes tooling";

  config = lib.mkIf config.C410l.dev.k8s.enable {
    home.packages = with pkgs; [
      kind
      kompose
      kubectl
      kustomize
      kubernetes-helm
      helmfile
    ];

    programs.k9s.enable = true;
  };
}
