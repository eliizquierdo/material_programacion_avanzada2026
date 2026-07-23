<#
.SYNOPSIS
    Prepara el entorno Java Web (JDK 17 + Maven + Tomcat + VS Code) en Windows 10/11, 100% offline.

.DESCRIPTION
    Automatiza los pasos de la guia "Preparacion del entorno Java Web" usando UNICAMENTE
    archivos que ya estan en una carpeta local (USB o red compartida). No descarga nada de internet:
      0. Verifica/instala VS Code y las extensiones del perfil java-utu
      0.5. Aplica la configuracion del perfil (settings), tema oscuro y oculta el icono de Copilot
      1. Copia apache-maven y apache-tomcat a C:\
      2. Instala JDK 17 (Eclipse Temurin) desde el .msi local, en modo silencioso
      3. Configura JAVA_HOME, MAVEN_HOME y actualiza el PATH del sistema
      4. Pregunta donde crear la carpeta vs_workspace y copia demo17 adentro
      5. Opcionalmente compila y despliega el demo en Tomcat via mvn cargo:run

.NOTES
    Requiere ejecutarse como Administrador.
    Compatible con Windows 10 y 11 unicamente (Windows 7 no es compatible con Temurin 17
    ni con las versiones de PowerShell requeridas).

    IMPORTANTE sobre perfiles de VS Code: actualmente no existe forma de importar un
    archivo .code-profile por linea de comandos (confirmado como pedido de funcionalidad
    pendiente en el repositorio de VS Code, issue #181553). Por eso este script no importa
    "java-utu" como un perfil separado; en cambio aplica exactamente la misma configuracion
    y extensiones directamente sobre el perfil "Default", que es el que se abre por defecto
    al iniciar VS Code. El resultado practico es el mismo: queda configurado por defecto.

    Estructura esperada dentro de -RecursosPath:
        apache-maven-3.9.10\
        apache-tomcat-10.1.x\
        *jdk*17*.msi                (instalador Eclipse Temurin JDK 17)
        *VSCodeSetup*.exe o *VSCodeUserSetup*.exe  (System o User Installer de VS Code, cualquiera de los dos)
        extensions\*.vsix           (todas las extensiones del perfil, ver README)
        demo17\                     (proyecto demo ya descomprimido, no un .zip)

.PARAMETER RecursosPath
    Ruta donde esta la carpeta recursos-instalacion (USB o carpeta de red).

.PARAMETER EjecutarDemo
    Si se pasa este switch, al final el script compila y ejecuta el demo
    automaticamente (mvn clean package + mvn cargo:run).

.EXAMPLE
    .\instalar-entorno-java-web.ps1 -RecursosPath "E:\recursos-instalacion"
#>

#Requires -RunAsAdministrator

param(
    [string]$RecursosPath = "D:\recursos-instalacion",   # <-- Editar segun la ubicacion real (USB o red)
    [switch]$EjecutarDemo
)

$ErrorActionPreference = "Stop"

function Write-Paso($mensaje) {
    Write-Host "`n=== $mensaje ===" -ForegroundColor Cyan
}

function Refrescar-Path {
    # Junta el PATH de Machine y de User para la sesion actual, sin reiniciar la consola
    $machinePath = [Environment]::GetEnvironmentVariable("Path", "Machine")
    $userPath    = [Environment]::GetEnvironmentVariable("Path", "User")
    $env:Path = "$machinePath;$userPath"
}

# ---------------------------------------------------------------------------
# Detectar la cuenta con sesion interactiva activa
# ---------------------------------------------------------------------------
# Si el script corre elevado con una cuenta de Administrador distinta a la que
# realmente usa la persona en el dia a dia (comun en salas de informatica),
# $env:APPDATA / $env:USERPROFILE apuntan al perfil del Administrador, no al
# de la cuenta real. Por eso se detecta la cuenta con sesion abierta en la
# pantalla y se usa su perfil explicitamente para settings.json y extensiones.
$usuarioInteractivo = (Get-CimInstance Win32_ComputerSystem).UserName -replace '^.*\\', ''
if ([string]::IsNullOrWhiteSpace($usuarioInteractivo)) {
    Write-Host "No se pudo detectar la cuenta con sesion activa, se usa la cuenta actual ($env:USERNAME)." -ForegroundColor Yellow
    $usuarioInteractivo = $env:USERNAME
}
$perfilInteractivo = Join-Path "C:\Users" $usuarioInteractivo
if (-not (Test-Path $perfilInteractivo)) {
    Write-Host "No se encontro el perfil en '$perfilInteractivo', se usa $env:USERPROFILE en su lugar." -ForegroundColor Yellow
    $perfilInteractivo = $env:USERPROFILE
    $usuarioInteractivo = $env:USERNAME
}
Write-Host "Cuenta detectada para aplicar VS Code / configuracion / vs_workspace: $usuarioInteractivo ($perfilInteractivo)"

$appDataInteractivo = Join-Path $perfilInteractivo "AppData\Roaming"
$vscodeUserDataDir   = Join-Path $appDataInteractivo "Code"
$vscodeExtensionsDir = Join-Path $perfilInteractivo ".vscode\extensions"

# ---------------------------------------------------------------------------
# Verificaciones previas
# ---------------------------------------------------------------------------
Write-Paso "Verificando carpeta de recursos"
if (-not (Test-Path $RecursosPath)) {
    Write-Host "No se encontro la carpeta de recursos en '$RecursosPath'." -ForegroundColor Red
    Write-Host "Editar el parametro -RecursosPath con la ruta correcta (USB o red)." -ForegroundColor Yellow
    exit 1
}

$MavenFolder  = Get-ChildItem -Path $RecursosPath -Directory -Filter "apache-maven-*"  | Select-Object -First 1
$TomcatFolder = Get-ChildItem -Path $RecursosPath -Directory -Filter "apache-tomcat-*" | Select-Object -First 1
$JdkMsi       = Get-ChildItem -Path $RecursosPath -Recurse -File -Filter "*.msi" | Where-Object { $_.Name -match "jdk.*17" } | Select-Object -First 1
$VSCodeExe    = Get-ChildItem -Path $RecursosPath -Recurse -File -Filter "*.exe" | Where-Object { $_.Name -match "VSCode.*Setup" } | Select-Object -First 1
$DemoFolder   = Get-ChildItem -Path $RecursosPath -Directory -Filter "demo17" | Select-Object -First 1
$ExtensionesPath = Join-Path $RecursosPath "extensions"

$faltantes = @()
if (-not $MavenFolder)  { $faltantes += "carpeta apache-maven-*" }
if (-not $TomcatFolder) { $faltantes += "carpeta apache-tomcat-*" }
if (-not $JdkMsi)       { $faltantes += "instalador .msi del JDK 17" }
if (-not $VSCodeExe)    { $faltantes += "instalador VSCodeSetup*.exe" }
if (-not $DemoFolder)   { $faltantes += "carpeta demo17 (ya descomprimida)" }

if ($faltantes.Count -gt 0) {
    Write-Host "Faltan estos archivos/carpetas dentro de '$RecursosPath':" -ForegroundColor Red
    $faltantes | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }
    exit 1
}

