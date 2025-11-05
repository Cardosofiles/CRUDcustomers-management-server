# 🎓 Guia de Apresentação: Sistema de Gestão de Clientes

**Objetivo:** Apresentar de forma didática e profissional um sistema CRUD completo usando Spring Boot, JSP, PostgreSQL e Docker.

**Público:** Estudantes de Engenharia de Software/Sistemas

**Duração estimada:** 45-60 minutos

---

## 📋 Sumário da Apresentação

### 📑 Navegação Rápida

| Seção                                                | Tópico                                     | Duração |
| ---------------------------------------------------- | ------------------------------------------ | ------- |
| [1️⃣](#1️⃣-visão-geral-e-arquitetura)                  | Visão Geral e Arquitetura                  | 5 min   |
| [2️⃣](#2️⃣-configuração-e-dependências-pomxml)         | Configuração e Dependências (pom.xml)      | 5 min   |
| [3️⃣](#3️⃣-containerização-docker-composeyml)          | Containerização (docker-compose.yml)       | 3 min   |
| [4️⃣](#4️⃣-camada-de-modelo-entidades-jpa)             | Camada de Modelo (Entidades JPA)           | 5 min   |
| [5️⃣](#5️⃣-camada-de-persistência-repositories)        | Camada de Persistência (Repositories)      | 4 min   |
| [6️⃣](#6️⃣-camada-de-negócio-services)                 | Camada de Negócio (Services)               | 4 min   |
| [7️⃣](#7️⃣-camada-de-controle-controllers)             | Camada de Controle (Controllers)           | 3 min   |
| [8️⃣](#8️⃣-camada-de-visualização-jsp)                 | Camada de Visualização (JSP)               | 3 min   |
| [9️⃣](#9️⃣-fluxo-completo-de-uma-requisição)           | Fluxo Completo de uma Requisição           | 5 min   |
| [🔟](#🔟-melhores-práticas-e-insights-profissionais) | Melhores Práticas e Insights Profissionais | 5 min   |

### 📚 Recursos Complementares

- [🎤 Roteiro de Apresentação](#🎤-roteiro-de-apresentação-sugestão)
- [📚 Conceitos-Chave para Dominar](#📚-conceitos-chave-para-dominar)
- [🏆 Dicas Finais para Brilhar](#🏆-dicas-finais-para-brilhar)
- [📖 Glossário de Termos](#📖-glossário-de-termos)
- [🎯 Checklist Pré-Apresentação](#🎯-checklist-pré-apresentação)
- [💡 Frases de Impacto](#💡-frases-de-impacto-para-usar)

---

## 1️⃣ Visão Geral e Arquitetura

### 🎯 O que vamos construir?

Um sistema web completo para **gerenciar clientes** com:

- Cadastro de dados pessoais (nome, CPF, data de nascimento)
- Múltiplos contatos (telefones)
- Múltiplos emails
- Endereço completo

### 🏗️ Arquitetura em Camadas (MVC + Service)

**Analogia:** Pense em uma empresa organizada em departamentos:

```
┌─────────────────────────────────────────┐
│         VIEW (JSP)                      │  ← Interface com usuário (recepção)
│  "O que o usuário vê e interage"       │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│       CONTROLLER                        │  ← Gerente que recebe pedidos
│  "Recebe requisições e coordena"       │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│         SERVICE                         │  ← Departamento de negócios
│  "Aplica regras e validações"          │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│       REPOSITORY                        │  ← Arquivista/almoxarifado
│  "Acessa e persiste dados"             │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│     DATABASE (PostgreSQL)               │  ← Arquivo físico
│  "Armazena os dados"                   │
└─────────────────────────────────────────┘
```

**Por que essa arquitetura?**

- ✅ **Separação de responsabilidades** (cada camada tem um propósito claro)
- ✅ **Manutenibilidade** (mudanças em uma camada não quebram outras)
- ✅ **Testabilidade** (cada camada pode ser testada isoladamente)
- ✅ **Escalabilidade** (fácil adicionar funcionalidades)

---

## 2️⃣ Configuração e Dependências (pom.xml)

### 📦 O que é o Maven?

**Analogia:** Maven é como um **gerente de compras** que:

1. Busca as bibliotecas (dependências) que você precisa
2. Garante que as versões sejam compatíveis
3. Gerencia o ciclo de build (compilação, testes, empacotamento)

### 🔑 Pontos-chave do pom.xml

```xml
<!-- filepath: pom.xml (conceitual) -->
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>3.5.7</version>
</parent>
```

**💡 Insight:** O `parent` é como herdar uma receita pronta. Spring Boot já configura:

- Versões de dependências compatíveis
- Plugins Maven pré-configurados
- Configurações sensatas (convenção sobre configuração)

#### Dependências Principais

```xml
<!-- 1. Spring Boot Web (MVC + Tomcat embutido) -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>
```

**O que faz?** Traz todo o ecossistema web: Spring MVC, servidor Tomcat, JSON, validações.

```xml
<!-- 2. Spring Data JPA (ORM + Hibernate) -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-jpa</artifactId>
</dependency>
```

**O que faz?** Permite mapear classes Java para tabelas SQL (ORM) e usar repositórios com métodos prontos.

```xml
<!-- 3. PostgreSQL Driver -->
<dependency>
    <groupId>org.postgresql</groupId>
    <artifactId>postgresql</artifactId>
    <scope>runtime</scope>
</dependency>
```

**O que faz?** Driver JDBC para conectar ao banco PostgreSQL.

```xml
<!-- 4. Tomcat Jasper (Compilador JSP) -->
<dependency>
    <groupId>org.apache.tomcat.embed</groupId>
    <artifactId>tomcat-embed-jasper</artifactId>
</dependency>
```

**O que faz?** Compila arquivos JSP (que são HTML com Java embutido) em servlets.

```xml
<!-- 5. JSTL (Tags JSP) -->
<dependency>
    <groupId>jakarta.servlet.jsp.jstl</groupId>
    <artifactId>jakarta.servlet.jsp.jstl-api</artifactId>
</dependency>
```

**O que faz?** Fornece tags prontas para loops, condicionais e formatação nas JSP (evita Java inline).

#### 🎯 Dica de Apresentação

> "Escolhemos essas dependências porque formam um ecossistema completo e maduro. Spring Boot elimina 90% da configuração manual que teríamos em projetos tradicionais."

---

## 3️⃣ Containerização (docker-compose.yml)

### 🐳 Por que Docker?

**Analogia:** Docker é como um **container de navio padronizado**.

- Garante que a aplicação rode **exatamente igual** em qualquer ambiente
- Isola dependências (banco, app, etc.)
- Facilita deploy e desenvolvimento em equipe

### 📄 Estrutura do docker-compose.yml

```yaml
# filepath: docker-compose.yml (conceitual)
version: "3.8"

services:
  postgres:
    image: postgres:15
    environment:
      POSTGRES_DB: clientesdb
      POSTGRES_USER: clientesuser
      POSTGRES_PASSWORD: clientespass
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

  app:
    build: .
    ports:
      - "8080:8080"
    depends_on:
      - postgres
    environment:
      DB_HOST: postgres
      DB_PORT: 5432

volumes:
  postgres_data:
```

#### 🔍 Explicação Linha por Linha

**`version: '3.8'`**

- Versão da sintaxe do Docker Compose (mantém compatibilidade)

**`services:`**

- Define os "containers" que vão subir (postgres e app)

**`postgres:` (serviço 1)**

- `image: postgres:15` → Usa imagem oficial do PostgreSQL 15
- `environment:` → Variáveis de ambiente (credenciais, nome do banco)
- `ports: "5432:5432"` → Mapeia porta do container (5432) para porta do host (5432)
- `volumes:` → Persiste dados mesmo se container for destruído

**`app:` (serviço 2)**

- `build: .` → Constrói imagem a partir do Dockerfile na raiz
- `depends_on:` → Garante que postgres suba antes do app
- `environment:` → Variáveis para conectar ao banco (DB_HOST=postgres)

**`volumes:` (global)**

- Armazena dados do PostgreSQL fisicamente no host

#### 💡 Insights para a Apresentação

> "Com Docker Compose, qualquer colega pode clonar o projeto e subir tudo com **um único comando**: `docker-compose up`. Isso elimina o famoso 'na minha máquina funciona'."

**Comando para demonstrar:**

```bash
docker-compose up --build
# Sobe banco + aplicação em segundos
```

---

## 4️⃣ Camada de Modelo (Entidades JPA)

### 🧩 O que são Entidades JPA?

**Analogia:** Entidades são **contratos** que definem como objetos Java se traduzem em tabelas SQL.

### 📘 Entidade Principal: Client.java

```java
// filepath: src/main/java/.../model/Client.java
@Entity
@Table(name = "clients")
public class Client {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "Nome é obrigatório")
    @Size(min = 3, max = 100)
    @Column(nullable = false, length = 100)
    private String nome;

    @NotBlank(message = "CPF é obrigatório")
    @Pattern(regexp = "\\d{3}\\.\\d{3}\\.\\d{3}-\\d{2}")
    @Column(nullable = false, unique = true, length = 14)
    private String cpf;

    @NotNull
    @Past(message = "Data deve ser no passado")
    @Column(nullable = false)
    private LocalDate dataNascimento;

    @OneToMany(mappedBy = "client", cascade = CascadeType.ALL, orphanRemoval = true)
    @Size(min = 1, message = "Mínimo 1 contato")
    private List<Contato> contatos = new ArrayList<>();

    @OneToMany(mappedBy = "client", cascade = CascadeType.ALL, orphanRemoval = true)
    @Size(min = 1, message = "Mínimo 1 email")
    private List<Email> emails = new ArrayList<>();

    @OneToOne(mappedBy = "client", cascade = CascadeType.ALL, orphanRemoval = true)
    @NotNull
    private Endereco endereco;

    // Getters, Setters, Construtores...
}
```

#### 🔑 Anotações Importantes

**`@Entity`**

- Marca a classe como entidade JPA (será mapeada para tabela)

**`@Table(name = "clients")`**

- Define nome da tabela no banco (se omitido, usa nome da classe)

**`@Id` + `@GeneratedValue`**

- `@Id` → Chave primária
- `strategy = IDENTITY` → Banco gera ID automaticamente (autoincremento)

**`@Column(nullable = false, unique = true)`**

- `nullable = false` → NOT NULL no SQL
- `unique = true` → Constraint UNIQUE

**Validações Bean Validation:**

- `@NotBlank` → Campo não pode ser vazio/null
- `@Size(min, max)` → Tamanho do texto
- `@Pattern(regexp)` → Validação com regex
- `@Past` → Data deve ser no passado

**Relacionamentos:**

```java
@OneToMany(mappedBy = "client", cascade = CascadeType.ALL, orphanRemoval = true)
private List<Contato> contatos;
```

**Tradução:**

- `@OneToMany` → Um cliente tem **muitos** contatos
- `mappedBy = "client"` → Campo `client` em `Contato` é o dono da relação
- `cascade = ALL` → Operações em Client afetam Contatos (salvar, deletar)
- `orphanRemoval = true` → Se remover contato da lista, deleta do banco

#### 💡 Insight Profissional

> "**LocalDate** é preferível a `Date` (legado). É parte da API moderna do Java 8+ (java.time), imutável e sem problemas de timezone."

> "Cascades facilitam o gerenciamento: salvar um Client salva automaticamente seus contatos, emails e endereço."

---

### 📘 Entidade Relacionada: Contato.java

```java
// filepath: src/main/java/.../model/Contato.java
@Entity
@Table(name = "contatos")
public class Contato {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank
    @Pattern(regexp = "\\(\\d{2}\\) \\d{4,5}-\\d{4}")
    @Column(nullable = false, length = 15)
    private String telefone;

    @Column(length = 20)
    private String tipo; // Celular, Fixo, Comercial

    @ManyToOne
    @JoinColumn(name = "client_id", nullable = false)
    private Client client;

    // Getters, Setters...
}
```

**`@ManyToOne`**

- **Muitos** contatos pertencem a **um** cliente
- Cria coluna `client_id` (FK) na tabela `contatos`

**`@JoinColumn(name = "client_id")`**

- Nome da coluna FK no banco

#### 🎯 Dica de Apresentação

> "Esse modelo resolve o problema de **1 cliente → N telefones**. Antes, precisávamos de campos telefone1, telefone2, telefone3... Com relacionamento, é escalável."

---

## 5️⃣ Camada de Persistência (Repositories)

### 🗄️ O que são Repositories?

**Analogia:** Repositories são **bibliotecários** especializados:

- Sabem onde buscar dados
- Guardam novos registros
- Atualizam e deletam conforme solicitado

### 📄 ClientRepository.java

```java
// filepath: src/main/java/.../repository/ClientRepository.java
@Repository
public interface ClientRepository extends JpaRepository<Client, Long> {

    Optional<Client> findByCpf(String cpf);

    boolean existsByCpfAndIdNot(String cpf, Long id);

    @Query("SELECT DISTINCT c FROM Client c LEFT JOIN FETCH c.endereco WHERE c.id = :id")
    Optional<Client> findByIdWithEndereco(@Param("id") Long id);

    @Query("SELECT DISTINCT c FROM Client c LEFT JOIN FETCH c.contatos WHERE c.id = :id")
    Optional<Client> findByIdWithContatos(@Param("id") Long id);

    @Query("SELECT DISTINCT c FROM Client c LEFT JOIN FETCH c.emails WHERE c.id = :id")
    Optional<Client> findByIdWithEmails(@Param("id") Long id);
}
```

#### 🔍 Explicação Detalhada

**`extends JpaRepository<Client, Long>`**

- Herda métodos prontos: `save()`, `findById()`, `findAll()`, `deleteById()`
- `<Client, Long>` → Tipo da entidade e tipo da chave primária

**Métodos Derivados (Query Methods):**

```java
Optional<Client> findByCpf(String cpf);
```

- Spring Data JPA **gera a query automaticamente** baseado no nome do método
- Traduz para: `SELECT * FROM clients WHERE cpf = ?`

```java
boolean existsByCpfAndIdNot(String cpf, Long id);
```

- Traduz para: `SELECT COUNT(*) > 0 FROM clients WHERE cpf = ? AND id <> ?`
- Útil para validar CPF único ao **editar** (ignora o próprio registro)

**Queries Customizadas (`@Query`):**

```java
@Query("SELECT DISTINCT c FROM Client c LEFT JOIN FETCH c.endereco WHERE c.id = :id")
Optional<Client> findByIdWithEndereco(@Param("id") Long id);
```

**Por que 3 queries separadas?**

- **Problema:** Hibernate não permite `JOIN FETCH` de múltiplas coleções (bags) simultaneamente
- **Solução:** Carregamos em 3 queries separadas dentro da mesma transação (cache L1)
- `LEFT JOIN FETCH` → Carrega a associação **eagerly** (evita N+1 queries)

#### 💡 Insight Profissional

> "**MultipleBagFetchException** é um erro comum. A solução é carregar uma coleção por query ou converter `List` para `Set`. Optamos por 3 queries por ser mais didático e funcional."

> "`Optional<Client>` é uma prática moderna que evita `NullPointerException`. Força o desenvolvedor a tratar explicitamente casos onde o registro não existe."

---

## 6️⃣ Camada de Negócio (Services)

### 🧠 O que são Services?

**Analogia:** Services são **especialistas de domínio**:

- Aplicam regras de negócio
- Validam dados complexos
- Orquestram múltiplas operações (transactions)

### 📄 ClientService.java

```java
// filepath: src/main/java/.../service/ClientService.java
@Service
public class ClientService {

    @Autowired
    private ClientRepository clientRepository;

    public List<Client> listarTodos() {
        return clientRepository.findAll();
    }

    @Transactional(readOnly = true)
    public Optional<Client> buscarPorId(Long id) {
        // Carrega em 3 queries para evitar MultipleBagFetchException
        Optional<Client> clientOpt = clientRepository.findByIdWithEndereco(id);

        if (clientOpt.isPresent()) {
            clientRepository.findByIdWithContatos(id); // força lazy load
            clientRepository.findByIdWithEmails(id);
        }

        return clientOpt;
    }

    @Transactional
    public Client salvar(Client client) {
        validarCpfUnico(client);
        validarContatosMinimos(client);
        validarEmailsMinimos(client);
        return clientRepository.save(client);
    }

    @Transactional
    public void excluir(Long id) {
        clientRepository.deleteById(id);
    }

    private void validarCpfUnico(Client client) {
        if (client.getId() == null) {
            // Novo cliente
            if (clientRepository.findByCpf(client.getCpf()).isPresent()) {
                throw new IllegalArgumentException("CPF já cadastrado");
            }
        } else {
            // Edição
            if (clientRepository.existsByCpfAndIdNot(client.getCpf(), client.getId())) {
                throw new IllegalArgumentException("CPF já cadastrado para outro cliente");
            }
        }
    }

    private void validarContatosMinimos(Client client) {
        if (client.getContatos() == null || client.getContatos().isEmpty()) {
            throw new IllegalArgumentException("Pelo menos um contato é obrigatório");
        }
    }

    private void validarEmailsMinimos(Client client) {
        if (client.getEmails() == null || client.getEmails().isEmpty()) {
            throw new IllegalArgumentException("Pelo menos um email é obrigatório");
        }
    }
}
```

#### 🔑 Pontos-chave

**`@Service`**

- Marca a classe como componente de serviço (Spring gerencia o ciclo de vida)

**`@Autowired`**

- Injeção de dependência automática (Spring injeta instância do Repository)

**`@Transactional`**

- Garante atomicidade (tudo ou nada)
- `readOnly = true` → Otimiza queries de leitura (não abre transação de escrita)

**Validações Customizadas:**

- Bean Validation valida campos individuais (@NotBlank, @Size)
- Service valida regras complexas (CPF único, mínimo de contatos)

#### 💡 Insight Profissional

> "Separar validações simples (Bean Validation) de complexas (Service) segue o princípio **Single Responsibility**. Entidade valida estrutura, Service valida regras de negócio."

> "Usar `@Transactional` no Service (não no Repository) é best practice. Se uma operação falha, toda a transação é revertida."

---

## 7️⃣ Camada de Controle (Controllers)

### 🎮 O que são Controllers?

**Analogia:** Controllers são **recepcionistas/gerentes**:

- Recebem requisições HTTP
- Delegam para Services
- Retornam views ou dados JSON

### 📄 ClientController.java

```java
// filepath: src/main/java/.../controller/ClientController.java
@Controller
@RequestMapping("/clientes")
public class ClientController {

    @Autowired
    private ClientService clientService;

    @GetMapping
    public String listar(Model model) {
        model.addAttribute("clientes", clientService.listarTodos());
        return "listar"; // retorna listar.jsp
    }

    @GetMapping("/novo")
    public String novo(Model model) {
        Client client = new Client();
        client.getContatos().add(new Contato());
        client.getEmails().add(new Email());
        client.setEndereco(new Endereco());
        model.addAttribute("cliente", client);
        return "form";
    }

    @GetMapping("/editar/{id}")
    public String editar(@PathVariable Long id, Model model, RedirectAttributes redirect) {
        return clientService.buscarPorId(id)
            .map(client -> {
                model.addAttribute("cliente", client);
                return "form";
            })
            .orElseGet(() -> {
                redirect.addFlashAttribute("erro", "Cliente não encontrado");
                return "redirect:/clientes";
            });
    }

    @PostMapping("/salvar")
    public String salvar(
            @RequestParam(required = false) Long id,
            @RequestParam String nome,
            @RequestParam String cpf,
            @RequestParam String dataNascimento,
            @RequestParam(value = "contato[]") String[] contatos,
            @RequestParam(value = "tipoContato[]") String[] tiposContato,
            @RequestParam(value = "email[]") String[] emails,
            @RequestParam(value = "tipoEmail[]") String[] tiposEmail,
            @RequestParam String rua,
            @RequestParam String numero,
            @RequestParam String bairro,
            @RequestParam String cep,
            @RequestParam String cidade,
            @RequestParam String estado,
            @RequestParam(required = false) String complemento,
            RedirectAttributes redirect) {

        try {
            Client client = id != null ?
                clientService.buscarPorId(id).orElse(new Client()) :
                new Client();

            client.setNome(nome);
            client.setCpf(cpf);
            client.setDataNascimento(LocalDate.parse(dataNascimento));

            // Processa arrays de contatos
            client.setContatos(new ArrayList<>());
            for (int i = 0; i < contatos.length; i++) {
                if (!contatos[i].trim().isEmpty()) {
                    Contato contato = new Contato(contatos[i], tiposContato[i]);
                    client.addContato(contato);
                }
            }

            // Processa arrays de emails
            client.setEmails(new ArrayList<>());
            for (int i = 0; i < emails.length; i++) {
                if (!emails[i].trim().isEmpty()) {
                    Email email = new Email(emails[i], tiposEmail[i]);
                    client.addEmail(email);
                }
            }

            // Processa endereço
            Endereco endereco = client.getEndereco() != null ?
                client.getEndereco() : new Endereco();
            endereco.setRua(rua);
            endereco.setNumero(numero);
            endereco.setBairro(bairro);
            endereco.setCep(cep);
            endereco.setCidade(cidade);
            endereco.setEstado(estado);
            endereco.setComplemento(complemento);
            client.setEndereco(endereco);

            clientService.salvar(client);
            redirect.addFlashAttribute("sucesso", "Cliente salvo com sucesso!");

        } catch (Exception e) {
            redirect.addFlashAttribute("erro", e.getMessage());
            return "redirect:/clientes/novo";
        }

        return "redirect:/clientes";
    }

    @GetMapping("/excluir/{id}")
    public String excluir(@PathVariable Long id, RedirectAttributes redirect) {
        try {
            clientService.excluir(id);
            redirect.addFlashAttribute("sucesso", "Cliente excluído com sucesso!");
        } catch (Exception e) {
            redirect.addFlashAttribute("erro", "Erro ao excluir cliente");
        }
        return "redirect:/clientes";
    }
}
```

#### 🔍 Explicação Detalhada

**`@Controller`**

- Marca classe como controlador MVC (retorna views)
- Diferente de `@RestController` (que retorna JSON)

**`@RequestMapping("/clientes")`**

- Prefixo de URL para todos os métodos desta classe

**`@GetMapping` vs `@PostMapping`**

- `@GetMapping` → Requisições GET (consultas, navegação)
- `@PostMapping` → Requisições POST (criar/atualizar dados)

**`Model model`**

- Objeto para passar dados do Controller para a View (JSP)
- `model.addAttribute("clientes", lista)` → JSP acessa via `${clientes}`

**`@PathVariable Long id`**

- Extrai variável da URL: `/clientes/editar/5` → id = 5

**`@RequestParam`**

- Extrai parâmetros do formulário (POST) ou query string (GET)
- `@RequestParam(value = "contato[]")` → Arrays vindos de inputs dinâmicos

**`RedirectAttributes`**

- Passa mensagens entre redirecionamentos (flash attributes)
- `redirect.addFlashAttribute("sucesso", "...")` → Mensagem de sucesso

#### 💡 Insights Profissionais

> "**PRG Pattern (Post-Redirect-Get):** Após um POST, sempre redirecione. Isso evita reenvio de formulário ao dar F5."

> "Arrays `contato[]` e `email[]` vêm de campos dinâmicos no formulário (adicionados via JavaScript). Spring mapeia automaticamente para `String[]`."

> "Método `salvar()` tem muitos parâmetros (code smell). Em produção, usaríamos **DTO (Data Transfer Object)** com `@ModelAttribute`."

---

## 8️⃣ Camada de Visualização (JSP)

### 🎨 O que são JSP?

**Analogia:** JSP (JavaServer Pages) são **templates HTML com superpoderes**:

- Misturam HTML estático com lógica dinâmica (loops, condicionais)
- São compiladas em Servlets pelo Tomcat

### 📄 listar.jsp (Listagem de Clientes)

```jsp
<!-- filepath: src/main/webapp/WEB-INF/jsp/listar.jsp -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8"/>
    <title>Lista de Clientes</title>
    <style>
        /* ...CSS omitido para brevidade... */
    </style>
</head>
<body>
    <div class="container">
        <h2>📋 Gestão de Clientes</h2>

        <!-- Mensagem de sucesso -->
        <c:if test="${not empty sucesso}">
            <div class="alert alert-success">
                ✅ ${sucesso}
            </div>
        </c:if>

        <!-- Tabela de clientes -->
        <c:choose>
            <c:when test="${empty clientes}">
                <div>Nenhum cliente cadastrado</div>
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
                            <th>Endereço</th>
                            <th>Ações</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="c" items="${clientes}">
                            <tr>
                                <td>${c.nome}</td>
                                <td>${c.cpf}</td>
                                <td>
                                    <c:set var="formatter" value="<%= DateTimeFormatter.ofPattern(\"dd/MM/yyyy\") %>" />
                                    ${c.dataNascimento.format(formatter)}
                                </td>
                                <td>
                                    <c:forEach var="contato" items="${c.contatos}">
                                        ${contato.telefone} <span class="badge">${contato.tipo}</span><br/>
                                    </c:forEach>
                                </td>
                                <td>
                                    <c:forEach var="email" items="${c.emails}">
                                        ${email.endereco} <span class="badge">${email.tipo}</span><br/>
                                    </c:forEach>
                                </td>
                                <td>
                                    ${c.endereco.rua}, ${c.endereco.numero}<br/>
                                    ${c.endereco.bairro} - CEP: ${c.endereco.cep}<br/>
                                    <strong>${c.endereco.cidade}/${c.endereco.estado}</strong>
                                </td>
                                <td>
                                    <a href="/clientes/editar/${c.id}">🖊️ Editar</a>
                                    <a href="/clientes/excluir/${c.id}"
                                       onclick="return confirm('Deseja excluir ${c.nome}?')">
                                        🗑️ Excluir
                                    </a>
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
```

#### 🔑 Tags JSTL Importantes

**`<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>`**

- Importa biblioteca de tags JSTL (evita Java inline)

**`<c:if test="${condition}">`**

- Condicional (if simples)

**`<c:choose>`, `<c:when>`, `<c:otherwise>`**

- Estrutura switch/case

**`<c:forEach var="c" items="${clientes}">`**

- Loop sobre lista (como for-each)
- `var="c"` → Variável de iteração
- `items="${clientes}"` → Lista vinda do Model

**EL (Expression Language):**

- `${c.nome}` → Acessa propriedade `nome` do objeto `c`
- `${not empty sucesso}` → Verifica se variável não está vazia

#### 💡 Insight Profissional

> "JSTL é preferível a **scriptlets** (`<% código Java %>`) porque separa lógica de apresentação. Scriptlets são considerados má prática desde 2004."

> "LocalDate não é suportado nativamente por `<fmt:formatDate>`. Solução: usar `DateTimeFormatter` via EL ou criar um custom tag."

---

### 📄 form.jsp (Formulário de Cadastro/Edição)

```jsp
<!-- filepath: src/main/webapp/WEB-INF/jsp/form.jsp -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8"/>
    <title>${cliente.id != null ? 'Editar' : 'Novo'} Cliente</title>
    <style>/* ...CSS... */</style>
</head>
<body>
<div class="container">
    <h2>${cliente.id != null ? '✏️ Editar' : '➕ Novo'} Cliente</h2>

    <form action="/clientes/salvar" method="post" id="clientForm">
        <input type="hidden" name="id" value="${cliente.id}"/>

        <!-- Dados Pessoais -->
        <div class="section">
            <div class="section-title">👤 Dados Pessoais</div>
            <input type="text" name="nome" value="${cliente.nome}" required/>
            <input type="text" id="cpf" name="cpf" value="${cliente.cpf}"
                   placeholder="000.000.000-00" required/>
            <input type="date" name="dataNascimento" value="${cliente.dataNascimento}" required/>
        </div>

        <!-- Contatos Dinâmicos -->
        <div class="section">
            <div class="section-title">📱 Contatos</div>
            <div id="contatosContainer">
                <c:forEach var="contato" items="${cliente.contatos}" varStatus="status">
                    <div class="dynamic-item">
                        <input type="text" name="contato[]" value="${contato.telefone}"
                               placeholder="(00) 00000-0000" ${status.index == 0 ? 'required' : ''}/>
                        <select name="tipoContato[]">
                            <option value="Celular" ${contato.tipo == 'Celular' ? 'selected' : ''}>Celular</option>
                            <option value="Fixo" ${contato.tipo == 'Fixo' ? 'selected' : ''}>Fixo</option>
                        </select>
                        <c:if test="${status.index > 0}">
                            <button type="button" onclick="removeItem(this)">🗑️</button>
                        </c:if>
                    </div>
                </c:forEach>
            </div>
            <button type="button" onclick="addContato()">➕ Adicionar Contato</button>
        </div>

        <!-- ... Emails e Endereço similar ... -->

        <button type="submit">💾 Salvar</button>
        <a href="/clientes">↩️ Cancelar</a>
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

    // Adiciona novo campo de contato dinamicamente
    function addContato() {
        const container = document.getElementById('contatosContainer');
        const div = document.createElement('div');
        div.className = 'dynamic-item';
        div.innerHTML = `
            <input type="text" name="contato[]" placeholder="(00) 00000-0000"/>
            <select name="tipoContato[]">
                <option value="Celular">Celular</option>
                <option value="Fixo">Fixo</option>
            </select>
            <button type="button" onclick="removeItem(this)">🗑️</button>
        `;
        container.appendChild(div);
    }

    function removeItem(btn) {
        btn.parentElement.remove();
    }
</script>
</body>
</html>
```

#### 🔍 Destaques do Formulário

**Campos Dinâmicos:**

- `name="contato[]"` → Array de inputs (HTML5)
- JavaScript adiciona/remove campos em tempo real
- Spring mapeia `String[]` no Controller

**Operador Ternário EL:**

```jsp
${cliente.id != null ? 'Editar' : 'Novo'}
```

- Renderiza "Editar" se id existir, "Novo" caso contrário

**Selected Condicional:**

```jsp
<option value="Celular" ${contato.tipo == 'Celular' ? 'selected' : ''}>
```

- Marca opção selecionada ao editar

**Máscaras JavaScript:**

- Aplicam formatação em tempo real (CPF, telefone, CEP)
- Melhoram UX sem validação no backend

#### 💡 Insight Profissional

> "Campos dinâmicos (adicionar/remover telefones) são essenciais em CRUD modernos. Usamos JavaScript vanilla para manter simplicidade didática, mas em produção React/Vue seriam mais adequados."

> "Máscaras no frontend são UX, validação real ocorre no backend (Service + Bean Validation)."

---

## 9️⃣ Fluxo Completo de uma Requisição

### 🔄 Exemplo: Criar Novo Cliente

```
┌──────────────────────────────────────────────────────────────┐
│ 1. Usuário clica "Novo Cliente"                             │
└────────────────┬─────────────────────────────────────────────┘
                 │ GET /clientes/novo
                 ▼
┌────────────────────────────────────────────────────────────────┐
│ 2. ClientController.novo()                                     │
│    - Cria Client vazio com 1 contato, 1 email, 1 endereço     │
│    - Adiciona ao Model                                         │
│    - Retorna "form" (form.jsp)                                 │
└────────────────┬───────────────────────────────────────────────┘
                 │
                 ▼
┌────────────────────────────────────────────────────────────────┐
│ 3. View Resolver                                               │
│    - Resolve "form" → /WEB-INF/jsp/form.jsp                    │
│    - Jasper compila JSP → Servlet                              │
└────────────────┬───────────────────────────────────────────────┘
                 │
                 ▼
┌────────────────────────────────────────────────────────────────┐
│ 4. form.jsp renderiza HTML                                     │
│    - Preenche campos com ${cliente.nome}, etc.                 │
│    - Retorna HTML ao navegador                                 │
└────────────────┬───────────────────────────────────────────────┘
                 │
                 ▼
┌────────────────────────────────────────────────────────────────┐
│ 5. Usuário preenche formulário e clica "Salvar"               │
└────────────────┬───────────────────────────────────────────────┘
                 │ POST /clientes/salvar (form data)
                 ▼
┌────────────────────────────────────────────────────────────────┐
│ 6. ClientController.salvar()                                   │
│    - Extrai parâmetros (@RequestParam)                         │
│    - Monta objeto Client com contatos, emails, endereço        │
│    - Chama clientService.salvar(client)                        │
└────────────────┬───────────────────────────────────────────────┘
                 │
                 ▼
┌────────────────────────────────────────────────────────────────┐
│ 7. ClientService.salvar()                                      │
│    - Valida CPF único                                          │
│    - Valida mínimo de contatos/emails                          │
│    - Chama clientRepository.save(client)                       │
└────────────────┬───────────────────────────────────────────────┘
                 │
                 ▼
┌────────────────────────────────────────────────────────────────┐
│ 8. ClientRepository.save()                                     │
│    - Hibernate gera SQL INSERT para clients                    │
│    - Cascade insere contatos, emails, endereco                 │
│    - Retorna Client com IDs gerados                            │
└────────────────┬───────────────────────────────────────────────┘
                 │
                 ▼
┌────────────────────────────────────────────────────────────────┐
│ 9. Controller redireciona (PRG Pattern)                        │
│    - redirect:/clientes (com flash attribute "sucesso")        │
└────────────────┬───────────────────────────────────────────────┘
                 │ GET /clientes
                 ▼
┌────────────────────────────────────────────────────────────────┐
│ 10. ClientController.listar()                                  │
│     - Busca todos clientes (clientService.listarTodos())       │
│     - Retorna "listar" (listar.jsp)                            │
└────────────────┬───────────────────────────────────────────────┘
                 │
                 ▼
┌────────────────────────────────────────────────────────────────┐
│ 11. listar.jsp renderiza tabela                                │
│     - Loop <c:forEach> sobre ${clientes}                       │
│     - Mostra mensagem de sucesso                               │
└────────────────────────────────────────────────────────────────┘
```

#### 💡 Dica de Apresentação

> "Esse fluxo mostra como **todas as camadas colaboram**. Nenhuma camada faz tudo sozinha, cada uma tem sua responsabilidade clara."

---

## 🔟 Melhores Práticas e Insights Profissionais

### ✅ Práticas Implementadas

1. **Separação de Responsabilidades (Layered Architecture)**

   - Controller não acessa Repository diretamente
   - Service contém lógica de negócio, não Controller

2. **Imutabilidade e Null Safety**

   - `Optional<Client>` ao invés de retornar null
   - `LocalDate` ao invés de `Date` mutable

3. **Convenção sobre Configuração (Spring Boot)**

   - application.properties mínimo
   - Auto-configuração de datasource, JPA, MVC

4. **Validação em Camadas**

   - Bean Validation (estrutura)
   - Service (regras de negócio)
   - Frontend (UX com máscaras)

5. **Transações**

   - `@Transactional` em operações de escrita
   - `readOnly = true` em consultas

6. **Cascade e Orphan Removal**
   - Simplifica gerenciamento de relacionamentos
   - Deleta automaticamente registros órfãos

### ⚠️ Code Smells e Melhorias (Produção)

1. **Controller com Muitos Parâmetros**
   - **Problema:** `salvar()` tem 15+ parâmetros
   - **Solução:** Usar DTO com `@ModelAttribute`

```java
public String salvar(@ModelAttribute ClientDTO dto, RedirectAttributes redirect) {
    // ...
}
```

2. **Falta de DTOs**

   - **Problema:** Expor entidades JPA diretamente
   - **Solução:** Criar DTOs para entrada/saída
   - **Benefício:** Desacopla API de modelo de dados

3. **Validação de CPF Simples**

   - **Problema:** Apenas regex, não valida dígitos verificadores
   - **Solução:** Implementar algoritmo completo ou usar biblioteca

4. **Sem Paginação**
   - **Problema:** `findAll()` pode retornar milhões de registros
   - **Solução:** `Pageable` no Repository

```java
Page<Client> findAll(Pageable pageable);
```

5. **Sem Logging Estruturado**

   - **Problema:** Dificulta debug em produção
   - **Solução:** SLF4J com contexto (request ID, user ID)

6. **Sem Tratamento Global de Exceções**
   - **Problema:** Try-catch genérico no Controller
   - **Solução:** `@ControllerAdvice` com handlers específicos

```java
@ControllerAdvice
public class GlobalExceptionHandler {
    @ExceptionHandler(IllegalArgumentException.class)
    public String handleValidation(IllegalArgumentException ex, Model model) {
        model.addAttribute("erro", ex.getMessage());
        return "erro";
    }
}
```

7. **Autenticação/Autorização Ausente**
   - **Problema:** Qualquer um pode acessar/deletar clientes
   - **Solução:** Spring Security com roles

---

## 🎤 Roteiro de Apresentação (Sugestão)

### Introdução (5 min)

1. Apresentar problema real (gerenciar clientes)
2. Mostrar arquitetura geral (diagrama de camadas)
3. Tecnologias escolhidas e porquê

### Demo Prática (10 min)

1. Subir aplicação com Docker Compose
2. Criar cliente pelo navegador
3. Mostrar tabela listando dados
4. Editar e excluir
5. Mostrar banco de dados no PostgreSQL

### Deep Dive Técnico (25 min)

1. **pom.xml:** Dependências e Maven (5 min)
2. **docker-compose.yml:** Containerização (3 min)
3. **Entidades JPA:** Client, Contato, Email, Endereco (5 min)
4. **Repository:** Query Methods e queries customizadas (4 min)
5. **Service:** Validações e transações (4 min)
6. **Controller:** Requisições e redirecionamentos (3 min)
7. **JSP:** JSTL e campos dinâmicos (3 min)

### Fluxo Completo (5 min)

- Desenhar fluxo de criação de cliente no quadro
- Mostrar como as camadas colaboram

### Boas Práticas e Melhorias (5 min)

- Listar práticas implementadas
- Discutir code smells e como melhorar

### Perguntas e Discussão (5-10 min)

---

## 📚 Conceitos-Chave para Dominar

### Para Responder Perguntas

**"Por que usar Spring Boot ao invés de Java puro?"**

- Auto-configuração elimina boilerplate
- Servidor embutido (não precisa instalar Tomcat separado)
- Ecossistema maduro (segurança, testes, monitoramento)

**"Por que JPA/Hibernate?"**

- Produtividade: não escrever SQL manual
- Portabilidade: trocar banco sem reescrever queries
- ORM resolve impedance mismatch (objetos ≠ tabelas)

**"Por que PostgreSQL?"**

- Open-source e robusto
- ACID completo
- Suporta JSON, arrays, full-text search (escalável)

**"Por que JSP ainda se usa React/Vue são modernos?"**

- SSR (Server-Side Rendering) é mais simples para CRUD
- Sem necessidade de API separada
- Menor complexidade de deploy
- **Mas:** Em projetos grandes, SPA (React/Vue) + API REST é preferível

**"O que é N+1 problem?"**

```java
List<Client> clients = repository.findAll(); // 1 query
for (Client c : clients) {
    c.getContatos().size(); // N queries adicionais (lazy load)
}
```

**Solução:** `JOIN FETCH` ou `@EntityGraph`

**"Por que múltiplas queries ao invés de 1 JOIN FETCH?"**

- Hibernate não permite `JOIN FETCH` de múltiplas bags simultaneamente
- 3 queries dentro da mesma transação usam cache L1 (eficiente)

---

## 🏆 Dicas Finais para Brilhar

### Durante a Apresentação

1. **Não leia slides/código**

   - Explique com suas palavras
   - Use analogias do dia a dia

2. **Mostre o código rodando**

   - Demo ao vivo impressiona
   - Se der erro, mostre como debugar

3. **Antecipe perguntas**

   - "Vocês podem estar pensando: por que não usar X?"
   - Responda antes de perguntarem

4. **Desenhe no quadro**

   - Fluxo de dados
   - Arquitetura
   - Diagrama ER

5. **Conte histórias**
   - "Na minha experiência..."
   - "Um erro comum é..."

### Postura Profissional

- **Seja honesto:** Se não souber, diga "Boa pergunta, vou pesquisar"
- **Valorize alternativas:** "Outra abordagem seria..."
- **Reconheça limitações:** "Para produção, precisaríamos adicionar..."

---

## 📖 Glossário de Termos

- **ORM:** Object-Relational Mapping (mapeia objetos para tabelas)
- **DTO:** Data Transfer Object (objeto para transferir dados entre camadas)
- **POJO:** Plain Old Java Object (classe simples sem dependências)
- **Cascade:** Propaga operações de pai para filhos (ex: salvar Client salva Contatos)
- **Lazy Load:** Dados são carregados sob demanda (quando acessados)
- **Eager Load:** Dados são carregados imediatamente (JOIN)
- **N+1 Problem:** Anti-pattern onde 1 query gera N queries adicionais
- **Transaction:** Unidade atômica de trabalho (tudo ou nada)
- **ACID:** Atomicity, Consistency, Isolation, Durability (propriedades de transações)
- **RESTful:** Arquitetura de APIs baseada em recursos e verbos HTTP

---

## 🎯 Checklist Pré-Apresentação

- [ ] Aplicação rodando localmente
- [ ] Docker Compose testado
- [ ] Banco de dados com dados de exemplo
- [ ] Código comentado e organizado
- [ ] Slides/diagramas prontos
- [ ] Exemplos práticos preparados
- [ ] Possíveis perguntas antecipadas
- [ ] Backup plan se demo falhar (screenshots/vídeo)

---

## 💡 Frases de Impacto para Usar

> "Spring Boot não é mágica, é convenção sobre configuração."

> "A separação em camadas não é burocracia, é manutenibilidade."

> "Cada linha de código é uma decisão de design."

> "Validar no frontend é UX, validar no backend é segurança."

> "Um bom desenvolvedor sabe quando NÃO adicionar complexidade."

---

**Boa sorte na apresentação! Você vai brilhar! 🌟**

_Lembre-se: Domínio técnico + clareza na comunicação = Apresentação de sucesso._
