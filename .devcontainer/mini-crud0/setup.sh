#!/bin/bash
set -e

PROJECT_DIR="/workspaces/material_programacion_avanzada2026/proyectos-teoricos/mini-crud0"
DEVCONTAINER_DIR="/workspaces/material_programacion_avanzada2026/.devcontainer/mini-crud0"
TOMCAT_HOME="/opt/tomcat10"

echo ""
echo "🚀 Configurando entorno Java Web — mini-crud0..."
echo ""

echo "📦 Instalando Maven..."
sudo apt-get update -qq 2>/dev/null || true
sudo apt-get install -y -qq maven
echo "✅ Maven instalado"

echo "📦 Instalando Tomcat 10.1.57..."
sudo mkdir -p "$TOMCAT_HOME"

TOMCAT_URL="https://archive.apache.org/dist/tomcat/tomcat-10/v10.1.57/bin/apache-tomcat-10.1.57.tar.gz"
curl -SL -A "Mozilla/5.0 (X11; Linux x86_64) Codespace-Setup" --fail "$TOMCAT_URL" -o /tmp/tomcat10.tar.gz

DOWNLOAD_SIZE=$(stat -c%s /tmp/tomcat10.tar.gz 2>/dev/null || echo 0)
if [ "$DOWNLOAD_SIZE" -lt 1000000 ]; then
  echo "❌ ERROR: la descarga de Tomcat parece incompleta o inválida (tamaño: $DOWNLOAD_SIZE bytes)."
  head -c 500 /tmp/tomcat10.tar.gz
  exit 1
fi

sudo tar -xzf /tmp/tomcat10.tar.gz -C "$TOMCAT_HOME" --strip-components=1
sudo chown -R "$(whoami):$(whoami)" "$TOMCAT_HOME"
sudo chmod +x "$TOMCAT_HOME"/bin/*.sh

if [ ! -f "$TOMCAT_HOME/bin/startup.sh" ]; then
  echo "❌ ERROR: la extracción de Tomcat no generó la estructura esperada en $TOMCAT_HOME"
  ls -la "$TOMCAT_HOME"
  exit 1
fi

echo "✅ Tomcat 10 instalado en $TOMCAT_HOME"

echo "🔧 Instalando filtro de Codespace..."
mkdir -p "$PROJECT_DIR/src/main/java/com/utu/filter"
cp "$DEVCONTAINER_DIR/CodespaceRedirectFilter.java" "$PROJECT_DIR/src/main/java/com/utu/filter/"
echo "✅ Filtro instalado"

if ! grep -q "alias run=" ~/.bashrc; then
  cat >> ~/.bashrc << ALIASES

# ── Java Web shortcuts ──────────────────────────────
export JAVA_TOOL_OPTIONS="-Dfile.encoding=UTF-8"
alias run='cd $PROJECT_DIR && mvn clean package cargo:run -Dtomcat.home=$TOMCAT_HOME'
ALIASES
fi

echo "📦 Descargando dependencias Maven..."
cd "$PROJECT_DIR"
mvn dependency:resolve -q 2>/dev/null || true

echo ""
echo "╔══════════════════════════════════════════════════════╗"
echo "║  ✅  Entorno listo — mini-crud0                       ║"
echo "╠══════════════════════════════════════════════════════╣"
echo "║  Java 17 + Maven + Tomcat 10.1.57                     ║"
echo "╠══════════════════════════════════════════════════════╣"
echo "║  Comando:                                             ║"
echo "║    run  →  compilar y desplegar en Tomcat 10          ║"
echo "╚══════════════════════════════════════════════════════╝"
echo ""
echo "👉 Abrí una terminal NUEVA y ejecutá: run"
echo ""
