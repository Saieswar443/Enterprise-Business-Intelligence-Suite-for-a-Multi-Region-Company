// Create these as Power Query PARAMETERS (Home > Manage Parameters > New Parameter, Type = Text).
// Use DataFolder for the local flavour, BaseUrl for the web flavour.

// Parameter: DataFolder   (note the trailing backslash)
"C:\bi-suite\data\warehouse\" meta [IsParameterQuery = true, Type = "Text", IsParameterQueryRequired = true]

// Parameter: BaseUrl      (note the trailing slash; replace <user>/<repo>/<branch> with yours)
"https://raw.githubusercontent.com/<user>/<repo>/main/DA-01/data/warehouse/" meta [IsParameterQuery = true, Type = "Text", IsParameterQueryRequired = true]