# ---------------------------------------------------------------------------
# Paso 0: VS Code y extensiones
# ---------------------------------------------------------------------------
Write-Paso "Paso 0: Verificando VS Code"

if ($VSCodeExe.Name -match "VSCodeUserSetup" -and $usuarioInteractivo -ne $env:USERNAME) {
    Write-Host "ADVERTENCIA: el instalador es 'VSCodeUserSetup' (instalacion por usuario) y el script corre como '$env:USERNAME', distinto de la cuenta con sesion activa ('$usuarioInteractivo')." -ForegroundColor Red
    Write-Host "VS Code va a quedar instalado solo para '$env:USERNAME' y NO va a aparecer para '$usuarioInteractivo'." -ForegroundColor Red
    Write-Host "Se recomienda usar el instalador 'VSCodeSetup' (System Installer, no 'User'), que instala en Archivos de Programa y queda disponible para todas las cuentas." -ForegroundColor Yellow
}

$VersionMinimaVSCode = [version]"1.90.0"
$codeCmd = Get-Command code -ErrorAction SilentlyContinue
$necesitaInstalarVSCode = $true

if ($codeCmd) {
    $versionActualTexto = (& code --version)[0].Trim()
    try {
        if ([version]$versionActualTexto -ge $VersionMinimaVSCode) {
            $necesitaInstalarVSCode = $false
            Write-Host "VS Code $versionActualTexto ya esta instalado (version reciente), se omite instalacion."
        } else {
            Write-Host "VS Code $versionActualTexto esta instalado pero es una version vieja (minimo recomendado: $VersionMinimaVSCode). Se va a actualizar." -ForegroundColor Yellow
        }
    } catch {
        Write-Host "No se pudo interpretar la version de VS Code ('$versionActualTexto'). Se va a intentar actualizar de todas formas." -ForegroundColor Yellow
    }
} else {
    Write-Host "VS Code no esta instalado."
}

