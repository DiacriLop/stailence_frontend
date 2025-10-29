# Stailence ✂️💅

Plataforma web innovadora para la gestión de citas en negocios locales como peluquerías, barberías y centros de estética. Permite optimizar la agenda eliminando la necesidad de reservas por llamadas o mensajes, ahorrando tiempo a clientes y negocios mientras mejora la experiencia de servicio.
---
## 🚀 Características

Agendamiento rápido y en línea de citas

Panel de administración para negocios

Gestión de clientes y servicios

Notificaciones automáticas de recordatorio

Sistema de historial y estadísticas de reservas

---
🛠️ Tecnologías Frontend
-Flutter
-
-
---
## 📋 Checklist de Revisión de Código

✅ Claridad

Nombres de variables/funciones claros

Código fácil de entender

Comentarios útiles donde sea necesario

✅ Funcionalidad

Cumple con lo requerido

No rompe funcionalidad existente

Maneja errores correctamente

✅ Seguridad

No expone datos sensibles

Valida entradas de usuario

Sigue prácticas seguras

✅ Pruebas

Incluye pruebas si aplica

Las pruebas pasan correctamente

✅ Mantenibilidad

Sigue el estilo del proyecto

Sin código duplicado

Funciones con responsabilidad única

---
## 👥 Reglas de Colaboración
🔀 Flujo de Ramas (GitHub Flow)

Nuestro equipo seguirá la metodología GitHub Flow simplificada:

Ramas Principales:

main: Rama principal, siempre estable y lista para producción

develop: Rama de integración donde se fusionan las features

Ramas de Desarrollo:

feature/nombre-feature: Para nuevas funcionalidades

fix/nombre-fix: Para corrección de bugs

docs/nombre-doc: Para documentación

Proceso de Trabajo:

Crear nueva rama desde develop

Desarrollar la feature/fix

Hacer commits descriptivos y atómicos

Abrir Pull Request hacia develop

Revisión de código (mínimo 1 aprobación)

Merge después de aprobación

Eliminar rama después del merge

Convenciones:

Nombres de ramas: En inglés, minúsculas y separadas por guiones

Mensajes de commit: Claros y en presente (ej: "add booking system")

Pull Requests: Descripción detallada de los cambios
---
## 👥 Integrantes

Angie Cobo – 230222011
Diana López – 230222003
Alejandro Hernandez - 230222020
Valentina Gonzalez - 230231019

---
## 📞 Contacto

Universidad: UCEVA

# Taller 2 - autenticación JWT (Frontend - Flutter) 

## 📋 Descripción
Aplicación móvil desarrollada en Flutter que consume API RESTful propia construida con Java Spring Boot, implementando autenticación JWT y almacenamiento local seguro.

## 🚀 Características
- Autenticación JWT con manejo seguro de tokens
- Almacenamiento local diferenciado (seguro y no sensible)
- Manejo de estados con Provider
- Consumo de API REST con manejo de errores
- Interfaz moderna y responsive

## 🛠️ Tecnologías Utilizadas
- Framework: Flutter 
- Lenguaje: Dart
- Gestor de Estado: Provider
- Almacenamiento Local:
  - flutter_secure_storage (datos sensibles)
  - shared_preferences (datos no sensibles)
- HTTP Client: http package
- Backend: Java Spring Boot + MySQL

