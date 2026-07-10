# ENUNCIADO.md

# 🧪 Workshop — Linux Storage, Backup & Restore
> **SRE Linux Workshop Series**
>
> ![Linux](https://img.shields.io/badge/Linux-Administration-E95420?style=for-the-badge&logo=linux)
> ![Storage](https://img.shields.io/badge/Storage-Management-blue?style=for-the-badge&logo=databricks)
> ![Backup](https://img.shields.io/badge/Backup%20%26%20Restore-green?style=for-the-badge&logo=gnu)
> ![Filesystem](https://img.shields.io/badge/Filesystem-EXT4-red?style=for-the-badge)
> ![SRE](https://img.shields.io/badge/SRE-LAB-purple?style=for-the-badge)

---

# 📘 Contexto

La empresa requiere implementar una estrategia básica de almacenamiento, respaldo y recuperación de información sobre un servidor Linux.  

Como administrador Linux/SRE, debes preparar la infraestructura necesaria para soportar operaciones de backup, restauración y expansión de memoria swap utilizando discos persistentes.

---

# 🎯 Objetivo General

El estudiante debe ser capaz de reproducir completamente el escenario solicitado utilizando buenas prácticas de administración Linux.

---

# 🧩 Escenario Requerido

Debes implementar un entorno Linux que cumpla con las siguientes condiciones:

---

# 💾 Gestión de Discos

## Se deben crear 2 discos adicionales:

| Disco | Tamaño |
|---|---|
| Disco 1 | 2 GB |
| Disco 2 | 4 GB |

Los discos pueden ser:

- Discos adjuntos desde VirtualBox
- Discos creados utilizando `dd`

---

# 📦 Requerimientos de Particionado

Ambos discos deben:

- Estar particionados
- Utilizar la partición lógica número 5
- Utilizar la totalidad del espacio disponible
- Tener formato EXT4
- Ser persistentes después de reinicios

---

# 📁 Puntos de Montaje

| Disco | Punto de Montaje |
|---|---|
| Disco de 2 GB | `/backups` |
| Disco de 4 GB | `/restore` |

---

# 🗄️ Respaldo de Información

Debes generar un respaldo del directorio:

```text
/var
```

El respaldo debe cumplir con las siguientes condiciones:

- Debe realizarse de forma relativa
- Debe estar comprimido utilizando BZIP2
- Debe almacenarse en el file system `/backups`
- Debe incluir timestamp como parte del nombre del archivo

---

# ♻️ Restauración

Debes realizar una restauración completa del respaldo hacia:

```text
/restore
```

Posteriormente debes validar que la restauración fue exitosa.

---

# 🧠 Gestión de SWAP

Debes crear un tercer disco con las siguientes características:

| Recurso | Valor |
|---|---|
| Tamaño | 1 GB |
| Método de creación | `dd` |
| Tipo | SWAP |

El disco debe:

- Ser agregado como área swap del sistema
- Quedar operativo y funcional
- Ser persistente

---

# 📌 Consideraciones Importantes

- Todos los procedimientos deben quedar persistentes.
- Se espera el uso de buenas prácticas de administración Linux.
- El laboratorio debe quedar completamente funcional después de reiniciar el sistema.
- No se permite pérdida de información durante la restauración.
- La validación de funcionamiento es parte del entregable.

---

# 🏁 Resultado Esperado

Al finalizar el workshop, el estudiante deberá contar con:

✅ Discos persistentes configurados  
✅ Particiones correctamente implementadas  
✅ Sistemas de archivos EXT4 funcionales  
✅ Montajes persistentes operativos  
✅ Backup comprimido y almacenado correctamente  
✅ Restauración validada exitosamente  
✅ Área swap adicional activa y persistente  

---

# 🎓 Competencias Evaluadas

- Administración de almacenamiento Linux
- Gestión de particiones
- Sistemas de archivos
- Persistencia mediante configuración del sistema
- Backup y restauración
- Gestión de swap
- Resolución de problemas Linux
- Buenas prácticas SRE

---