if ($necesitaInstalarVSCode) {
    Write-Host "Instalando VS Code desde $($VSCodeExe.FullName) (modo silencioso)..."
    # /MERGETASKS agrega VS Code al PATH del sistema durante la instalacion silenciosa
    # El mismo instalador, corrido sobre una version existente, la actualiza en vez de duplicarla.
    Start-Process -FilePath $VSCodeExe.FullName -ArgumentList "/VERYSILENT /NORESTART /MERGETASKS=!runcode,addtopath" -Wait
    Refrescar-Path
    $codeCmd = Get-Command code -ErrorAction SilentlyContinue
    if (-not $codeCmd) {
        Write-Host "VS Code se instalo pero 'code' no esta disponible en esta sesion. Continuando; las extensiones se instalaran igual si se encuentra el ejecutable." -ForegroundColor Yellow
    } else {
        Write-Host "VS Code instalado/actualizado correctamente ($((& code --version)[0]))."
    }
}

if (Test-Path $ExtensionesPath) {
    Write-Paso "Instalando extensiones de VS Code"
    $vsixFiles = Get-ChildItem -Path $ExtensionesPath -Filter "*.vsix"
    if ($vsixFiles.Count -eq 0) {
        Write-Host "No se encontraron archivos .vsix en $ExtensionesPath" -ForegroundColor Yellow
    }
    foreach ($vsix in $vsixFiles) {
        Write-Host "Instalando extension: $($vsix.Name)"
        # --user-data-dir y --extensions-dir apuntan explicitamente al perfil de la cuenta
        # interactiva detectada, para que la extension quede disponible ahi (y no en el
        # perfil de la cuenta con la que corre este script si son distintas).
        & code --install-extension $vsix.FullName --force --user-data-dir $vscodeUserDataDir --extensions-dir $vscodeExtensionsDir
    }
} else {
    Write-Host "No se encontro la carpeta 'extensions' dentro de $RecursosPath, se omite instalacion de extensiones." -ForegroundColor Yellow
}

# ---------------------------------------------------------------------------
# Paso 0.5: Configuracion del perfil (settings.json), tema oscuro y ocultar Copilot
# ---------------------------------------------------------------------------
Write-Paso "Paso 0.5: Aplicando configuracion de usuario (perfil java-utu)"

$settingsPath = Join-Path $vscodeUserDataDir "User\settings.json"
$settingsDir  = Split-Path $settingsPath -Parent
if (-not (Test-Path $settingsDir)) {
    New-Item -ItemType Directory -Path $settingsDir -Force | Out-Null
}

# Configuraciones tomadas del perfil exportado java-utu.code-profile,
# mas tema oscuro y ocultamiento del icono de Copilot en la barra de titulo.
$nuevasConfiguraciones = [ordered]@{
    "editor.inlineSuggest.enabled"        = $false
    "editor.minimap.enabled"              = $false
    "editor.quickSuggestions"             = @{ other = "off"; comments = "off"; strings = "off" }
    "editor.suggestOnTriggerCharacters"   = $false
    "editor.acceptSuggestionOnEnter"      = "off"
    "github.copilot.enable"               = @{ "*" = $false; "java" = $false }
    "editor.codeLens"                     = $false
    "java.referencesCodeLens.enabled"     = $false
    "editor.inlayHints.enabled"           = "off"
    "java.inlayHints.parameterNames.enabled" = "none"
    "java.debug.settings.console"         = "internalConsole"
    "workbench.colorTheme"                = "Default Dark Modern"
    "chat.commandCenter.enabled"          = $false
}

