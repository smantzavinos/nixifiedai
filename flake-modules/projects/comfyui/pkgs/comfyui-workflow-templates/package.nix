{
  python3Packages,
  comfyuiNpins,
}:
let
  npin = comfyuiNpins.comfyui-workflow-templates;
  
  # Helper to build workflow template packages
  buildTemplatePackage = {
    pname,
    version,
    hash,
    dependencies ? [],
  }: python3Packages.buildPythonPackage rec {
    inherit pname version;
    
    src = python3Packages.fetchPypi {
      inherit pname version hash;
    };

    format = "pyproject";

    build-system = with python3Packages; [
      setuptools
    ];

    propagatedBuildInputs = dependencies;

    pythonImportsCheck = [
      (builtins.replaceStrings ["-"] ["_"] pname)
    ];

    meta = with python3Packages.lib; {
      description = "ComfyUI workflow templates package";
      homepage = "https://github.com/Comfy-Org/workflow_templates";
      license = licenses.mit;
    };
  };

  core = buildTemplatePackage {
    pname = "comfyui_workflow_templates_core";
    version = "0.3.20";
    hash = "sha256-YtEqM0w8SzoTN92NJBXw8YS48dzqhiikuwEmd8RxF/k=";
  };

  media-api = buildTemplatePackage {
    pname = "comfyui_workflow_templates_media_api";
    version = "0.3.18";
    hash = "sha256-Xc01ClqtjnEBFMiJgreSicLaEOECJZzPh59VWTRWSaI=";
    dependencies = [ core ];
  };

  media-video = buildTemplatePackage {
    pname = "comfyui_workflow_templates_media_video";
    version = "0.3.13";
    hash = "sha256-hQIS00FSvYY+z1oURTfd+/Q6dg6h9+2szIRbl1SobCc=";
    dependencies = [ core media-api ];
  };

  media-image = buildTemplatePackage {
    pname = "comfyui_workflow_templates_media_image";
    version = "0.3.24";
    hash = "sha256-V7sqWCdfqYmQ1Od3hGtnMmEqTZSOt0Kz1BsMhNqE8Vk=";
    dependencies = [ core media-api ];
  };

  media-other = buildTemplatePackage {
    pname = "comfyui_workflow_templates_media_other";
    version = "0.3.34";
    hash = "sha256-HMCTfe1JY4yXr/WjkxwifKz2CcQ3UNSVbS6bdXFXQpY=";
    dependencies = [ core media-api ];
  };
in
python3Packages.callPackage (
  {
    lib,
    buildPythonPackage,
    fetchurl,
  }:
  buildPythonPackage rec {
    pname = "comfyui_workflow_templates";

    inherit (npin) version;
    src = fetchurl {
      inherit (npin) url;
      sha256 = npin.hash;
    };

    format = "pyproject";

    build-system = with python3Packages; [
      setuptools
    ];

    dependencies = [
      core
      media-api
      media-video
      media-image
      media-other
    ];

    pythonImportsCheck = [
      pname
    ];

    meta = with lib; {
      description = "ComfyUI workflow templates available in the app by clicking the Workflow button then the Browse Templates button.";
      homepage = "https://github.com/Comfy-Org/workflow_templates";
      license = licenses.gpl3;
    };
  }
) { }
