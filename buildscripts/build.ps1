$ErrorActionPreference = 'Stop'

try {

	$manifestFilePath = "$env:APPVEYOR_BUILD_FOLDER\PSWebDeploy.psd1"
	$manifestContent = Get-Content -Path $manifestFilePath -Raw

	## Update the module version based on the build version and limit exported functions
	$replacements = @{
		"ModuleVersion = '.*'" = "ModuleVersion = '$env:APPVEYOR_BUILD_VERSION'"
		"FunctionsToExport = '\*'" = "FunctionsToExport = 'Sync-Website','Get-WebsiteFile'"
	}		

	$replacements.GetEnumerator() | foreach {
		$manifestContent = $manifestContent -replace $_.Key,$_.Value
	}

	$manifestContent | Set-Content -Path $manifestFilePath

} catch {
	$host.SetShouldExit($LastExitCode)
}