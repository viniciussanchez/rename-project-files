# Form to wait for VCL projects (Delphi)
![Delphi Supported Versions](https://img.shields.io/badge/Delphi%20Supported%20Versions-XE3..10.3%20Rio-blue.svg)
![Platforms](https://img.shields.io/badge/Platforms-Win32%20and%20Win64-red.svg)

This component allows you to create forms of wait with progress bar (optional) in a simple way using threads. The use of the thread causes the application not to be locked during the execution of a process.

## Prerequisites
 * `[Optional]` For ease I recommend using the Boss for installation
   * [**Boss**](https://github.com/HashLoad/boss) - Dependency Manager for Delphi
 * [**BlockUI-VCL**](https://github.com/viniciussanchez/blockui-vcl) - Block User Interface for VCL Projects (Delphi)
 
### Installation using Boss (dependency manager for Delphi applications)
```
boss install github.com/viniciussanchez/wait-vcl
```

### Manual Installation
Add the following folders to your project, in *Project > Options > Resource Compiler > Directories and Conditionals > Include file search path*
```
../wait-vcl/src
../wait-vcl/src/view
../wait-vcl/src/providers
```

### Getting Started
You need to use VCL.Wait
```
uses VCL.Wait;
```

#### Form with progress bar
```
var
  Waiting: TWait;
begin
  Waiting := TWait.Create('Aguarde...');
  Waiting.Start(
    procedure
    var
      I: Integer;
    begin
      Waiting.ProgressBar.SetMax(100);
      for I := 1 to 100 do
      begin
        Waiting.SetContent('Aguarde... ' + I.ToString + ' de 100').ProgressBar.Step();
        Sleep(100); // Your code here!!!
      end;
    end);
``` 
![wait-vcl](img/Screenshot_1.png)

You can increment more than one:

```
Waiting.ProgressBar.Step(2);
``` 

The Start function will create a thread to execute the procedure passed as parameter. Within a thread should not be made interactions with the user! If you need to, use a TThread.Synchronize.

#### Form without progress bar
```
begin
  TWait.Create('Aguarde...').Start(
    procedure
    begin
      Sleep(1500); // Your code here!!!
    end);
end;
```
![wait-vcl](img/Screenshot_2.png)