if (Test-Path $settingsPath) {
    $actual = Get-Content $settingsPath -Raw | ConvertFrom-Json
} else {
    $actual = New-Object PSObject
}

foreach ($key in $nuevasConfiguraciones.Keys) {
    if ($actual.PSObject.Properties.Name -contains $key) {
        $actual.$key = $nuevasConfiguraciones[$key]
    } else {
        $actual | Add-Member -NotePropertyName $key -NotePropertyValue $nuevasConfiguraciones[$key] -Force
    }
}

$actual | ConvertTo-Json -Depth 10 | Set-Content -Path $settingsPath -Encoding UTF8
Write-Host "Configuracion de usuario aplicada en $settingsPath"
Write-Host "Nota: 'chat.commandCenter.enabled=false' oculta el menu de Chat/Copilot de la barra de titulo." -ForegroundColor Yellow
Write-Host "Si el icono de Copilot sigue apareciendo, puede requerir tambien 'Ocultar' manualmente la primera vez (click derecho > Ocultar 'Copilot')." -ForegroundColor Yellow

# ---------------------------------------------------------------------------
# Paso 1: Copiar Maven y Tomcat a C:\
# ---------------------------------------------------------------------------
Write-Paso "Paso 1: Copiando Maven y Tomcat a C:\"
$destMaven  = "C:\$($MavenFolder.Name)"
$destTomcat = "C:\$($TomcatFolder.Name)"

if (-not (Test-Path $destMaven)) {
    Copy-Item -Path $MavenFolder.FullName -Destination "C:\" -Recurse
    Write-Host "Maven copiado a $destMaven"
} else {
    Write-Host "Maven ya existe en $destMaven, se omite copia."
}

if (-not (Test-Path $destTomcat)) {
    Copy-Item -Path $TomcatFolder.FullName -Destination "C:\" -Recurse
    Write-Host "Tomcat copiado a $destTomcat"
} else {
    Write-Host "Tomcat ya existe en $destTomcat, se omite copia."
}

# Corrige el caso de subcarpeta duplicada al descomprimir Tomcat
$binPath = Join-Path $destTomcat "bin"
if (-not (Test-Path $binPath)) {
    $subcarpeta = Get-ChildItem -Path $destTomcat -Directory | Select-Object -First 1
    if ($subcarpeta -and (Test-Path (Join-Path $subcarpeta.FullName "bin"))) {
        Write-Host "Se detecto una subcarpeta duplicada, moviendo contenido un nivel arriba..." -ForegroundColor Yellow
        Get-ChildItem -Path $subcarpeta.FullName | Move-Item -Destination $destTomcat -Force
        Remove-Item -Path $subcarpeta.FullName -Recurse -Force
    }
}

# ---------------------------------------------------------------------------
# Paso 2: Instalar JDK 17 (Eclipse Temurin) desde el .msi local
# ---------------------------------------------------------------------------
Write-Paso "Paso 2: Instalando JDK 17 (Eclipse Temurin) desde archivo local"

$jdkInstalado = Get-ChildItem "C:\Program Files\Eclipse Adoptium" -Directory -Filter "jdk-17*" -ErrorAction SilentlyContinue | Select-Object -First 1

