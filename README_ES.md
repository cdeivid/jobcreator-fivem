# Job Creator for FiveM

![Version](https://img.shields.io/badge/version-1.0.0-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![FiveM](https://img.shields.io/badge/FiveM-Compatible-orange)

Un sistema completo de creación y gestión de trabajos para servidores FiveM, inspirado en Jobs Creator de Jaksam. Compatible con ESX y QBCore.

## 🌟 Características

### ✨ Facilidad de Instalación
- **Configuración mínima** requerida
- **Instalación drag & drop** - simplemente arrastra y suelta
- Configuración simple en `server.cfg`:
  ```
  ensure jobcreator
  ```

### 🌍 Soporte Multilingüe
Compatible con 12 idiomas:
- 🇬🇧 Inglés (English)
- 🇮🇹 Italiano (Italian)
- 🇩🇪 Alemán (German)
- 🇬🇷 Griego (Greek)
- 🇧🇦 Bosnio (Bosnian)
- 🇵🇹 Portugués (Portuguese)
- 🇪🇸 Español (Spanish)
- 🇫🇷 Francés (French)
- 🇸🇰 Eslovaco (Slovak)
- 🇩🇰 Danés (Danish)
- 🇨🇿 Checo (Czech)
- 🇵🇱 Polaco (Polish)

### 💼 Gestión de Trabajos
- ✅ Crear trabajos rápidamente
- ✅ Editar trabajos en tiempo real
- ✅ Eliminar trabajos sin errores
- ✅ Sistema de whitelist (lista blanca)
- ✅ Auto-desempleo cuando se elimina un trabajo
- ✅ Sincronización automática de IDs

### 📊 Gestión de Rangos/Grados
- Crear rangos con permisos personalizados
- Editar rangos en vivo
- Eliminar rangos de forma segura
- Configurar salarios por rango

### 🌐 Nexus (Compartir Trabajos)
- Compartir trabajos entre servidores
- Importar trabajos fácilmente
- Comunidad de trabajos compartidos

### 🎯 Marcadores Interactivos
Tipos de marcadores disponibles:
- 💰 Depósitos
- 🔫 Arsenales
- 🔒 Cajas fuertes
- 🚗 Garajes públicos/privados
- 🏪 Tiendas de trabajo
- 🔨 Mesas de crafteo
- 📍 Teleportadores
- 🏪 Mercados
- 🌾 Puntos de cosecha
- ⚙️ Puntos de procesamiento
- 🛡️ Armerías mejoradas

Características de marcadores:
- Texto 3D personalizable
- Colores personalizados
- Compatible con OX Target
- Compatible con QB Target

### 🎮 Acciones de Trabajo
- 👮 Esposar/Liberar jugadores
- 💵 Cobrar facturas
- 🔍 Rebuscar/Registrar jugadores
- 🔓 Forzar cerraduras de vehículos
- 🧽 Limpiar vehículos
- 🔧 Reparar vehículos
- 🚓 Embargar vehículos
- 📋 Verificar dueños de vehículos
- 🆔 Verificar identidad de jugadores
- 📜 Verificar licencias
- 💊 Curar jugadores
- ❤️ Revivir jugadores

### 📈 Sistema de Estadísticas
- Seguimiento de popularidad de trabajos
- Balance económico del servidor
- Distribución de rangos
- Conteo de jugadores por trabajo
- Actualización automática periódica

## 🔧 Requisitos

### Dependencias Obligatorias
- **FiveM Server** (última versión)
- **mysql-async** o **oxmysql** o **ghmattimysql**
- Uno de los siguientes frameworks:
  - **ESX Legacy** o **ES Extended**
  - **QBCore**

### Dependencias Opcionales
- **ox_target** (para compatibilidad con OX Target)
- **qb-target** (para compatibilidad con QB Target)
- **jsfour-idcard** (para integración de tarjetas de ID)

## 📥 Instalación

### Paso 1: Descargar
Descarga la última versión del script desde [Releases](#).

### Paso 2: Instalar
1. Extrae el archivo ZIP
2. Coloca la carpeta `jobcreator` en tu directorio `resources`
3. Asegúrate de que la estructura sea:
   ```
   resources/
   └── jobcreator/
       ├── client/
       ├── server/
       ├── html/
       ├── locales/
       ├── config.lua
       └── fxmanifest.lua
   ```

### Paso 3: Configurar Base de Datos
El script creará automáticamente las tablas necesarias al iniciarse. Asegúrate de que tienes `mysql-async` configurado correctamente.

### Paso 4: Configurar server.cfg
Agrega estas líneas a tu `server.cfg`:
```cfg
ensure mysql-async  # o oxmysql/ghmattimysql
ensure jobcreator
```

### Paso 5: Configurar el Script
Edita `config.lua` según tus necesidades:
```lua
Config.Framework = 'auto'  -- 'auto', 'esx', 'qbcore'
Config.Locale = 'es'       -- Idioma por defecto
Config.EnableWhitelist = true
Config.AutoUnemployed = true
-- ... más opciones
```

### Paso 6: Iniciar el Servidor
Reinicia tu servidor FiveM y el script se iniciará automáticamente.

## 🎮 Uso

### Acceso al Menú
- **Comando:** `/jobcreator`
- **Tecla:** `F6` (configurable)
- **Requiere:** Permisos de administrador

### Crear un Trabajo
1. Abre el menú con `/jobcreator`
2. Ve a la pestaña "Jobs"
3. Haz clic en "Create Job"
4. Completa los datos:
   - Nombre del trabajo (ej: `police`)
   - Etiqueta del trabajo (ej: `Police Department`)
   - Activar whitelist (opcional)
5. Haz clic en "Submit"

### Crear Rangos
1. Abre el menú y ve a "Grades"
2. Selecciona un trabajo
3. Haz clic en "Create Grade"
4. Configura:
   - Número de rango (0, 1, 2, etc.)
   - Nombre del rango
   - Etiqueta del rango
   - Salario

### Crear Marcadores
1. Posiciónate donde quieres el marcador
2. Abre el menú y ve a "Markers"
3. Haz clic en "Create Marker at Current Position"
4. Configura:
   - Trabajo asociado
   - Tipo de marcador
   - Etiqueta
   - Tamaño y color

### Usar Acciones de Trabajo
- **Método 1:** Abre el menú principal → pestaña "Actions"
- **Método 2:** Presiona `F7` para el menú rápido de acciones
- Acércate al jugador/vehículo objetivo
- Selecciona la acción deseada

### Sistema Nexus
1. **Compartir un trabajo:**
   - Abre el menú → pestaña "Jobs"
   - Haz clic en "Share" en el trabajo deseado
   
2. **Importar un trabajo:**
   - Abre el menú → pestaña "Nexus"
   - Haz clic en "Load Jobs from Nexus"
   - Selecciona el trabajo a importar

### Ver Estadísticas
1. Abre el menú → pestaña "Statistics"
2. Haz clic en "Refresh Statistics"
3. Verás:
   - Trabajos más populares
   - Conteo de jugadores por trabajo
   - Balance económico

## ⚙️ Configuración Avanzada

### Personalizar Idioma
Edita `config.lua`:
```lua
Config.Locale = 'es'  -- Cambia a tu idioma preferido
```

### Activar OX Target
```lua
Config.UseOXTarget = true
```

### Activar QB Target
```lua
Config.UseQBTarget = true
```

### Configurar Nexus
```lua
Config.EnableNexus = true
Config.NexusAPIKey = 'tu-api-key-aqui'
Config.NexusServerURL = 'https://nexus.ejemplo.com'
```

### Personalizar Teclas
```lua
Config.UIKey = 'F6'           -- Tecla para abrir el menú
Config.UICommand = 'jobcreator'  -- Comando alternativo
```

### Permisos de Administrador
```lua
Config.AdminGroups = {'admin', 'superadmin', 'owner'}
```

## 🔌 Integración con Scripts Existentes

### ESX
El script detecta automáticamente ESX y se integra completamente. Compatible con:
- ESX Legacy
- ES Extended 1.2+
- esx_society (para cuentas de trabajos)
- esx_ambulancejob (para revivir)

### QBCore
Detecta automáticamente QBCore y funciona con:
- QBCore Framework
- qb-management (para cuentas de trabajos)
- qb-ambulancejob (para revivir)

### Otros Scripts
- **jsfour-idcard:** Integración automática para verificar IDs
- **ox_target/qb-target:** Soporte nativo para interacciones

## 📝 Comandos

### Comandos de Jugador
- `/jobcreator` - Abre el menú (solo admin)

### Comandos de Administrador
Todos los comandos se ejecutan desde la UI web. No hay comandos de chat adicionales.

## 🐛 Solución de Problemas

### El menú no se abre
- Verifica que tienes permisos de admin
- Revisa la consola F8 por errores
- Asegúrate de que el script está iniciado: `ensure jobcreator`

### Los marcadores no aparecen
- Verifica que el trabajo está creado
- Asegúrate de tener el trabajo asignado
- Reinicia el script: `restart jobcreator`

### Errores de base de datos
- Verifica que mysql-async está funcionando
- Asegúrate de que la configuración de MySQL es correcta
- Revisa los logs del servidor

### Framework no detectado
- Asegúrate de que ESX o QBCore está iniciado antes de jobcreator
- Verifica el orden en server.cfg:
  ```
  ensure es_extended  # o qb-core
  ensure jobcreator
  ```

## 🤝 Soporte

Si encuentras algún problema o tienes sugerencias:
- Abre un [Issue en GitHub](#)
- Únete a nuestro [Discord](#)
- Consulta la [Wiki](#) para más información

## 📜 Licencia

Este proyecto está bajo la licencia MIT. Ver el archivo `LICENSE` para más detalles.

## 🙏 Créditos

- Inspirado en **Jobs Creator** de **Jaksam**
- Desarrollado por la comunidad de FiveM
- Gracias a todos los contribuidores

## 📸 Screenshots

### Menú Principal
![Menu Principal](screenshots/main-menu.png)

### Gestión de Trabajos
![Jobs Management](screenshots/jobs.png)

### Marcadores
![Markers](screenshots/markers.png)

### Estadísticas
![Statistics](screenshots/stats.png)

---

**Versión:** 1.0.0  
**Última actualización:** 2024  
**Compatibilidad:** FiveM Latest, ESX Legacy, QBCore

¿Te gusta este script? ⭐ ¡Dale una estrella en GitHub!
