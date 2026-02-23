{ userSettings, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user.name = "caio86";
      user.email = userSettings.email;
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
