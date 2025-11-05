<!-- filepath: /home/cardosofiles/www/github/faculty/v2-internet-programming/src/main/webapp/WEB-INF/jsp/listar.jsp -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="pt-BR">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Lista de Clientes</title>
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
        padding: 20px;
      }

      .container {
        max-width: 1200px;
        margin: 0 auto;
        background: white;
        border-radius: 20px;
        box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
        padding: 40px;
      }

      h2 {
        color: #333;
        margin-bottom: 30px;
        font-size: 2.5em;
        text-align: center;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
      }

      /* Alertas */
      .alert {
        padding: 15px 20px;
        border-radius: 10px;
        margin-bottom: 20px;
        display: flex;
        align-items: center;
        gap: 10px;
        animation: slideDown 0.3s ease;
      }

      @keyframes slideDown {
        from {
          opacity: 0;
          transform: translateY(-20px);
        }
        to {
          opacity: 1;
          transform: translateY(0);
        }
      }

      .alert-success {
        background: #d4edda;
        border: 2px solid #28a745;
        color: #155724;
      }

      .alert-error {
        background: #f8d7da;
        border: 2px solid #dc3545;
        color: #721c24;
      }

      .alert-icon {
        font-size: 24px;
      }

      .header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 30px;
      }

      .btn {
        display: inline-block;
        padding: 12px 30px;
        text-decoration: none;
        border-radius: 50px;
        font-weight: 600;
        transition: all 0.3s ease;
        border: none;
        cursor: pointer;
        font-size: 16px;
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

      table {
        width: 100%;
        border-collapse: collapse;
        background: white;
        border-radius: 10px;
        overflow: hidden;
        box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
      }

      thead {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
      }

      th,
      td {
        padding: 15px;
        text-align: left;
      }

      th {
        font-weight: 600;
        text-transform: uppercase;
        font-size: 14px;
        letter-spacing: 1px;
      }

      tbody tr {
        border-bottom: 1px solid #f0f0f0;
        transition: all 0.3s ease;
      }

      tbody tr:hover {
        background: #f8f9ff;
        transform: scale(1.01);
      }

      tbody tr:last-child {
        border-bottom: none;
      }

      .actions {
        display: flex;
        gap: 10px;
      }

      .btn-edit {
        background: #4caf50;
        color: white;
        padding: 8px 20px;
        border-radius: 20px;
        text-decoration: none;
        font-size: 14px;
        transition: all 0.3s ease;
      }

      .btn-edit:hover {
        background: #45a049;
        transform: translateY(-2px);
      }

      .btn-delete {
        background: #f44336;
        color: white;
        padding: 8px 20px;
        border-radius: 20px;
        text-decoration: none;
        font-size: 14px;
        transition: all 0.3s ease;
      }

      .btn-delete:hover {
        background: #da190b;
        transform: translateY(-2px);
      }

      .empty-state {
        text-align: center;
        padding: 60px 20px;
        color: #999;
      }

      @media (max-width: 768px) {
        .container {
          padding: 20px;
        }

        table {
          font-size: 14px;
        }

        th,
        td {
          padding: 10px;
        }

        .actions {
          flex-direction: column;
        }
      }
    </style>
  </head>
  <body>
    <div class="container">
      <h2>📋 Gestão de Clientes</h2>

      <!-- Mensagens de Sucesso -->
      <c:if test="${not empty sucesso}">
        <div class="alert alert-success">
          <span class="alert-icon">✅</span>
          <span>${sucesso}</span>
        </div>
      </c:if>

      <!-- Mensagens de Erro -->
      <c:if test="${not empty erro}">
        <div class="alert alert-error">
          <span class="alert-icon">❌</span>
          <span>${erro}</span>
        </div>
      </c:if>

      <div class="header">
        <div></div>
        <a href="/clientes/novo" class="btn btn-primary">➕ Novo Cliente</a>
      </div>

      <c:choose>
        <c:when test="${empty clientes}">
          <div class="empty-state">
            <div style="font-size: 80px">📭</div>
            <h3>Nenhum cliente cadastrado</h3>
            <p>Comece adicionando seu primeiro cliente!</p>
          </div>
        </c:when>
        <c:otherwise>
          <table>
            <thead>
              <tr>
                <th>ID</th>
                <th>Nome</th>
                <th>Email</th>
                <th>Telefone</th>
                <th>Ações</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="c" items="${clientes}">
                <tr>
                  <td><strong>#${c.id}</strong></td>
                  <td>${c.nome}</td>
                  <td>${c.email}</td>
                  <td>${c.telefone}</td>
                  <td>
                    <div class="actions">
                      <a href="/clientes/editar/${c.id}" class="btn-edit"
                        >🖊️ Editar</a
                      >
                      <a
                        href="/clientes/excluir/${c.id}"
                        class="btn-delete"
                        onclick="return confirm('⚠️ Deseja realmente excluir o cliente ${c.nome}?')"
                        >🗑️ Excluir</a
                      >
                    </div>
                  </td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </c:otherwise>
      </c:choose>
    </div>
  </body>
</html>
