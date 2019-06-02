# Block User Interface for VCL Projects (Delphi)
This package allows you to lock and unlock the user interface in a simple way.

### Prerequisites
 * [**Boss**](https://github.com/HashLoad/boss) - Dependency Manager for Delphi
 
### Installation: 
```
boss install github.com/viniciussanchez/blockui-vcl
```

### Getting Started
You need to use Vcl.BlockUI.Intf and Vcl.BlockUI 
```
uses Vcl.BlockUI.Intf, Vcl.BlockUI;
```

#### How it works?
```
var
  BlockUI: IBlockUI;
begin
  BlockUI := TBlockUI.Create;
  >> Your code
end;
``` 

In the Create method you can tell which component you want to block:

```
BlockUI := TBlockUI.Create(Your component);
``` 

If not reported any component, the default is Application.MainForm