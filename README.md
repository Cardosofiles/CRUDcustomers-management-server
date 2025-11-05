# 📋 Sistema de Gestão de Clientes — CRUD Completo

![Java](https://img.shields.io/badge/Java-17-orange)
![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.5.7-brightgreen)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15-blue)
![Docker](https://img.shields.io/badge/Docker-Compose-blue)
![JPA](https://img.shields.io/badge/JPA-Hibernate-yellow)
![Build](https://img.shields.io/badge/Build-Maven-blueviolet)

Aplicação web MVC para gerenciamento de clientes com CRUD completo, validação de dados e interface server-rendered (JSP). Inclui ambiente Docker para desenvolvimento simples e reprodutível.

---

## 🧭 Sumário

- Visão Geral
- Arquitetura
- Estrutura de Diretórios
- Pré-requisitos
- Quick Start
  - Executar com Docker
  - Executar localmente (sem Docker)
- Configuração
- Principais Rotas (Web) e Endpoints
- Funcionalidades
- Fluxo de Dados
- Validações
- Desenvolvimento
- Testes
- Troubleshooting
- FAQ
- Contribuição
- Licença

---

## 🌟 Visão Geral

- CRUD de clientes com Spring Boot, JPA/Hibernate e PostgreSQL.
- Views em JSP (server-side rendering) com JSTL.
- Validações robustas (Bean Validation) e mensagens amigáveis.
- Containerização com Docker e Docker Compose.

---

## 🏗️ Arquitetura

Padrão MVC em camadas:

- Model: entidades JPA + regras de domínio simples.
- Repository: acesso a dados via Spring Data JPA.
- Service: orquestra lógica de negócio/validações.
- Controller: mapeia rotas, processa requisições e retorna views JSP.
- View: JSP + JSTL para apresentação.

---

## 📂 Estrutura de Diretórios

```
src
└── main
    ├── java
    │   └── com
    │       └── exemplo
    │           ├── config
    │           ├── controller
    │           ├── model
    │           ├── repository
    │           └── service
    └── resources
        ├── static
        ├── templates
        └── application.properties
```

Observação: Em projetos com JSP é comum usar src/main/webapp/WEB-INF/jsp. Caso seu projeto utilize templates em resources/templates, mantenha a configuração de ViewResolver coerente.

---

## ✅ Pré-requisitos

- Java 17+
- Maven 3.8+
- Docker e Docker Compose (opcional, mas recomendado)
- PostgreSQL 15+ (se executar sem Docker)

---

## ⚡ Quick Start

### Opção A) Executar com Docker (recomendado)

1. Clonar o repositório:

```bash
git clone https://github.com/exemplo/projeto.git
cd projeto
```

2. Subir os serviços:

```bash
docker-compose up --build
```

3. Acessar:

- App: http://localhost:8080
- Banco (container): localhost:5432

Para encerrar:

```bash
docker-compose down
```

### Opção B) Executar localmente (sem Docker)

1. Configurar PostgreSQL e criar banco:

```sql
CREATE DATABASE clientesdb;
CREATE USER clientesuser WITH ENCRYPTED PASSWORD 'clientespass';
GRANT ALL PRIVILEGES ON DATABASE clientesdb TO clientesuser;
```

2. Configurar variáveis de ambiente (opcional, recomendado):

```bash
export DB_HOST=localhost
export DB_PORT=5432
export DB_NAME=clientesdb
export DB_USER=clientesuser
export DB_PASSWORD=clientespass
export SPRING_PROFILES_ACTIVE=dev
```

3. Ajustar application.properties (ver seção Configuração).

4. Rodar a aplicação:

```bash
./mvnw spring-boot:run
# ou
mvn clean package
java -jar target/*.jar
```

5. Acessar em http://localhost:8080

---

## 🔧 Configuração

Exemplo de application.properties (perfil default):

```properties
spring.datasource.url=jdbc:postgresql://${DB_HOST:localhost}:${DB_PORT:5432}/${DB_NAME:clientesdb}
spring.datasource.username=${DB_USER:clientesuser}
spring.datasource.password=${DB_PASSWORD:clientespass}

spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.format_sql=true

spring.mvc.view.prefix=/WEB-INF/jsp/
spring.mvc.view.suffix=.jsp

server.port=8080
```

- Ajuste o ViewResolver conforme a localização das JSP (WEB-INF/jsp ou resources/templates via outro engine).
- ddl-auto=update é prático em dev; para prod prefira migrações (Flyway/Liquibase).

---

## 🌐 Principais Rotas (Web) e Endpoints

Rotas Web (JSP):

- GET /clientes — lista clientes
- GET /clientes/novo — formulário de criação
- POST /clientes — criação
- GET /clientes/{id}/editar — formulário de edição
- POST/PUT /clientes/{id} — atualização
- POST/DELETE /clientes/{id}/excluir — exclusão

API REST (se exposta):

- GET /api/clientes
- GET /api/clientes/{id}
- POST /api/clientes
- PUT /api/clientes/{id}
- DELETE /api/clientes/{id}

Observação: Caso o projeto não disponibilize a API REST, utilize apenas as rotas Web.

---

## 🧰 Funcionalidades

- Cadastro completo de clientes com:
  - Nome completo
  - CPF (com validação e máscara)
  - Data de nascimento
  - Múltiplos contatos (telefone) - mínimo 1 obrigatório
  - Múltiplos emails - mínimo 1 obrigatório
  - Endereço completo (rua, número, bairro, CEP, cidade, estado)
- Listagem de clientes com informações resumidas
- Edição de clientes mantendo relacionamentos
- Exclusão em cascata (remove contatos, emails e endereço)
- Validações robustas no backend e frontend
- Máscaras automáticas (CPF, telefone, CEP)
- Interface responsiva e moderna

## 📊 Modelo de Dados

### Entidades

- **Client**: entidade principal

  - id, nome, cpf, dataNascimento
  - Relacionamentos: OneToMany com Contato e Email, OneToOne com Endereco

- **Contato**: múltiplos telefones por cliente

  - id, telefone, tipo (Celular/Fixo/Comercial)
  - ManyToOne com Client

- **Email**: múltiplos emails por cliente

  - id, endereco, tipo (Pessoal/Comercial)
  - ManyToOne com Client

- **Endereco**: um endereço por cliente
  - id, rua, numero, bairro, cep, cidade, estado, complemento
  - OneToOne com Client

---

## 🔄 Fluxo de Dados

1. Usuário interage com a UI (JSP).
2. Controller recebe, valida e delega ao Service.
3. Service aplica regras e usa Repository.
4. Repository persiste/consulta no PostgreSQL via JPA.
5. Controller retorna Model para a JSP renderizar.

---

## 🛡️ Validações

### Backend (Bean Validation)

- Nome: obrigatório, 3-100 caracteres
- CPF: obrigatório, formato 000.000.000-00, único
- Data de nascimento: obrigatória, no passado
- Contatos: mínimo 1, formato (00) 00000-0000
- Emails: mínimo 1, formato válido
- Endereço: todos os campos obrigatórios, CEP formato 00000-000

### Frontend (JavaScript)

- Máscaras automáticas (CPF, telefone, CEP)
- Validação de formato em tempo real
- Adição/remoção dinâmica de contatos e emails
- Confirmação de exclusão

---

## 🧑‍💻 Desenvolvimento

Comandos úteis:

```bash
# Rodar local
mvn spring-boot:run

# Build do artefato
mvn clean package

# Ver dependências
mvn dependency:tree

# Formatar/checar (se plugins configurados)
mvn spotless:apply
mvn checkstyle:check
```

Hot reload:

- Recomenda-se Spring DevTools em dev (dependência opcional).

Logs:

- Ajuste níveis via application.properties (logging.level.\*).

---

## 🧪 Testes

- Unitários: Service/Validator.
- Integração: Repository (com @DataJpaTest) e Controller (MockMvc).
- Executar:

```bash
mvn test
```

Sugestão: use Testcontainers para testes de integração com PostgreSQL real.

---

## 🐞 Troubleshooting

- Porta 8080 ocupada: ajuste server.port=8081 (ou export SERVER_PORT=8081).
- Erro de conexão com DB:
  - Verifique variáveis DB\_\* e acessibilidade do host/porta.
  - Confirme credenciais e permissões no PostgreSQL.
- ddl-auto=update não criou tabelas:
  - Cheque logs do Hibernate.
  - Verifique se o schema está correto e o usuário tem privilégios.
- JSP não encontrada:
  - Confira prefix/suffix do ViewResolver e o caminho físico das JSP.
- Docker não sobe:
  - Rode docker-compose logs -f para identificar o serviço com falha.
  - Verifique se as portas 8080/5432 estão livres.

---

## ❓ FAQ

- Posso usar outro banco?
  - Sim. Ajuste driver, URL e dependências (ex.: MySQL) no pom e properties.
- Posso trocar JSP por Thymeleaf?
  - Sim. Adicione o starter, mova views para resources/templates e ajuste o ViewResolver.
- Como versionar schema?
  - Adote Flyway ou Liquibase com scripts versionados.

---

## 🤝 Contribuição

- Abra uma issue descrevendo o que deseja alterar.
- Crie um fork/branch e envie um PR pequeno e objetivo.
- Inclua testes quando possível.

---

## 📄 Licença

Defina a licença do projeto (ex.: MIT) e inclua o arquivo LICENSE na raiz.

---

## 🔗 Recursos

- Spring Boot Docs: https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/
- PostgreSQL Docs: https://www.postgresql.org/docs/
- Docker Get Started: https://docs.docker.com/get-started/

---
