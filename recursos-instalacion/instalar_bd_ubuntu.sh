#!/bin/bash

# ==========================================
# Script de instalación de entorno MySQL
# + phpMyAdmin + Geany
# Uso educativo - Ubuntu
# ==========================================

echo "======================================"
echo "Instalación de entorno de bases de datos"
echo "======================================"

# ------------------------------------------
# Actualizar repositorios
# ------------------------------------------
echo ""
echo "Actualizando repositorios..."
sudo apt update -y

# ------------------------------------------
# Función para verificar comandos
# ------------------------------------------
existe_comando() {
    command -v "$1" >/dev/null 2>&1
}

# ------------------------------------------
# Instalación de Apache
# ------------------------------------------
echo ""
echo "Verificando Apache..."

if existe_comando apache2; then
    echo "Apache ya está instalado."
else
    echo "Instalando Apache..."
    sudo apt install apache2 -y
fi

echo "Versión de Apache:"
apache2 -v

# ------------------------------------------
# Instalación de MySQL
# ------------------------------------------
echo ""
echo "Verificando MySQL..."

if existe_comando mysql; then
    echo "MySQL ya está instalado."
else
    echo "Instalando MySQL Server..."
    sudo apt install mysql-server -y
fi

echo "Versión de MySQL:"
mysql --version

# ------------------------------------------
# Configurar contraseña de root (admin123)
# SOLO para entorno educativo
# ------------------------------------------
echo ""
echo "Configurando usuario root con contraseña 'admin123'..."

sudo mysql <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'admin123';
FLUSH PRIVILEGES;
EOF

echo "Configuración aplicada."

# ------------------------------------------
# Instalación de PHP
# ------------------------------------------
echo ""
echo "Verificando PHP..."

if existe_comando php; then
    echo "PHP ya está instalado."
else
    echo "Instalando PHP..."
    sudo apt install php libapache2-mod-php php-mysql -y
fi

echo "Versión de PHP:"
php -v

# ------------------------------------------
# Instalación de phpMyAdmin
# ------------------------------------------
echo ""
echo "Verificando phpMyAdmin..."

if [ -d "/usr/share/phpmyadmin" ]; then
    echo "phpMyAdmin ya está instalado."
else
    echo "Instalando phpMyAdmin..."

    sudo DEBIAN_FRONTEND=noninteractive apt install phpmyadmin -y
fi

# ------------------------------------------
# Crear enlace simbólico para Apache
# ------------------------------------------
echo ""
echo "Configurando phpMyAdmin en Apache..."

if [ ! -L /var/www/html/phpmyadmin ]; then
    sudo ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin
fi

# ------------------------------------------
# Reiniciar Apache
# ------------------------------------------
echo ""
echo "Reiniciando Apache..."
sudo systemctl restart apache2

# ------------------------------------------
# Instalación de Geany
# ------------------------------------------
echo ""
echo "Verificando Geany..."

if existe_comando geany; then
    echo "Geany ya está instalado."
else
    echo "Instalando Geany..."
    sudo apt install geany -y
fi

echo "Versión de Geany:"
geany --version

# ------------------------------------------
# Verificación final
# ------------------------------------------
echo ""
echo "======================================"
echo "Verificación final"
echo "======================================"

estado_apache="NO"
estado_mysql="NO"
estado_php="NO"
estado_phpmyadmin="NO"
estado_geany="NO"

if existe_comando apache2; then
    estado_apache="OK"
fi

if existe_comando mysql; then
    estado_mysql="OK"
fi

if existe_comando php; then
    estado_php="OK"
fi

if [ -d "/usr/share/phpmyadmin" ]; then
    estado_phpmyadmin="OK"
fi

if existe_comando geany; then
    estado_geany="OK"
fi

echo "Apache: $estado_apache"
echo "MySQL: $estado_mysql"
echo "PHP: $estado_php"
echo "phpMyAdmin: $estado_phpmyadmin"
echo "Geany: $estado_geany"

echo ""
echo "======================================"
echo "Acceso a phpMyAdmin:"
echo "http://localhost/phpmyadmin"
echo "Usuario: root"
echo "Contraseña: admin123"
echo "======================================"

echo ""

# ------------------------------------------
# Asegurar que phpMyAdmin exija contraseña
# (root ya tiene contraseña configurada)
# ------------------------------------------
echo ""
echo "Verificando configuración de phpMyAdmin..."

CONFIG_FILE="/etc/phpmyadmin/config.inc.php"

# Verificar si la línea ya existe
if grep -q "AllowNoPassword" "$CONFIG_FILE"; then

    # Cambiar true por false
    sudo sed -i "s/AllowNoPassword'] = true/AllowNoPassword'] = false/" "$CONFIG_FILE"

else

    # Agregar configuración antes del cierre ?>
    sudo sed -i "/?>/i \$cfg['Servers'][\$i]['AllowNoPassword'] = false;" "$CONFIG_FILE"

fi

echo "Configuración de phpMyAdmin aplicada."

# ------------------------------------------
# Reiniciar Apache
# ------------------------------------------
echo ""
echo "Reiniciando Apache..."
sudo systemctl restart apache2

# ------------------------------------------
# Verificación final
# ------------------------------------------

echo ""
echo "Probando acceso root a MySQL..."

if mysql -u root -padmin123 -e "SELECT 1;" >/dev/null 2>&1; then
    echo "Acceso root con contraseña 'admin123': OK"
else
    echo "Acceso root con contraseña 'admin123': ERROR"
fi
