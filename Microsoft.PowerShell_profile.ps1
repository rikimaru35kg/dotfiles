Set-Alias ll Get-ChildItem
Set-Alias grep Select-String
function touch { New-Item $args -ItemType File }
function gs { git status }
function ga { git add -A }
function gc { git commit -m $args }
function gp { git push }
function which { Get-Command $args }
function tree { Get-ChildItem -Recurse }
function find {
  param([string]$path = ".",
        [string]$name = "*")
  Get-ChildItem -Path $path -Recurse -Filter $name
}
function su {Start-Process powershell -Verb RunAs }