## 📁 Estructura del Proyecto
```
lib/
├── application/
│   ├── app_state.dart
├── core/
│   ├── constans/
│   │   ├── api_endpoints.dart
│   │   ├── app_strings.dart
│   │   ├── colors.dart
│   │   ├── storage_keys.dart
│   │   └── text_styles.dart
│   ├── exceptions/
│   │   └── failures.dart
│   └── utils/              # Utilidades y funciones comunes
│       ├── formatters.dart
│       ├── helpers.dart
│       └── validators.dart
├── data/                                 # Datos simulados (mock)
│   └── mock/
│       ├── disponibilidad_mock.dart
│       ├── empleado_servicio_mock.dart
│       ├── mock_database.dart
│       ├── negocios_mock.dart
│       ├── servicios_mock.dart
│       └── usuarios_mock.dart
├── models/                               # Modelos de datos
│   └── auth/                              
│       ├── login_request.dart
│       ├── login_response.dart
│       └── register_request.dart
│   ├── cita_model.dart
│   ├── disponibilidad_model.dart
│   ├── negocio_model.dart
│   ├── notificacion_model.dart
│   ├── pago_model.dart
│   ├── servicio_model.dart
│   └── usuario_model.dart
├── repositories/                         # Repositorios de acceso a datos
│   └── auth_repository.dart
├── services/                             # Servicios y APIs
│   └── auth_service.dart
├── domain/                               # Entidades / reglas de negocio
└── presentation/                         # Presentación / interfaz de usuario
│   ├── pages/                            # Pantallas de la app
│   │   ├── auth/
│   │   │   ├── login_page.dart
│   │   │   └── register_page.dart
│   │   ├── citas/
│   │   ├── home/
│   │   ├── negocios/
│   │   ├── notificaciones/
│   │   ├── pagos/
│   │   ├── perfin/
│   │   ├── servicios/
│   │   └── splash/
│   ├── themes/                           # Temas visuales (colores, estilos)
│   │   └── app_theme.dart
│   └── widgets/                          # Componentes reutilizables
│       ├── empty_state.dart
│   ├── app_router.dart                   # Rutas de navegación
│   ├── injection_container.dart        
│   └── main.dart                         # Clase principal
```
## ⚙️Variables de entorno

<img width="620" height="282" alt="image" src="https://github.com/user-attachments/assets/b7cb6fda-464a-4197-adab-eb106f5f8242" />

## 🔐 Módulo de Autenticación JWT
### Flujo de Autenticación
 - Login: Usuario ingresa credenciales
 - Validación: Request al endpoint /auth/login
 - Almacenamiento:
    - Token JWT → flutter_secure_storage
    - Datos usuario → shared_preferences

 - Navegación: Redirección a pantalla principal
 - Persistencia: Verificación automática al iniciar app

## Almacenamiento Implementado
#### Datos Sensibles (flutter_secure_storage)
#### Datos No Sensibles (shared_preferences)

<img width="820" height="450" alt="image" src="https://github.com/user-attachments/assets/ab8e15f4-cb96-4e19-a872-c8c424e897d5" />
<img width="820" height="489" alt="image" src="https://github.com/user-attachments/assets/3ae68006-026e-4834-8b6a-f9d79f21c603" />

## 🎯 Funcionalidades Principales
### Pantalla de Login
  - Validación de campos
  - Manejo de estados (cargando/éxito/error)
  - Consumo de API con manejo de errores
  - Persistencia de sesión
### Pantalla de Evidencia
  - Visualización de datos almacenados localmente
  - Indicador de estado de sesión
  - Botón de cierre de sesión

## 📷 Capturas
### Pantallas de Login y Registro de usuarios
<img width="430" height="600" alt="image" src="https://github.com/user-attachments/assets/0751ca81-04f6-4f92-a6c6-ec27957e46d5" />
<img width="430" height="600" alt="image" src="https://github.com/user-attachments/assets/2257526b-c2da-48ed-9b4c-3523f7f74562" />

### Mensaje de error conexión HTTP, servicio backend apagado 
<img width="430" height="600" alt="image" src="https://github.com/user-attachments/assets/4f19f08d-3fd7-40c9-8b26-b30f8cf70352" />
<img width="430" height="600" alt="image" src="https://github.com/user-attachments/assets/c83e6893-dbc4-4131-aa88-ce1c6d242e76" />

### Login éxitoso, contenido de la app visible
<img width="430" height="620" alt="image" src="https://github.com/user-attachments/assets/b5236607-5c9f-469e-b46c-47929a592738" />
<img width="430" height="620" alt="image" src="https://github.com/user-attachments/assets/ae9d31cc-823b-48c5-9be7-0c452478e08d" />

### Pantalla de evidencia con datos almacenados del usuario
<img width="430" height="620" alt="image" src="https://github.com/user-attachments/assets/7ff766fd-188b-457c-99a3-fd41fde4d1de" />
<img width="430" height="620" alt="image" src="https://github.com/user-attachments/assets/2009902d-3e9c-4923-a38c-831e3f8cf0a4" />

## Estado cerrar sesión
<img width="430" height="620" alt="image" src="https://github.com/user-attachments/assets/70f3c22e-888c-4cf1-a0a8-30ece6110394" />
<img width="430" height="620" alt="image" src="https://github.com/user-attachments/assets/cce1ac51-5719-4545-9d9d-57884e274ecb" />

