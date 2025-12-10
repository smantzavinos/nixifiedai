{ python3Packages }:
{
  pname = "ComfyUI-Image-Saver";
  pyproject = false;
  propagatedBuildInputs = with python3Packages; [
    piexif
  ];
}
