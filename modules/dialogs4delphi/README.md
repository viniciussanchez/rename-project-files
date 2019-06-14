# Dialog Boxes for Delphi Projects
![Delphi Supported Versions](https://img.shields.io/badge/Delphi%20Supported%20Versions-XE3..10.3%20Rio-blue.svg)
![Platforms](https://img.shields.io/badge/Platforms-Win32%20and%20Win64-red.svg)
![Compatibility](https://img.shields.io/badge/Compatibility-VCL%20and%20uniGUI-brightgreen.svg)

This component is a dialog factory for Delphi projects (VCL and uniGUI). It uses native resources to create dialogues. Uses native build directives to identify the project type (VCL / uniGUI).

Why use? Allows use the same code for desktop application (VCL) and web applications (uniGUI).

## Prerequisites
 * `[Optional]` For ease I recommend using the Boss for installation
   * [**Boss**](https://github.com/HashLoad/boss) - Dependency Manager for Delphi
 * For VCL projects you need
   * [**BlockUI-VCL**](https://github.com/viniciussanchez/blockui-vcl) - Block User Interface for VCL Projects (Delphi)
 * For uniGUI projects you need to install
   * [**uniGUI**](http://www.unigui.com/) - Web Application Framework for Embarcadero Delphi
   * Set in *Project > Options > Delphi Compiler > Conditional defines* the compilation directive for your application:
     * `UNIGUI_VCL` for stand alone application
     * `UNIGUI_SERVICE` for windows service application
     * `UNIGUI_ISAPI` for ISAPI library     
 
### Installation using Boss (dependency manager for Delphi applications)
```
boss install github.com/viniciussanchez/dialogs4delphi
```

### Manual Installation
Add the following folders to your project, in *Project > Options > Resource Compiler > Directories and Conditionals > Include file search path*
```
../dialogs4delphi/src
../dialogs4delphi/src/modal
../dialogs4delphi/src/input
```

### Getting Started
You need to use Dialogs4D.Factory
```
uses Dialogs4D.Factory;
```

#### Success dialog box
```
begin
  TDialogs.Info('Information');
end;
``` 
`[VCL]`

![dialogs4delphi](img/Screenshot_1.png) 

`[uniGUI]`

![dialogs4delphi](img/Screenshot_uniGUI_1.png)

#### Error dialog box
```
begin
  TDialogs.Error('Error');
end;
``` 
`[VCL]`

![dialogs4delphi](img/Screenshot_3.png)

`[uniGUI]`

![dialogs4delphi](img/Screenshot_uniGUI_2.png)

#### Warning dialog box
```
begin
  TDialogs.Warning('Warning');
end;
``` 
`[VCL]`

![dialogs4delphi](img/Screenshot_2.png)

`[uniGUI]`

![dialogs4delphi](img/Screenshot_uniGUI_3.png)

#### Confirm dialog box
```
begin
  if TDialogs.Confirm('Warning') then
    Continue;
end;
``` 
`[VCL]`

![dialogs4delphi](img/Screenshot_4.png)

`[uniGUI]`

![dialogs4delphi](img/Screenshot_uniGUI_4.png)

#### Input dialog box
```
var
  Name: string;
begin
  Name := TDialogs.Input('Your name:', 'Default value');
end;
``` 
`[VCL]`

![dialogs4delphi](img/Screenshot_5.png)

`[uniGUI]`

![dialogs4delphi](img/Screenshot_uniGUI_5.png)
