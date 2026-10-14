/* ============ PawCare – lógica ============ */
(function () {
  'use strict';

  var CLAVE = 'pawcare_mascotas';
  var mascotas = [];
  var ultimoId = null;

  // ---- Referencias al DOM ----
  var $ = function (id) { return document.getElementById(id); };
  var form = $('formMascota');
  var campos = {
    nombreMascota: $('txtNombreMascota'),
    nombreDueno:   $('txtNombreDueno'),
    tipo:          $('ddlTipo'),
    edad:          $('txtEdad'),
    telefono:      $('txtTelefono'),
    observaciones: $('txtObservaciones')
  };

  // ---- Almacenamiento (localStorage con respaldo en memoria) ----
  function cargar() {
    try {
      var data = localStorage.getItem(CLAVE);
      if (data) return JSON.parse(data);
    } catch (e) { /* sin acceso a localStorage */ }
    return null;
  }
  function guardar() {
    try { localStorage.setItem(CLAVE, JSON.stringify(mascotas)); } catch (e) {}
  }

  // ---- Validaciones (equivalentes a los validators de ASP.NET) ----
  var validadores = {
    // RequiredFieldValidator
    nombreMascota: function (v) {
      return v.trim() === '' ? 'El nombre de la mascota es obligatorio.' : '';
    },
    // RequiredFieldValidator
    nombreDueno: function (v) {
      return v.trim() === '' ? 'El nombre del dueño es obligatorio.' : '';
    },
    // RequiredFieldValidator + RangeValidator (0 a 30, entero)
    edad: function (v) {
      v = v.trim();
      if (v === '') return 'La edad es obligatoria.';
      if (!/^\d+$/.test(v) || +v < 0 || +v > 30) return 'La edad debe estar entre 0 y 30 años.';
      return '';
    },
    // RequiredFieldValidator + RegularExpressionValidator (^\d{9}$)
    telefono: function (v) {
      v = v.trim();
      if (v === '') return 'El teléfono es obligatorio.';
      if (!/^\d{9}$/.test(v)) return 'El teléfono debe tener 9 dígitos numéricos.';
      return '';
    }
  };
  var mensajesError = {
    nombreMascota: $('errNombreMascota'),
    nombreDueno:   $('errNombreDueno'),
    edad:          $('errEdad'),
    telefono:      $('errTelefono')
  };

  function validarCampo(nombre) {
    var msg = validadores[nombre](campos[nombre].value);
    var input = campos[nombre];
    mensajesError[nombre].textContent = msg;
    input.classList.toggle('is-invalid', msg !== '');
    input.classList.toggle('is-valid', msg === '');
    return msg === '';
  }
  function validarTodo() {
    var ok = true;
    Object.keys(validadores).forEach(function (n) {
      if (!validarCampo(n)) ok = false;
    });
    return ok;
  }

  // Validación en vivo al salir del campo y mientras se corrige
  Object.keys(validadores).forEach(function (n) {
    campos[n].addEventListener('blur', function () { validarCampo(n); });
    campos[n].addEventListener('input', function () {
      if (campos[n].classList.contains('is-invalid')) validarCampo(n);
    });
  });

  // El teléfono solo admite dígitos
  campos.telefono.addEventListener('input', function () {
    this.value = this.value.replace(/\D/g, '').slice(0, 9);
  });

  // Contador de observaciones
  campos.observaciones.addEventListener('input', function () {
    $('contador').textContent = this.value.length;
  });

  // ---- Utilidades ----
  function esc(s) {
    return String(s).replace(/[&<>"']/g, function (c) {
      return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c];
    });
  }
  function mostrarMensaje(texto, tipo) {
    var m = $('mensaje');
    m.className = 'alert alert-' + tipo;
    m.textContent = texto;
    clearTimeout(mostrarMensaje.t);
    mostrarMensaje.t = setTimeout(function () { m.classList.add('d-none'); }, 4000);
  }
  function limpiarFormulario() {
    form.reset();
    $('contador').textContent = '0';
    Object.keys(campos).forEach(function (k) {
      campos[k].classList.remove('is-valid', 'is-invalid');
    });
  }

  // ---- Render del GridView ----
  function render() {
    var filtro = $('txtBuscar').value.trim().toLowerCase();
    var lista = mascotas.filter(function (m) {
      if (!filtro) return true;
      return (m.nombreMascota + ' ' + m.nombreDueno + ' ' + m.tipo + ' ' + m.telefono + ' ' + (m.observaciones || ''))
        .toLowerCase().indexOf(filtro) !== -1;
    });

    $('totalBadge').textContent = mascotas.length;

    var html = lista.map(function (m) {
      return '<tr' + (m.id === ultimoId ? ' class="fila-nueva"' : '') + '>' +
        '<td>' + m.id + '</td>' +
        '<td class="fw-semibold">' + esc(m.nombreMascota) + '</td>' +
        '<td>' + esc(m.nombreDueno) + '</td>' +
        '<td><span class="badge tipo-badge tipo-' + esc(m.tipo) + '">' + esc(m.tipo) + '</span></td>' +
        '<td>' + m.edad + '</td>' +
        '<td>' + esc(m.telefono) + '</td>' +
        '<td class="col-obs">' + (m.observaciones ? esc(m.observaciones) : '<span class="text-muted">—</span>') + '</td>' +
        '<td class="text-end"><button type="button" class="btn btn-sm btn-outline-danger" data-id="' + m.id + '" title="Eliminar">' +
        '<i class="bi bi-trash"></i></button></td>' +
        '</tr>';
    }).join('');

    $('tbodyMascotas').innerHTML = html;
    $('gvMascotas').classList.toggle('d-none', lista.length === 0);
    $('vacio').classList.toggle('d-none', lista.length !== 0);
    $('vacioTexto').textContent = mascotas.length === 0
      ? 'No hay mascotas registradas.'
      : 'No se encontraron resultados para la búsqueda.';
  }

  // ---- Eventos ----
  form.addEventListener('submit', function (e) {
    e.preventDefault();
    if (!validarTodo()) {
      mostrarMensaje('Revisa los campos marcados en rojo.', 'danger');
      var primero = form.querySelector('.is-invalid');
      if (primero) primero.focus();
      return;
    }

    var siguienteId = mascotas.reduce(function (mx, m) { return Math.max(mx, m.id); }, 0) + 1;
    var obs = campos.observaciones.value.trim();

    mascotas.unshift({
      id: siguienteId,
      nombreMascota: campos.nombreMascota.value.trim(),
      nombreDueno: campos.nombreDueno.value.trim(),
      tipo: campos.tipo.value,
      edad: parseInt(campos.edad.value, 10),
      telefono: campos.telefono.value.trim(),
      observaciones: obs === '' ? null : obs
    });
    ultimoId = siguienteId;
    guardar();
    limpiarFormulario();
    $('txtBuscar').value = '';
    render();
    mostrarMensaje('Mascota registrada correctamente.', 'success');
  });

  $('btnLimpiar').addEventListener('click', limpiarFormulario);
  $('txtBuscar').addEventListener('input', render);

  $('tbodyMascotas').addEventListener('click', function (e) {
    var btn = e.target.closest('button[data-id]');
    if (!btn) return;
    var id = parseInt(btn.getAttribute('data-id'), 10);
    var m = mascotas.filter(function (x) { return x.id === id; })[0];
    if (m && confirm('¿Eliminar a "' + m.nombreMascota + '"?')) {
      mascotas = mascotas.filter(function (x) { return x.id !== id; });
      ultimoId = null;
      guardar();
      render();
    }
  });

  // ---- Inicio ----
  $('anio').textContent = new Date().getFullYear();
  mascotas = cargar();
  if (!mascotas) {
    // Dato de ejemplo (igual que la prueba rápida del script SQL)
    mascotas = [{
      id: 1, nombreMascota: 'Firulais', nombreDueno: 'Juan Pérez', tipo: 'Perro',
      edad: 3, telefono: '987654321', observaciones: 'Vacuna al día'
    }];
    guardar();
  }
  render();
})();
