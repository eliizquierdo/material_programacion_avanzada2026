#!/bin/bash
set -e

PROJECT_DIR="/workspaces/material_programacion_avanzada2026/ejemplos-resueltos/demo1"
DEVCONTAINER_DIR="/workspaces/material_programacion_avanzada2026/.devcontainer/demo1"
TOMCAT_HOME="/opt/tomcat10"

echo ""
echo "🚀 Configurando entorno Java Web — demo1..."
echo ""

# ── Maven (via apt-get) ────────────────────────────────
echo "📦 Instalando Maven..."
sudo apt-get update -qq 2>/dev/null || true
sudo apt-get install -y -qq maven
echo "✅ Maven instalado"

# ── Tomcat 10 (instalado dentro del contenedor) ────────
echo "📦 Instalando Tomcat 10.1.57..."
sudo mkdir -p "$TOMCAT_HOME"
curl -sL -A "Mozilla/5.0 (X11; Linux x86_64) Codespace-Setup" --fail https://archive.apache.org/dist/tomcat/tomcat-10/v10.1.57/bin/apache-tomcat-10.1.57.tar.gz -o /tmp/tomcat10.tar.gz
sudo tar -xzf /tmp/tomcat10.tar.gz -C "$TOMCAT_HOME" --strip-components=1
sudo chmod +x "$TOMCAT_HOME"/bin/*.sh

# El usuario del Codespace (vscode) necesita ser dueño para poder desplegar .war ahí
sudo chown -R "$(whoami):$(whoami)" "$TOMCAT_HOME"

echo "✅ Tomcat 10 instalado en $TOMCAT_HOME"

# ── Filtro para Codespace (arregla redirects y encoding) ──
echo "🔧 Instalando filtro de Codespace..."
mkdir -p "$PROJECT_DIR/src/main/java/com/utu/filter"
cp "$DEVCONTAINER_DIR/CodespaceRedirectFilter.java" "$PROJECT_DIR/src/main/java/com/utu/filter/"
echo "✅ Filtro instalado"

# ── Alias 'run' (compila y despliega en el Tomcat instalado) ──
if ! grep -q "alias run=" ~/.bashrc; then
  cat >> ~/.bashrc << ALIASES

# ── Java Web shortcuts ──────────────────────────────
export JAVA_TOOL_OPTIONS="-Dfile.encoding=UTF-8"
alias run='cd $PROJECT_DIR && mvn clean package cargo:run -Dtomcat.home=$TOMCAT_HOME'
ALIASES
fi

# ── Pre-descargar dependencias Maven ──────────────────
echo "📦 Descargando dependencias Maven..."
cd "$PROJECT_DIR"
mvn dependency:resolve -q 2>/dev/null || true

# ── Resumen final ─────────────────────────────────────
echo ""
echo "╔══════════════════════════════════════════════════════╗"
echo "║  ✅  Entorno listo — demo1 / Programación Avanzada     ║"
echo "╠══════════════════════════════════════════════════════╣"
echo "║  Java 17 + Maven + Tomcat 10.1.57                     ║"
echo "╠══════════════════════════════════════════════════════╣"
echo "║  Comando:                                             ║"
echo "║    run  →  compilar y desplegar en Tomcat 10          ║"
echo "╚══════════════════════════════════════════════════════╝"
echo ""
echo "👉 Abrí una terminal NUEVA (para que cargue el alias) y ejecutá: run"
echo ""
