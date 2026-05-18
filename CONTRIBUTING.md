# 🤝 Guía de Contribución

¡Gracias por tu interés en contribuir a este proyecto! Esta guía te ayudará a empezar.

## 📋 Tabla de Contenidos

- [Código de Conducta](#código-de-conducta)
- [Cómo Contribuir](#cómo-contribuir)
- [Reportar Bugs](#reportar-bugs)
- [Sugerir Features](#sugerir-features)
- [Pull Requests](#pull-requests)
- [Estilo de Código](#estilo-de-código)
- [Documentación](#documentación)

## 📜 Código de Conducta

Este proyecto se adhiere a un código de conducta. Al participar, se espera que mantengas un ambiente respetuoso y constructivo.

### Nuestros Estándares

✅ **Hacer**:
- Ser respetuoso con otros contribuidores
- Aceptar críticas constructivas
- Enfocarse en lo mejor para la comunidad
- Mostrar empatía hacia otros miembros

❌ **No hacer**:
- Usar lenguaje ofensivo o inapropiado
- Trolling o comentarios despectivos
- Acoso público o privado
- Publicar información privada de otros

## 🚀 Cómo Contribuir

Hay muchas formas de contribuir:

### 1. Reportar Bugs
Encontraste un error? [Abre un issue](../../issues/new?template=bug_report.md)

### 2. Sugerir Features
Tienes una idea? [Propón una feature](../../issues/new?template=feature_request.md)

### 3. Mejorar Documentación
- Corregir typos
- Añadir ejemplos
- Clarificar instrucciones
- Traducir a otros idiomas

### 4. Contribuir Código
- Corregir bugs
- Implementar features
- Optimizar scripts
- Añadir tests

### 5. Compartir Configuraciones
- Compartir tus docker-compose personalizados
- Compartir scripts útiles
- Compartir configuraciones de servicios

## 🐛 Reportar Bugs

### Antes de Reportar

1. **Busca en issues existentes** - Quizás ya fue reportado
2. **Verifica la documentación** - Puede ser un problema de configuración
3. **Prueba con la última versión** - Puede estar ya corregido

### Cómo Reportar

Usa el [template de bug report](../../issues/new?template=bug_report.md) e incluye:

- **Descripción clara** del problema
- **Pasos para reproducir** el error
- **Comportamiento esperado** vs actual
- **Logs relevantes** (sin información sensible)
- **Entorno** (OS, versiones, hardware)
- **Screenshots** si aplica

## 💡 Sugerir Features

### Antes de Sugerir

1. **Busca en issues existentes** - Puede estar ya propuesta
2. **Revisa el roadmap** - Puede estar planeada
3. **Considera el alcance** - Debe ser relevante para el proyecto

### Cómo Sugerir

Usa el [template de feature request](../../issues/new?template=feature_request.md) e incluye:

- **Descripción clara** de la feature
- **Problema que resuelve**
- **Casos de uso** específicos
- **Alternativas consideradas**
- **Mockups o ejemplos** si aplica

## 🔀 Pull Requests

### Proceso

1. **Fork el repositorio**
2. **Crea una rama** desde `main`:
   ```bash
   git checkout -b feature/mi-nueva-feature
   ```
3. **Haz tus cambios**
4. **Commit con mensajes claros**:
   ```bash
   git commit -m "Add: Nueva feature X"
   ```
5. **Push a tu fork**:
   ```bash
   git push origin feature/mi-nueva-feature
   ```
6. **Abre un Pull Request**

### Guías para PRs

✅ **Hacer**:
- Mantener cambios enfocados y pequeños
- Escribir mensajes de commit descriptivos
- Actualizar documentación si es necesario
- Probar tus cambios antes de enviar
- Seguir el estilo de código existente

❌ **No hacer**:
- Mezclar múltiples features en un PR
- Hacer cambios no relacionados
- Romper funcionalidad existente
- Ignorar feedback de revisión

### Mensajes de Commit

Usa prefijos claros:

- `Add:` - Nueva feature o archivo
- `Fix:` - Corrección de bug
- `Update:` - Actualización de código existente
- `Docs:` - Cambios en documentación
- `Refactor:` - Refactorización de código
- `Style:` - Cambios de formato
- `Test:` - Añadir o actualizar tests
- `Chore:` - Tareas de mantenimiento

Ejemplos:
```
Add: Docker compose para CT105 monitoring
Fix: Error en script de backup
Update: Documentación de Tailscale
Docs: Añadir guía de troubleshooting
```

## 📝 Estilo de Código

### Scripts Bash

```bash
#!/bin/bash
# Descripción del script

set -e  # Salir en error

# Comentarios claros
echo "Mensaje descriptivo"

# Variables en MAYÚSCULAS
VARIABLE="valor"

# Funciones con nombres descriptivos
function nombre_descriptivo() {
    # Código
}
```

### Docker Compose

```yaml
version: '3.8'

services:
  nombre-servicio:
    image: imagen:tag
    container_name: nombre-contenedor
    restart: unless-stopped
    ports:
      - "puerto:puerto"
    volumes:
      - ./ruta:/ruta
    environment:
      - VARIABLE=valor
    networks:
      - red-nombre
```

### Markdown

- Usar headers jerárquicos (# ## ###)
- Incluir tabla de contenidos en docs largos
- Usar code blocks con syntax highlighting
- Incluir ejemplos prácticos
- Mantener líneas < 120 caracteres

## 📚 Documentación

### Estructura

Toda documentación va en `/docs`:

```
docs/
├── 01-getting-started/
├── 02-proxmox-base/
├── 03-networking/
└── ...
```

### Guías de Documentación

1. **Ser claro y conciso**
2. **Incluir ejemplos prácticos**
3. **Usar screenshots cuando ayude**
4. **Mantener actualizado**
5. **Probar los comandos antes de documentar**

### Template de Documentación

```markdown
# Título del Documento

Breve descripción de qué cubre este documento.

## Requisitos Previos

- Requisito 1
- Requisito 2

## Pasos

### 1. Primer Paso

Descripción y comandos:

\`\`\`bash
comando aquí
\`\`\`

### 2. Segundo Paso

...

## Verificación

Cómo verificar que funcionó correctamente.

## Troubleshooting

Problemas comunes y soluciones.

## Referencias

- [Link 1](url)
- [Link 2](url)
```

## 🧪 Testing

Antes de enviar un PR:

1. **Prueba tus cambios** en un entorno limpio
2. **Verifica que no rompe** funcionalidad existente
3. **Documenta** cómo probaste
4. **Incluye logs** si es relevante

## 📦 Añadir Nuevos Servicios

Si quieres añadir un nuevo servicio:

1. **Crea carpeta** en `/services/ctXXX-nombre/`
2. **Incluye**:
   - `README.md` - Documentación completa
   - `docker-compose.yml` - Stack del servicio
   - `configs/` - Configuraciones de ejemplo
3. **Documenta**:
   - Requisitos
   - Instalación paso a paso
   - Configuración
   - Troubleshooting
4. **Actualiza**:
   - README principal
   - Documentación en `/docs`
   - CHANGELOG.md

## 🎨 Añadir Diagramas

Para diagramas:

1. **Usa herramientas** como draw.io, Excalidraw
2. **Guarda fuente** en `/diagrams/source/`
3. **Exporta PNG** en `/diagrams/`
4. **Optimiza tamaño** de imágenes
5. **Usa nombres descriptivos**

## 🌍 Traducciones

Traducciones son bienvenidas:

1. **Crea carpeta** `/docs/[idioma]/`
2. **Traduce documentos** manteniendo estructura
3. **Actualiza links** internos
4. **Añade a README** principal

## ❓ Preguntas

Si tienes preguntas sobre cómo contribuir:

- [Abre una discussion](../../discussions)
- [Pregunta en un issue](../../issues/new?template=question.md)

## 🙏 Reconocimientos

Todos los contribuidores serán reconocidos en:
- README principal
- CHANGELOG.md
- Página de contribuidores

## 📄 Licencia

Al contribuir, aceptas que tus contribuciones serán licenciadas bajo la misma licencia del proyecto (MIT).

---

¡Gracias por contribuir! 🎉