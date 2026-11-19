{ osConfig, ... }:
let
  user = osConfig.C410l.user;
in
{
  programs.git = {
    enable = true;
    settings = {
      user.name = user.gitName;
      user.email = user.email;
      init.defaultBranch = "main";
      credential.helper = "cache --timeout=7200";
      core = {
        autocrlf = false;
        eol = "lf";
        editor = "vim";
      };
    };
  };
}
