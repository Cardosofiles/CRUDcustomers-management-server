<!-- filepath: /home/cardosofiles/www/github/faculty/v2-internet-programming/src/main/webapp/WEB-INF/jsp/form.jsp -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>${cliente.id != null ? 'Editar' : 'Novo'} Cliente</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #005ed9 0%, #09b6b9 35%, #041021 100%);

            min-height: 100vh;
            padding: 20px;
        }
        
        .container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            padding: 40px;
            max-width: 900px;
            margin: 0 auto;
        }
        
        h2 {
            color: #333;
            margin-bottom: 30px;
            font-size: 2em;
            text-align: center;
            background: linear-gradient(135deg, #667eea 0%, #272627 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        
        .alert-error {
            background: #f8d7da;
            border: 2px solid #dc3545;
            color: #721c24;
            padding: 15px 20px;
            border-radius: 10px;
            margin-bottom: 20px;
        }
        
        .section {
            margin-bottom: 30px;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 10px;
        }
        
        .section-title {
            font-size: 1.3em;
            color: #667eea;
            margin-bottom: 15px;
            font-weight: 600;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }
        
        .form-group {
            display: flex;
            flex-direction: column;
        }
        
        label {
            display: block;
            margin-bottom: 8px;
            color: #555;
            font-weight: 600;
            font-size: 14px;
        }
        
        input[type="text"],
        input[type="email"],
        input[type="date"],
        select {
            width: 100%;
            padding: 12px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.3s ease;
        }
        
        input:focus, select:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        .dynamic-list {
            margin-top: 10px;
        }
        
        .dynamic-item {
            display: flex;
            gap: 10px;
            margin-bottom: 10px;
            align-items: flex-end;
        }
        
        .btn-add, .btn-remove {
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn-add {
            background: #28a745;
            color: white;
            margin-top: 10px;
        }
        
        .btn-add:hover { background: #218838; }
        
        .btn-remove {
            background: #dc3545;
            color: white;
        }
        
        .btn-remove:hover { background: #c82333; }
        
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
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .btn-primary:hover { transform: translateY(-2px); }
        
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        
        .btn-secondary:hover { background: #5a6268; }
    </style>
</head>
<body>
<div class="container">
    <h2>${cliente.id != null ? '✏️ Editar Cliente' : '➕ Novo Cliente'}</h2>
    
    <c:if test="${not empty erro}">
        <div class="alert-error">⚠️ <strong>Erro:</strong> ${erro}</div>
    </c:if>
    
    <form action="/clientes/salvar" method="post" id="clientForm">
        <input type="hidden" name="id" value="${cliente.id}"/>
        
        <!-- Dados Pessoais -->
        <div class="section">
            <div class="section-title">👤 Dados Pessoais</div>
            <div class="form-row">
                <div class="form-group">
                    <label for="nome">Nome Completo *</label>
                    <input type="text" id="nome" name="nome" value="${cliente.nome}" required/>
                </div>
                <div class="form-group">
                    <label for="cpf">CPF *</label>
                    <input type="text" id="cpf" name="cpf" value="${cliente.cpf}" 
                           placeholder="000.000.000-00" required maxlength="14"/>
                </div>
                <div class="form-group">
                    <label for="dataNascimento">Data de Nascimento *</label>
                    <input type="date" id="dataNascimento" name="dataNascimento" 
                           value="${cliente.dataNascimento}" required/>
                </div>
            </div>
        </div>
        
        <!-- Contatos -->
        <div class="section">
            <div class="section-title">📱 Contatos</div>
            <div id="contatosContainer">
                <c:choose>
                    <c:when test="${not empty cliente.contatos}">
                        <c:forEach var="contato" items="${cliente.contatos}" varStatus="status">
                            <div class="dynamic-item">
                                <div class="form-group" style="flex: 2;">
                                    <label>Telefone ${status.index == 0 ? '*' : ''}</label>
                                    <input type="text" name="contato[]" class="telefone" 
                                           value="${contato.telefone}" placeholder="(00) 00000-0000" 
                                           ${status.index == 0 ? 'required' : ''}/>
                                </div>
                                <div class="form-group" style="flex: 1;">
                                    <label>Tipo</label>
                                    <select name="tipoContato[]">
                                        <option value="Celular" ${contato.tipo == 'Celular' ? 'selected' : ''}>Celular</option>
                                        <option value="Fixo" ${contato.tipo == 'Fixo' ? 'selected' : ''}>Fixo</option>
                                        <option value="Comercial" ${contato.tipo == 'Comercial' ? 'selected' : ''}>Comercial</option>
                                    </select>
                                </div>
                                <c:if test="${status.index > 0}">
                                    <button type="button" class="btn-remove" onclick="removeItem(this)">🗑️</button>
                                </c:if>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="dynamic-item">
                            <div class="form-group" style="flex: 2;">
                                <label>Telefone *</label>
                                <input type="text" name="contato[]" class="telefone" 
                                       placeholder="(00) 00000-0000" required/>
                            </div>
                            <div class="form-group" style="flex: 1;">
                                <label>Tipo</label>
                                <select name="tipoContato[]">
                                    <option value="Celular">Celular</option>
                                    <option value="Fixo">Fixo</option>
                                    <option value="Comercial">Comercial</option>
                                </select>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
            <button type="button" class="btn-add" onclick="addContato()">➕ Adicionar Contato</button>
        </div>
        
        <!-- Emails -->
        <div class="section">
            <div class="section-title">📧 Emails</div>
            <div id="emailsContainer">
                <c:choose>
                    <c:when test="${not empty cliente.emails}">
                        <c:forEach var="email" items="${cliente.emails}" varStatus="status">
                            <div class="dynamic-item">
                                <div class="form-group" style="flex: 2;">
                                    <label>Email ${status.index == 0 ? '*' : ''}</label>
                                    <input type="email" name="email[]" value="${email.endereco}" 
                                           placeholder="exemplo@email.com" ${status.index == 0 ? 'required' : ''}/>
                                </div>
                                <div class="form-group" style="flex: 1;">
                                    <label>Tipo</label>
                                    <select name="tipoEmail[]">
                                        <option value="Pessoal" ${email.tipo == 'Pessoal' ? 'selected' : ''}>Pessoal</option>
                                        <option value="Comercial" ${email.tipo == 'Comercial' ? 'selected' : ''}>Comercial</option>
                                    </select>
                                </div>
                                <c:if test="${status.index > 0}">
                                    <button type="button" class="btn-remove" onclick="removeItem(this)">🗑️</button>
                                </c:if>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="dynamic-item">
                            <div class="form-group" style="flex: 2;">
                                <label>Email *</label>
                                <input type="email" name="email[]" placeholder="exemplo@email.com" required/>
                            </div>
                            <div class="form-group" style="flex: 1;">
                                <label>Tipo</label>
                                <select name="tipoEmail[]">
                                    <option value="Pessoal">Pessoal</option>
                                    <option value="Comercial">Comercial</option>
                                </select>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
            <button type="button" class="btn-add" onclick="addEmail()">➕ Adicionar Email</button>
        </div>
        
        <!-- Endereço -->
        <div class="section">
            <div class="section-title">🏠 Endereço</div>
            <div class="form-row">
                <div class="form-group" style="grid-column: 1 / -1;">
                    <label for="rua">Rua *</label>
                    <input type="text" id="rua" name="rua" value="${cliente.endereco.rua}" required/>
                </div>
                <div class="form-group">
                    <label for="numero">Número *</label>
                    <input type="text" id="numero" name="numero" value="${cliente.endereco.numero}" required/>
                </div>
                <div class="form-group">
                    <label for="bairro">Bairro *</label>
                    <input type="text" id="bairro" name="bairro" value="${cliente.endereco.bairro}" required/>
                </div>
                <div class="form-group">
                    <label for="cep">CEP *</label>
                    <input type="text" id="cep" name="cep" value="${cliente.endereco.cep}" 
                           placeholder="00000-000" required maxlength="9"/>
                </div>
                <div class="form-group">
                    <label for="cidade">Cidade *</label>
                    <input type="text" id="cidade" name="cidade" value="${cliente.endereco.cidade}" required/>
                </div>
                <div class="form-group">
                    <label for="estado">Estado *</label>
                    <select id="estado" name="estado" required>
                        <option value="">Selecione</option>
                        <option value="AC" ${cliente.endereco.estado == 'AC' ? 'selected' : ''}>AC</option>
                        <option value="AL" ${cliente.endereco.estado == 'AL' ? 'selected' : ''}>AL</option>
                        <option value="AP" ${cliente.endereco.estado == 'AP' ? 'selected' : ''}>AP</option>
                        <option value="AM" ${cliente.endereco.estado == 'AM' ? 'selected' : ''}>AM</option>
                        <option value="BA" ${cliente.endereco.estado == 'BA' ? 'selected' : ''}>BA</option>
                        <option value="CE" ${cliente.endereco.estado == 'CE' ? 'selected' : ''}>CE</option>
                        <option value="DF" ${cliente.endereco.estado == 'DF' ? 'selected' : ''}>DF</option>
                        <option value="ES" ${cliente.endereco.estado == 'ES' ? 'selected' : ''}>ES</option>
                        <option value="GO" ${cliente.endereco.estado == 'GO' ? 'selected' : ''}>GO</option>
                        <option value="MA" ${cliente.endereco.estado == 'MA' ? 'selected' : ''}>MA</option>
                        <option value="MT" ${cliente.endereco.estado == 'MT' ? 'selected' : ''}>MT</option>
                        <option value="MS" ${cliente.endereco.estado == 'MS' ? 'selected' : ''}>MS</option>
                        <option value="MG" ${cliente.endereco.estado == 'MG' ? 'selected' : ''}>MG</option>
                        <option value="PA" ${cliente.endereco.estado == 'PA' ? 'selected' : ''}>PA</option>
                        <option value="PB" ${cliente.endereco.estado == 'PB' ? 'selected' : ''}>PB</option>
                        <option value="PR" ${cliente.endereco.estado == 'PR' ? 'selected' : ''}>PR</option>
                        <option value="PE" ${cliente.endereco.estado == 'PE' ? 'selected' : ''}>PE</option>
                        <option value="PI" ${cliente.endereco.estado == 'PI' ? 'selected' : ''}>PI</option>
                        <option value="RJ" ${cliente.endereco.estado == 'RJ' ? 'selected' : ''}>RJ</option>
                        <option value="RN" ${cliente.endereco.estado == 'RN' ? 'selected' : ''}>RN</option>
                        <option value="RS" ${cliente.endereco.estado == 'RS' ? 'selected' : ''}>RS</option>
                        <option value="RO" ${cliente.endereco.estado == 'RO' ? 'selected' : ''}>RO</option>
                        <option value="RR" ${cliente.endereco.estado == 'RR' ? 'selected' : ''}>RR</option>
                        <option value="SC" ${cliente.endereco.estado == 'SC' ? 'selected' : ''}>SC</option>
                        <option value="SP" ${cliente.endereco.estado == 'SP' ? 'selected' : ''}>SP</option>
                        <option value="SE" ${cliente.endereco.estado == 'SE' ? 'selected' : ''}>SE</option>
                        <option value="TO" ${cliente.endereco.estado == 'TO' ? 'selected' : ''}>TO</option>
                    </select>
                </div>
                <div class="form-group" style="grid-column: 1 / -1;">
                    <label for="complemento">Complemento</label>
                    <input type="text" id="complemento" name="complemento" value="${cliente.endereco.complemento}"/>
                </div>
            </div>
        </div>
        
        <div class="button-group">
            <button type="submit" class="btn btn-primary">💾 Salvar</button>
            <a href="/clientes" class="btn btn-secondary">↩️ Cancelar</a>
        </div>
    </form>
</div>

<script>
    // Máscara CPF
    document.getElementById('cpf').addEventListener('input', function(e) {
        let value = e.target.value.replace(/\D/g, '');
        value = value.replace(/(\d{3})(\d)/, '$1.$2');
        value = value.replace(/(\d{3})(\d)/, '$1.$2');
        value = value.replace(/(\d{3})(\d{1,2})$/, '$1-$2');
        e.target.value = value;
    });
    
    // Máscara CEP
    document.getElementById('cep').addEventListener('input', function(e) {
        let value = e.target.value.replace(/\D/g, '');
        value = value.replace(/(\d{5})(\d)/, '$1-$2');
        e.target.value = value;
    });
    
    // Máscara Telefone (aplicada dinamicamente)
    function applyPhoneMask(input) {
        input.addEventListener('input', function(e) {
            let value = e.target.value.replace(/\D/g, '');
            if (value.length <= 10) {
                value = value.replace(/(\d{2})(\d{4})(\d{4})/, '($1) $2-$3');
            } else {
                value = value.replace(/(\d{2})(\d{5})(\d{4})/, '($1) $2-$3');
            }
            e.target.value = value;
        });
    }
    
    document.querySelectorAll('.telefone').forEach(applyPhoneMask);
    
    function addContato() {
        const container = document.getElementById('contatosContainer');
        const div = document.createElement('div');
        div.className = 'dynamic-item';
        div.innerHTML = `
            <div class="form-group" style="flex: 2;">
                <label>Telefone</label>
                <input type="text" name="contato[]" class="telefone" placeholder="(00) 00000-0000"/>
            </div>
            <div class="form-group" style="flex: 1;">
                <label>Tipo</label>
                <select name="tipoContato[]">
                    <option value="Celular">Celular</option>
                    <option value="Fixo">Fixo</option>
                    <option value="Comercial">Comercial</option>
                </select>
            </div>
            <button type="button" class="btn-remove" onclick="removeItem(this)">🗑️</button>
        `;
        container.appendChild(div);
        applyPhoneMask(div.querySelector('.telefone'));
    }
    
    function addEmail() {
        const container = document.getElementById('emailsContainer');
        const div = document.createElement('div');
        div.className = 'dynamic-item';
        div.innerHTML = `
            <div class="form-group" style="flex: 2;">
                <label>Email</label>
                <input type="email" name="email[]" placeholder="exemplo@email.com"/>
            </div>
            <div class="form-group" style="flex: 1;">
                <label>Tipo</label>
                <select name="tipoEmail[]">
                    <option value="Pessoal">Pessoal</option>
                    <option value="Comercial">Comercial</option>
                </select>
            </div>
            <button type="button" class="btn-remove" onclick="removeItem(this)">🗑️</button>
        `;
        container.appendChild(div);
    }
    
    function removeItem(btn) {
        btn.parentElement.remove();
    }
</script>
</body>
</html>