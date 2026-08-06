# Sample script for CrashRpt's PowerShell delivery transport (CR_POWERSHELL).
#
# CrashSender.exe launches this script with named arguments describing the crash report;
# here we just log what we received and exit 0 (success). A real script would forward the
# report on however it likes -- e.g. Send-MailMessage, upload to a ticketing system, etc.
param(
    [string]$ZipPath,
    [string]$ReportDir,
    [string]$AppName,
    [string]$AppVersion,
    [string]$CrashGUID,
    [string]$EmailTo,
    [string]$EmailFrom,
    [string]$EmailSubject,
    [string]$EmailBodyFile,
    # Custom argument defined by the app via CR_INSTALL_INFO::pszPowerShellScriptArgs.
    [string]$Environment
)

$logFile = Join-Path $PSScriptRoot "SampleCrashScript.log"

$body = if ($EmailBodyFile -and (Test-Path $EmailBodyFile)) { Get-Content -Raw $EmailBodyFile } else { "" }

@"
[$(Get-Date -Format s)] Crash report received
  AppName      = $AppName
  AppVersion   = $AppVersion
  CrashGUID    = $CrashGUID
  ZipPath      = $ZipPath
  ReportDir    = $ReportDir
  EmailTo      = $EmailTo
  EmailFrom    = $EmailFrom
  EmailSubject = $EmailSubject
  EmailBody    = $body
  Environment  = $Environment
"@ | Out-File -FilePath $logFile -Append -Encoding utf8

exit 0