if ($jdkInstalado) {
    Write-Host "JDK 17 ya esta instalado en $($jdkInstalado.FullName), se omite instalacion."
    $javaHomePath = $jdkInstalado.FullName
} else {
    Write-Host "Instalando JDK 17 desde $($JdkMsi.FullName) (modo silencioso)..."
    Start-Process msiexec.exe -ArgumentList "/i `"$($JdkMsi.FullName)`" /quiet /norestart" -Wait

    $jdkInstalado = Get-ChildItem "C:\Program Files\Eclipse Adoptium" -Directory -Filter "jdk-17*" | Select-Object -First 1
    if (-not $jdkInstalado) {
        Write-Host "No se pudo verificar la instalacion del JDK. Revisar manualmente." -ForegroundColor Red
        exit 1
    }
    $javaHomePath = $jdkInstalado.FullName
    Write-Host "JDK 17 instalado en $javaHomePath"
}

# ---------------------------------------------------------------------------
# Paso 3: Configurar variables de entorno del sistema
# ---------------------------------------------------------------------------
Write-Paso "Paso 3: Configurando variables de entorno"

[Environment]::SetEnvironmentVariable("JAVA_HOME", $javaHomePath, "Machine")
[Environment]::SetEnvironmentVariable("MAVEN_HOME", $destMaven, "Machine")
Write-Host "JAVA_HOME = $javaHomePath"
Write-Host "MAVEN_HOME = $destMaven"

$pathActual  = [Environment]::GetEnvironmentVariable("Path", "Machine")
$rutasNuevas = @("%JAVA_HOME%\bin", "%MAVEN_HOME%\bin")
$pathPartes  = $pathActual -split ";"

foreach ($ruta in $rutasNuevas) {
    if ($pathPartes -notcontains $ruta) {
        $pathActual = "$pathActual;$ruta"
        Write-Host "Agregado al PATH: $ruta"
    } else {
        Write-Host "Ya estaba en el PATH: $ruta"
    }
}
[Environment]::SetEnvironmentVariable("Path", $pathActual, "Machine")

# Refresca las variables en la sesion actual para poder verificar sin reiniciar
$env:JAVA_HOME  = $javaHomePath
$env:MAVEN_HOME = $destMaven
Refrescar-Path
$env:Path = "$env:Path;$javaHomePath\bin;$destMaven\bin"

Write-Host "Verificando versiones..."
& java -version
& mvn -version

# ---------------------------------------------------------------------------
# Paso 4: Crear vs_workspace y descomprimir el proyecto demo (ya local)
# ---------------------------------------------------------------------------
Write-Paso "Paso 4: Ubicacion de vs_workspace"

$ubicacionIngresada = Read-Host "¿Donde queres crear la carpeta 'vs_workspace'? (Enter para usar $perfilInteractivo\Documents)"
if ([string]::IsNullOrWhiteSpace($ubicacionIngresada)) {
    $vsWorkspaceBase = Join-Path $perfilInteractivo "Documents"
} else {
    $vsWorkspaceBase = $ubicacionIngresada
}

if (-not (Test-Path $vsWorkspaceBase)) {
    Write-Host "La ruta '$vsWorkspaceBase' no existe. Creandola..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $vsWorkspaceBase -Force | Out-Null
}

$vsWorkspacePath = Join-Path $vsWorkspaceBase "vs_workspace"
if (-not (Test-Path $vsWorkspacePath)) {
    New-Item -ItemType Directory -Path $vsWorkspacePath -Force | Out-Null
}
Write-Host "vs_workspace: $vsWorkspacePath"

Write-Paso "Copiando proyecto demo17"

$demoDest = Join-Path $vsWorkspacePath "demo17"

if (Test-Path $demoDest) {
    Write-Host "Ya existe una carpeta demo17 dentro de vs_workspace, se omite copia."
} else {
    Copy-Item -Path $DemoFolder.FullName -Destination $vsWorkspacePath -Recurse
    Write-Host "Proyecto demo copiado en $demoDest"
}

# ---------------------------------------------------------------------------
# Paso 5 (opcional): Compilar y ejecutar el demo
# ---------------------------------------------------------------------------
if ($EjecutarDemo) {
    Write-Paso "Paso 5: Compilando y ejecutando el proyecto demo"
    Push-Location $demoDest
    & mvn clean package
    Write-Host "Iniciando Tomcat con mvn cargo:run (Ctrl+C para detener)..."
    & mvn cargo:run
    Pop-Location
} else {
    Write-Host "`nPara probar el demo manualmente, ejecutar dentro de $demoDest :" -ForegroundColor Green
    Write-Host "  mvn clean package"
    Write-Host "  mvn cargo:run"
    Write-Host "Luego abrir http://localhost:8080/demo en el navegador"
}

Write-Host "`nEntorno Java Web preparado correctamente (VS Code + JDK 17 + Maven + Tomcat)." -ForegroundColor Green
Write-Host "Si java, mvn o code no se reconocen en una consola nueva, reiniciar la maquina." -ForegroundColor Yellow
