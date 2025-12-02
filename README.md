# Interfaz de Campo Magnético (MATLAB)

Proyecto de visualización 3D del campo magnético generado por **espiras circulares** y **líneas de corriente finitas**, con una interfaz gráfica interactiva en MATLAB.

-  Autor: **Josafat Vásquez**
-  Asignatura: *Teoría Electromagnética II* 

---

## Objetivo del proyecto

Desarrollar una interfaz gráfica en MATLAB que permita:

- Visualizar el **campo magnético** en 3D usando el **formato H(x, y, z)**.
- Comparar el comportamiento del campo para:
  - **Espiras circulares** (N espiras separadas una distancia *d*).
  - **Líneas de corriente finitas** definidas por segmentos en el espacio.
- Explorar el efecto de parámetros como:
  - Número de espiras, radio, separación y corriente.
  - Densidad de malla y límites de visualización.
  - Representación en modo **normal** o **unitario**.

---

## Descripción general

La interfaz se construye con `uifigure` y componentes UI de MATLAB:

- Menú desplegable para elegir el **tipo de fuente**:
  - `Espiras`
  - `Líneas`
- Panel lateral de **⚙ Parámetros de Entrada**:
  - Tamaño de malla: `Puntos XY`, `Puntos Z`
  - Factores de límite: `Factor XY`, `Factor Z`
  - Parámetros específicos según el tipo de fuente:
    - **Espiras**:
      - `Nº espiras (N)`
      - `Distancia d`
      - `Radio R`
      - `Corriente I`
      - `Modo`: `Normal` / `Unitario`
      - `Visual`: `Vectores` / `Líneas curvas`
    - **Líneas**:
      - `Cant. Líneas`
      - Tabla editable con columnas: `x0, y0, z0, x1, y1, z1, I`
      - `Modo`: `Normal` / `Unitario`
- Botón **📈 Graficar Campo** para actualizar la visualización.
- Eje 3D donde se dibuja:
  - La geometría de las fuentes (espiras o segmentos de línea).
  - El campo magnético como:
    - **Vectores (quiver3)**, o
    - **Líneas de flujo (streamline)**.

---

## Fundamento numérico

La expresión del campo magnético se basa en la Ley de Biot–Savart:

La ley de Biot–Savart es: $\vec{H}(\vec{r}) = \frac{I}{4\pi} \int \frac{d\vec{l} \times \vec{R}}{|\vec{R}|^3}$.

donde:

- $\vec{R} = \vec{r} - \vec{r}'$ es el vector desde el elemento de corriente al punto de observación.

donde:

- \(\vec{R} = \vec{r} - \vec{r}'\) es el vector desde el elemento de corriente al punto de observación.
- Para espiras:
  - Se parametriza la circunferencia con un ángulo \(\theta \in [0, 2\pi]\).
  - Se discretiza la espira en muchos puntos y se suma numéricamente el aporte de cada segmento.
- Para líneas finitas:
  - Cada segmento se discretiza en `Nseg` partes.
  - Se aproxima la integral con una suma de contribuciones en cada subsegmento.

En modo **Unitario**, los vectores se normalizan para resaltar **la dirección del campo** más que su magnitud.

---

## Requisitos

- MATLAB con soporte para **uifigure** (R2018b o superior recomendado).
- No se requieren toolboxes adicionales para la versión básica (usa funciones estándar de gráficos y UI).

---

## Cómo ejecutar

1. Guardar el archivo como:

   ```text
   InterfazCampoMagnetico.m
