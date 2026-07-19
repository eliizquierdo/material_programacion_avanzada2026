#!/bin/bash
set -e

PROJECT_DIR="/workspaces/material_programacion_avanzada2026/proyectos-teoricos/mini-crud-alumno-sql"
DEVCONTAINER_DIR="/workspaces/material_programacion_avanzada2026/.devcontainer/mini-crud-alumno-sql"
TOMCAT_HOME="/opt/tomcat10"
CONTEXT_PATH="mini-crud-alumno-sql"

echo ""
echo "🚀 Configurando entorno Java Web — mini-crud-alumno-sql..."
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

echo "🔧 Instalando filtro de Codespace..."
mkdir -p "$PROJECT_DIR/src/main/java/com/utu/filter"
cp "$DEVCONTAINER_DIR/CodespaceRedirectFilter.java" "$PROJECT_DIR/src/main/java/com/utu/filter/"
echo "✅ Filtro instalado"

echo "🔧 Creando comando 'run'..."
sudo tee /usr/local/bin/run > /dev/null << RUNSCRIPT
#!/bin/bash
cd "/workspaces/material_programacion_avanzada2026/proyectos-teoricos/mini-crud-alumno-sql"

if [ -n "\$CODESPACE_NAME" ] && [ -n "\$GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN" ]; then
  URL="https://\${CODESPACE_NAME}-8080.\${GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN}/mini-crud-alumno-sql"
else
  URL="http://localhost:8080/mini-crud-alumno-sql"
fi

echo ""
echo "🌐 Cuando termine de arrancar, la app va a estar en:"
echo "   \$URL"
echo ""

mvn clean package cargo:run -Dtomcat.home="/opt/tomcat10"
RUNSCRIPT
sudo chmod +x /usr/local/bin/run
echo "✅ Comando 'run' listo (funciona en cualquier terminal)"

echo "🔧 Creando comando 'mysql-institutoweb'..."
sudo tee /usr/local/bin/mysql-institutoweb > /dev/null << MYSQLSCRIPT
#!/bin/bash
mysql -u java_dev -pjava2026 institutoWeb
MYSQLSCRIPT
sudo chmod +x /usr/local/bin/mysql-institutoweb
echo "✅ Comando 'mysql-institutoweb' listo"

export JAVA_TOOL_OPTIONS="-Dfile.encoding=UTF-8"
echo 'export JAVA_TOOL_OPTIONS="-Dfile.encoding=UTF-8"' | sudo tee -a /etc/environment > /dev/null

echo "📦 Descargando dependencias Maven..."
cd "/workspaces/material_programacion_avanzada2026/proyectos-teoricos/mini-crud-alumno-sql"
mvn dependency:resolve -q 2>/dev/null || true

echo ""
echo "╔══════════════════════════════════════════════════════╗"
echo "║  ✅  Entorno listo — mini-crud-alumno-sql"
echo "╠══════════════════════════════════════════════════════╣"
echo "║  Java 17 + Maven + Tomcat 10.1.57 + MariaDB           ║"
echo "║  DB: institutoWeb  /  Usuario: java_dev / java2026"
echo "╠══════════════════════════════════════════════════════╣"
echo "║  Comando:                                             ║"
echo "║    run  →  compilar y desplegar (funciona ya mismo)   ║"
echo "║    mysql-institutoweb  →  abrir consola MariaDB"
echo "╚══════════════════════════════════════════════════════╝"
echo ""
echo "👉 Ejecutá: run  (no hace falta abrir una terminal nueva)"
echo ""
