#!/bin/bash
set -e

PROJECT_DIR="/workspaces/material_programacion_avanzada2026/proyectos-teoricos/mini-crud-sql"
DEVCONTAINER_DIR="/workspaces/material_programacion_avanzada2026/.devcontainer/mini-crud-sql"
TOMCAT_HOME="/opt/tomcat10"

echo ""
echo "🚀 Configurando entorno Java Web — mini-crud-sql..."
echo ""

# ── Maven ────────────────────────────────
echo "📦 Instalando Maven..."
sudo apt-get update -qq 2>/dev/null || true
sudo apt-get install -y -qq maven
echo "✅ Maven instalado"

# ── Tomcat 10 ────────────────────────────
echo "📦 Instalando Tomcat 10.1.57..."
sudo mkdir -p "$TOMCAT_HOME"
curl -sL -A "Mozilla/5.0 (X11; Linux x86_64) Codespace-Setup" --fail https://archive.apache.org/dist/tomcat/tomcat-10/v10.1.57/bin/apache-tomcat-10.1.57.tar.gz -o /tmp/tomcat10.tar.gz
sudo tar -xzf /tmp/tomcat10.tar.gz -C "$TOMCAT_HOME" --strip-components=1
sudo chmod +x "$TOMCAT_HOME"/bin/*.sh
sudo chown -R "$(whoami):$(whoami)" "$TOMCAT_HOME"
echo "✅ Tomcat 10 instalado en $TOMCAT_HOME"

# ── MariaDB ──────────────────────────────
echo "📦 Instalando MariaDB..."
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -qq mariadb-server mariadb-client
sudo service mariadb start
echo "✅ MariaDB instalada y en ejecución"

echo "⏳ Esperando que MariaDB esté lista..."
for i in {1..20}; do
  if sudo mysqladmin ping --silent 2>/dev/null; then
    break
  fi
  sleep 2
done

echo "🗄️  Configurando base de datos..."
sudo mysql << 'SQL'
CREATE DATABASE IF NOT EXISTS institutoWeb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_spanish_ci;
CREATE USER IF NOT EXISTS 'java_dev'@'localhost'
  IDENTIFIED BY 'java2026';
GRANT ALL PRIVILEGES ON institutoWeb.* TO 'java_dev'@'localhost';
FLUSH PRIVILEGES;
SQL

mysql -u java_dev -pjava2026 institutoWeb < "$DEVCONTAINER_DIR/db/init.sql"
echo "✅ Base de datos 'institutoWeb' lista"

# ── Filtro para Codespace ──
echo "🔧 Instalando filtro de Codespace..."
mkdir -p "$PROJECT_DIR/src/main/java/com/utu/filter"
cp "$DEVCONTAINER_DIR/CodespaceRedirectFilter.java" "$PROJECT_DIR/src/main/java/com/utu/filter/"
echo "✅ Filtro instalado"

# ── Alias 'run' ──────────────────────────
if ! grep -q "alias run=" ~/.bashrc; then
  cat >> ~/.bashrc << ALIASES

# ── Java Web shortcuts ──────────────────────────────
export JAVA_TOOL_OPTIONS="-Dfile.encoding=UTF-8"
alias run='cd $PROJECT_DIR && mvn clean package cargo:run -Dtomcat.home=$TOMCAT_HOME'
alias mysql-institutoweb='mysql -u java_dev -pjava2026 institutoWeb'
ALIASES
fi

echo "📦 Descargando dependencias Maven..."
cd "$PROJECT_DIR"
mvn dependency:resolve -q 2>/dev/null || true

echo ""
echo "╔══════════════════════════════════════════════════════╗"
echo "║  ✅  Entorno listo — mini-crud-sql                    ║"
echo "╠══════════════════════════════════════════════════════╣"
echo "║  Java 17 + Maven + Tomcat 10.1.57 + MariaDB           ║"
echo "║  DB: institutoWeb  /  Usuario: java_dev / java2026    ║"
echo "╠══════════════════════════════════════════════════════╣"
echo "║  Comandos:                                            ║"
echo "║    run                →  compilar y desplegar         ║"
echo "║    mysql-institutoweb →  abrir consola MariaDB        ║"
echo "╚══════════════════════════════════════════════════════╝"
echo ""
echo "👉 Abrí una terminal NUEVA y ejecutá: run"
echo ""
