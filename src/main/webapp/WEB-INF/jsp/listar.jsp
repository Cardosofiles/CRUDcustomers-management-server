<!-- filepath: /home/cardosofiles/www/github/faculty/v2-internet-programming/src/main/webapp/WEB-INF/jsp/listar.jsp -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> <%@ page
import="java.time.format.DateTimeFormatter" %>
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
        background: linear-gradient(135deg, #667eea 0%, #444444 100%);
        min-height: 100vh;
        padding: 20px;
      }

      .container {
        max-width: 1500px;
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

      .alert {
        padding: 15px 20px;
        border-radius: 10px;
        margin-bottom: 20px;
        display: flex;
        align-items: center;
        gap: 10px;
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

      .header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 30px;
      }

      .btn-primary {
        display: inline-block;
        padding: 12px 30px;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        text-decoration: none;
        border-radius: 50px;
        font-weight: 600;
        transition: all 0.3s ease;
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
      }

      tbody tr {
        border-bottom: 1px solid #f0f0f0;
        transition: all 0.3s ease;
      }

      tbody tr:hover {
        background: #f8f9ff;
      }

      .actions {
        display: flex;
        gap: 10px;
      }

      .btn-edit,
      .btn-delete {
        padding: 8px 20px;
        border-radius: 20px;
        text-decoration: none;
        font-size: 14px;
        transition: all 0.3s ease;
      }

      .btn-edit {
        background: #4caf50;
        color: white;
      }

      .btn-edit:hover {
        background: #45a049;
      }

      .btn-delete {
        background: #f44336;
        color: white;
      }

      .btn-delete:hover {
        background: #da190b;
      }

      .contact-list,
      .email-list {
        font-size: 13px;
        color: #666;
      }

      .contact-item,
      .email-item {
        display: block;
        padding: 2px 0;
      }

      .badge {
        display: inline-block;
        padding: 2px 8px;
        background: #e9ecef;
        border-radius: 10px;
        font-size: 11px;
        margin-left: 5px;
      }

      .address-text {
        font-size: 13px;
        line-height: 1.4;
        color: #666;
      }

      .address-line {
        display: block;
      }
    </style>
  </head>
  <body>
    <div class="container">
      <h2>📋 Gestão de Clientes</h2>

      <c:if test="${not empty sucesso}">
        <div class="alert alert-success">
          <span>✅</span>
          <span>${sucesso}</span>
        </div>
      </c:if>

      <c:if test="${not empty erro}">
        <div class="alert alert-error">
          <span>❌</span>
          <span>${erro}</span>
        </div>
      </c:if>

      <div class="header">
        <div></div>
        <a href="/clientes/novo" class="btn-primary">➕ Novo Cliente</a>
      </div>

      <c:choose>
        <c:when test="${empty clientes}">
          <div style="text-align: center; padding: 60px; color: #999">
            <div style="font-size: 80px">📭</div>
            <h3>Nenhum cliente cadastrado</h3>
            <p>Comece adicionando seu primeiro cliente!</p>
          </div>
        </c:when>
        <c:otherwise>
          <table>
            <thead>
              <tr>
                <th>Nome</th>
                <th>CPF</th>
                <th>Data Nasc.</th>
                <th>Contatos</th>
                <th>Emails</th>
                <th>Endereço Completo</th>
                <th>Ações</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="c" items="${clientes}">
                <tr>
                  <td><strong>${c.nome}</strong></td>
                  <td>${c.cpf}</td>
                  <td>
                    <c:set var="formatter" value="<%=
                    DateTimeFormatter.ofPattern(\"dd/MM/yyyy\") %>" />
                    ${c.dataNascimento.format(formatter)}
                  </td>
                  <td>
                    <div class="contact-list">
                      <c:forEach
                        var="contato"
                        items="${c.contatos}"
                        varStatus="status"
                      >
                        <span class="contact-item">
                          ${contato.telefone}
                          <span class="badge">${contato.tipo}</span>
                        </span>
                      </c:forEach>
                    </div>
                  </td>
                  <td>
                    <div class="email-list">
                      <c:forEach
                        var="email"
                        items="${c.emails}"
                        varStatus="status"
                      >
                        <span class="email-item">
                          ${email.endereco}
                          <span class="badge">${email.tipo}</span>
                        </span>
                      </c:forEach>
                    </div>
                  </td>
                  <td>
                    <div class="address-text">
                      <span class="address-line"
                        >${c.endereco.rua}, ${c.endereco.numero}</span
                      >
                      <span class="address-line">${c.endereco.bairro}</span>
                      <c:if test="${not empty c.endereco.complemento}">
                        <span class="address-line"
                          >${c.endereco.complemento}</span
                        >
                      </c:if>
                      <span class="address-line">CEP: ${c.endereco.cep}</span>
                      <span class="address-line"
                        ><strong
                          >${c.endereco.cidade}/${c.endereco.estado}</strong
                        ></span
                      >
                    </div>
                  </td>
                  <td>
                    <div class="actions">
                      <a href="/clientes/editar/${c.id}" class="btn-edit"
                        >🖊️ Editar</a
                      >
                      <a
                        href="/clientes/excluir/${c.id}"
                        class="btn-delete"
                        onclick="return confirm('⚠️ Deseja realmente excluir ${c.nome}?')"
                      >
                        🗑️ Excluir
                      </a>
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
