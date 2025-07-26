# FIXME(lib.custom): Add some stuff from hmajid2301/dotfiles/lib/module/default.nix, as simplifies option declaration
{ lib, ... }:
{
  # use path relative to the root of the project
  relativeToRoot = lib.path.append ../.;

  # use path relative to modules/common/optional (where most modules will live)
  relativeToOptionalModules =
    subPath:
    lib.path.append ../. "modules/common/optional${if subPath != "" then "/${subPath}" else ""}";

  scanPaths =
    path:
    builtins.map (f: (path + "/${f}")) (
      builtins.attrNames (
        lib.attrsets.filterAttrs (
          path: _type:
          (_type == "directory") # include directories
          || (
            (path != "default.nix") # ignore default.nix
            && (lib.strings.hasSuffix ".nix" path) # include .nix files
          )
        ) (builtins.readDir path)
      )
    );

  # Import system configurations from unified modules
  # Usage: lib.custom.importSystemModules { path = lib.custom.relativeToOptionalModules ""; modules = ["music" "gaming"]; }
  # Usage: lib.custom.importSystemModules { path = lib.custom.relativeToOptionalModules ""; } # imports all
  importSystemModules =
    {
      path,
      modules ? null,
    }:
    let
      # Get all .nix files and directories in the path (excluding default.nix)
      dirContents = builtins.readDir path;
      allModules = lib.attrNames (
        lib.filterAttrs (
          name: type:
          (type == "regular" && lib.hasSuffix ".nix" name && name != "default.nix") || (type == "directory")
        ) dirContents
      );

      # Filter to requested modules or use all
      selectedModules =
        if modules != null then modules else (map (name: lib.removeSuffix ".nix" name) allModules);

      # Create a wrapper module that extracts systemConfig
      createSystemWrapper =
        moduleName:
        let
          # Try directory with default.nix first, then .nix file
          moduleDir = path + "/${moduleName}";
          moduleFile = path + "/${moduleName}.nix";
          modulePath =
            if builtins.pathExists (moduleDir + "/default.nix") then moduleDir + "/default.nix" else moduleFile;
        in
        {
          lib,
          config,
          pkgs,
          ...
        }:
        let
          moduleContent = import modulePath { inherit lib config pkgs; };
        in
        if lib.isAttrs moduleContent && moduleContent ? systemConfig then
          moduleContent.systemConfig
        else
          moduleContent;
    in
    map createSystemWrapper selectedModules;

  # Import user configurations from unified modules
  # Usage: lib.custom.importUserModules { path = lib.custom.relativeToOptionalModules ""; modules = ["music" "gaming"]; }
  # Usage: lib.custom.importUserModules { path = lib.custom.relativeToOptionalModules ""; } # imports all
  importUserModules =
    {
      path,
      modules ? null,
    }:
    let
      # Get all .nix files and directories in the path (excluding default.nix)
      dirContents = builtins.readDir path;
      allModules = lib.attrNames (
        lib.filterAttrs (
          name: type:
          (type == "regular" && lib.hasSuffix ".nix" name && name != "default.nix") || (type == "directory")
        ) dirContents
      );

      # Filter to requested modules or use all
      selectedModules =
        if modules != null then modules else (map (name: lib.removeSuffix ".nix" name) allModules);

      # Create a wrapper module that extracts userConfig
      createUserWrapper =
        moduleName:
        let
          # Try directory with default.nix first, then .nix file
          moduleDir = path + "/${moduleName}";
          moduleFile = path + "/${moduleName}.nix";
          modulePath =
            if builtins.pathExists (moduleDir + "/default.nix") then moduleDir + "/default.nix" else moduleFile;
        in
        {
          lib,
          config,
          pkgs,
          ...
        }:
        let
          moduleContent = import modulePath { inherit lib config pkgs; };
        in
        if lib.isAttrs moduleContent && moduleContent ? userConfig then
          moduleContent.userConfig
        else
          moduleContent;
    in
    map createUserWrapper selectedModules;

  # Helper to create a unified module more easily
  # Usage: lib.custom.mkUnifiedModule { systemConfig = {...}; userConfig = {...}; }
  mkUnifiedModule =
    {
      systemConfig ? { },
      userConfig ? { },
    }:
    {
      inherit systemConfig userConfig;
    };
}
