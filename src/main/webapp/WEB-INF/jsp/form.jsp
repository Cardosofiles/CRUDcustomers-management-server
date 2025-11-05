<!-- filepath: /home/cardosofiles/www/github/faculty/v2-internet-programming/src/main/webapp/WEB-INF/jsp/form.jsp -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="pt-BR">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>${cliente.id != null ? 'Editar' : 'Novo'} Cliente</title>
    <style>
      * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
      }

      body {
        font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        min-height: 100vh;
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 20px;
      }

      .container {
        background: white;
        border-radius: 20px;
        box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
        padding: 40px;
        max-width: 500px;
        width: 100%;
      }

      h2 {
        color: #333;
        margin-bottom: 30px;
        font-size: 2em;
        text-align: center;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
      }

      /* Alertas de Erro */
      .alert-error {
        background: #f8d7da;
        border: 2px solid #dc3545;
        color: #721c24;
        padding: 15px 20px;
        border-radius: 10px;
        margin-bottom: 20px;
        display: flex;
        align-items: center;
        gap: 10px;
        animation: shake 0.5s ease;
      }

      @keyframes shake {
        0%,
        100% {
          transform: translateX(0);
        }
        10%,
        30%,
        50%,
        70%,
        90% {
          transform: translateX(-5px);
        }
        20%,
        40%,
        60%,
        80% {
          transform: translateX(5px);
        }
      }

      .alert-icon {
        font-size: 24px;
      }

      .form-group {
        margin-bottom: 25px;
      }

      label {
        display: block;
        margin-bottom: 8px;
        color: #555;
        font-weight: 600;
        font-size: 14px;
        text-transform: uppercase;
        letter-spacing: 0.5px;
      }

      input[type="text"],
      input[type="email"] {
        width: 100%;
        padding: 15px;
        border: 2px solid #e0e0e0;
        border-radius: 10px;
        font-size: 16px;
        transition: all 0.3s ease;
        background: #f8f9fa;
      }

      input[type="text"]:focus,
      input[type="email"]:focus {
        outline: none;
        border-color: #667eea;
        background: white;
        box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
      }

      input.error {
        border-color: #dc3545;
      }

      .button-group {
        display: flex;
        gap: 15px;
        margin-top: 30px;
      }

      .btn {
        flex: 1;
        padding: 15px;
        border: none;
        border-radius: 10px;
        font-size: 16px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s ease;
        text-decoration: none;
        display: inline-block;
        text-align: center;
      }

      .btn-primary {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
      }

      .btn-primary:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 20px rgba(102, 126, 234, 0.6);
      }

      .btn-secondary {
        background: #6c757d;
        color: white;
      }

      .btn-secondary:hover {
        background: #5a6268;
        transform: translateY(-2px);
      }

      .icon {
        margin-right: 8px;
      }

      @media (max-width: 768px) {
        .container {
          padding: 30px 20px;
        }

        .button-group {
          flex-direction: column;
        }
      }
    </style>
  </head>
  <body>
    <div class="container">
      <h2>${cliente.id != null ? '✏️ Editar Cliente' : '➕ Novo Cliente'}</h2>

      <!-- Mensagem de Erro -->
      <c:if test="${not empty erro}">
        <div class="alert-error">
          <span class="alert-icon">⚠️</span>
          <span><strong>Erro:</strong> ${erro}</span>
        </div>
      </c:if>

      <form
        action="/clientes/salvar"
        method="post"
        onsubmit="return validarFormulario()"
      >
        <input type="hidden" name="id" value="${cliente.id}" />

        <div class="form-group">
          <label for="nome">👤 Nome Completo</label>
          <input
            type="text"
            id="nome"
            name="nome"
            value="${cliente.nome}"
            placeholder="Digite o nome completo"
            required
            minlength="3"
            maxlength="100"
          />
        </div>

        <div class="form-group">
          <label for="email">📧 Email</label>
          <input
            type="email"
            id="email"
            name="email"
            value="${cliente.email}"
            placeholder="exemplo@email.com"
            required
          />
        </div>

        <div class="form-group">
          <label for="telefone">📱 Telefone</label>
          <input
            type="text"
            id="telefone"
            name="telefone"
            value="${cliente.telefone}"
            placeholder="(00) 00000-0000"
            required
            minlength="10"
            maxlength="15"
          />
        </div>

        <div class="button-group">
          <button type="submit" class="btn btn-primary">
            <span class="icon">💾</span> Salvar
          </button>
          <a href="/clientes" class="btn btn-secondary">
            <span class="icon">↩️</span> Cancelar
          </a>
        </div>
      </form>
    </div>

    <script>
      function validarFormulario() {
        const nome = document.getElementById("nome").value.trim();
        const email = document.getElementById("email").value.trim();
        const telefone = document.getElementById("telefone").value.trim();

        if (nome.length < 3) {
          alert("⚠️ O nome deve ter no mínimo 3 caracteres");
          return false;
        }

        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(email)) {
          alert("⚠️ Por favor, insira um email válido");
          return false;
        }

        if (telefone.length < 10) {
          alert("⚠️ O telefone deve ter no mínimo 10 dígitos");
          return false;
        }

        return true;
      }

      // Máscara de telefone
      document
        .getElementById("telefone")
        .addEventListener("input", function (e) {
          let value = e.target.value.replace(/\D/g, "");
          if (value.length <= 10) {
            value = value.replace(/(\d{2})(\d{4})(\d{4})/, "($1) $2-$3");
          } else {
            value = value.replace(/(\d{2})(\d{5})(\d{4})/, "($1) $2-$3");
          }
          e.target.value = value;
        });
    </script>
  </body>
</html>
