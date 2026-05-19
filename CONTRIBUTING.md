# 🤝 Sugerencias y Mejoras

Este repositorio documenta una implementación real de homelab con Proxmox. Si encuentras errores, contradicciones o tienes sugerencias de mejora, tu feedback es bienvenido.

## 📋 Qué Puedes Reportar

### Errores en la Documentación
- Comandos incorrectos o peligrosos
- Contradicciones entre IPs, puertos o configuraciones
- Enlaces rotos
- Typos o errores gramaticales
- Instrucciones poco claras

### Mejoras de Seguridad
- Vulnerabilidades detectadas
- Mejores prácticas de seguridad
- Configuraciones inseguras

### Sugerencias de Contenido
- Servicios adicionales útiles
- Mejores formas de documentar algo
- Diagramas o visualizaciones
- Scripts de automatización

## 🐛 Reportar un Error

Si encuentras un error en la documentación:

1. **Verifica** que no esté ya reportado en [Issues](../../issues)
2. **Abre un issue** usando el [template de error](../../issues/new?template=bug_report.md)
3. **Incluye**:
   - Qué documento tiene el error
   - Qué está mal
   - Cuál debería ser la información correcta
   - Logs o screenshots si aplica

## 💡 Sugerir una Mejora

Para sugerir mejoras:

1. **Abre un issue** usando el [template de sugerencia](../../issues/new?template=feature_request.md)
2. **Describe**:
   - Qué quieres mejorar
   - Por qué sería útil
   - Cómo lo implementarías

## 🔀 Pull Requests

Si quieres contribuir directamente:

1. **Fork** el repositorio
2. **Crea una rama**: `git checkout -b fix/descripcion-corta`
3. **Haz tus cambios**
4. **Commit**: `git commit -m "Fix: descripción del cambio"`
5. **Push**: `git push origin fix/descripcion-corta`
6. **Abre un Pull Request**

### Guías para PRs

✅ **Hacer**:
- Cambios pequeños y enfocados
- Probar comandos antes de documentar
- Mantener el estilo de documentación existente
- Actualizar índices si añades nuevos documentos

❌ **Evitar**:
- Cambios masivos sin discusión previa
- Información sensible (IPs reales, passwords, dominios)
- Romper la estructura de documentación existente

## 📝 Estilo de Documentación

### Markdown
- Headers jerárquicos (# ## ###)
- Code blocks con syntax highlighting
- Ejemplos prácticos y probados
- Comandos con comentarios explicativos

### Comandos
```bash
# Comentario explicativo de qué hace
comando --con-opciones
```

### Configuraciones
- Usar placeholders para datos sensibles: `your_password_here`
- Incluir comentarios en configs
- Mostrar configuración completa, no fragmentos

## 🔒 Información Sensible

**NUNCA incluyas**:
- Passwords reales
- Tokens o API keys
- Dominios Tailscale reales
- IPs públicas
- Información personal

Usa siempre placeholders como:
- `your_password_here`
- `tailXXXXXX.ts.net`
- `tu-dominio.com`

## ❓ Preguntas

Si tienes dudas sobre la implementación:

- [Abre una discussion](../../discussions)
- [Pregunta en un issue](../../issues/new)

## 📄 Licencia

Al contribuir, aceptas que tus contribuciones serán licenciadas bajo MIT.

---

**Nota**: Este no es un producto comercial ni una aplicación. Es documentación técnica de una infraestructura real, compartida para que otros puedan aprender y replicar.

¡Gracias por ayudar a mejorar esta documentación! 🎉