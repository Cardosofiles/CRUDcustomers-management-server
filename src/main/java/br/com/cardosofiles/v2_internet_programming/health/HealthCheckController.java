package br.com.cardosofiles.v2_internet_programming.health;

import java.sql.Connection;
import java.time.Duration;
import java.time.Instant;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;
import javax.sql.DataSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.env.Environment;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/health")
public class HealthCheckController {

    private static final DateTimeFormatter FORMATTER =
            DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");
    private static final ZoneId BRAZIL_ZONE = ZoneId.of("America/Sao_Paulo");
    private final Instant startTime = Instant.now();

    @Autowired
    private DataSource dataSource;

    @Autowired
    private Environment env;

    @Value("${spring.application.name}")
    private String applicationName;

    @Value("${server.port}")
    private String serverPort;

    @Value("${spring.profiles.active:default}")
    private String activeProfile;

    @GetMapping
    public ResponseEntity<Map<String, Object>> healthCheck() {
        Map<String, Object> response = new LinkedHashMap<>();

        boolean allHealthy = true;

        // 🔍 Status Geral
        response.put("status", "CHECKING");
        response.put("application", applicationName);
        response.put("profile", activeProfile);
        response.put("timestamp", ZonedDateTime.now(BRAZIL_ZONE).format(FORMATTER));
        response.put("uptime", getUptime());

        // 🎨 Mensagem de Boas-Vindas
        response.put("message", "🚀 Customer Management System - API Running!");

        // ✅ Verificação de Variáveis de Ambiente
        Map<String, Object> envCheck = checkEnvironmentVariables();
        response.put("environment", envCheck);
        if (!"OK".equals(envCheck.get("status"))) {
            allHealthy = false;
        }

        // 💾 Verificação do Banco de Dados
        Map<String, Object> dbCheck = checkDatabaseConnection();
        response.put("database", dbCheck);
        if (!"OK".equals(dbCheck.get("status"))) {
            allHealthy = false;
        }

        // 🌐 Informações do Servidor
        response.put("server", getServerInfo());

        // 📊 Status Final
        response.put("status", allHealthy ? "✅ HEALTHY" : "⚠️ DEGRADED");
        response.put("healthy", allHealthy);

        HttpStatus httpStatus = allHealthy ? HttpStatus.OK : HttpStatus.SERVICE_UNAVAILABLE;
        return ResponseEntity.status(httpStatus).body(response);
    }

    @GetMapping("/ping")
    public ResponseEntity<Map<String, String>> ping() {
        Map<String, String> response = new HashMap<>();
        response.put("status", "✅ PONG");
        response.put("timestamp", ZonedDateTime.now(BRAZIL_ZONE).format(FORMATTER));
        response.put("message", "🏓 Server is responding");
        return ResponseEntity.ok(response);
    }

    @GetMapping("/ready")
    public ResponseEntity<Map<String, Object>> readiness() {
        Map<String, Object> response = new LinkedHashMap<>();

        // Verifica se o banco está acessível
        Map<String, Object> dbCheck = checkDatabaseConnection();
        boolean isReady = "OK".equals(dbCheck.get("status"));

        response.put("ready", isReady);
        response.put("status", isReady ? "✅ READY" : "⚠️ NOT READY");
        response.put("database", dbCheck);
        response.put("timestamp", ZonedDateTime.now(BRAZIL_ZONE).format(FORMATTER));

        HttpStatus httpStatus = isReady ? HttpStatus.OK : HttpStatus.SERVICE_UNAVAILABLE;
        return ResponseEntity.status(httpStatus).body(response);
    }

    @GetMapping("/live")
    public ResponseEntity<Map<String, Object>> liveness() {
        Map<String, Object> response = new LinkedHashMap<>();
        response.put("alive", true);
        response.put("status", "✅ ALIVE");
        response.put("uptime", getUptime());
        response.put("timestamp", ZonedDateTime.now(BRAZIL_ZONE).format(FORMATTER));
        return ResponseEntity.ok(response);
    }

    // 🔍 Verificação de Variáveis de Ambiente
    private Map<String, Object> checkEnvironmentVariables() {
        Map<String, Object> envStatus = new LinkedHashMap<>();
        Map<String, String> variables = new LinkedHashMap<>();

        boolean allPresent = true;

        // Lista de variáveis críticas
        String[] criticalVars = {"DB_HOST", "DB_PORT", "DB_NAME", "DB_USER", "DB_PASSWORD"};

        for (String var : criticalVars) {
            String value = env.getProperty(var);
            if (value != null && !value.isEmpty()) {
                // Mascara valores sensíveis
                if (var.contains("PASSWORD") || var.contains("SECRET")) {
                    variables.put(var, "✅ [HIDDEN]");
                } else {
                    variables.put(var, "✅ Configured");
                }
            } else {
                variables.put(var, "❌ Missing (using default)");
                allPresent = false;
            }
        }

        // Variáveis opcionais
        String[] optionalVars = {"SERVER_PORT", "SPRING_PROFILES_ACTIVE", "HIBERNATE_DDL_AUTO"};

        for (String var : optionalVars) {
            String value = env.getProperty(var);
            if (value != null && !value.isEmpty()) {
                variables.put(var, "✅ " + value);
            }
        }

        envStatus.put("status", allPresent ? "OK" : "WARNING");
        envStatus.put("message", allPresent ? "✅ All critical environment variables configured"
                : "⚠️ Some variables using default values");
        envStatus.put("variables", variables);

        return envStatus;
    }

    // 💾 Verificação de Conexão com Banco de Dados
    private Map<String, Object> checkDatabaseConnection() {
        Map<String, Object> dbStatus = new LinkedHashMap<>();

        try {
            long startTime = System.currentTimeMillis();

            try (Connection connection = dataSource.getConnection()) {
                boolean isValid = connection.isValid(5); // timeout 5 segundos
                long responseTime = System.currentTimeMillis() - startTime;

                if (isValid) {
                    String dbUrl = connection.getMetaData().getURL();
                    String dbProduct = connection.getMetaData().getDatabaseProductName();
                    String dbVersion = connection.getMetaData().getDatabaseProductVersion();

                    dbStatus.put("status", "OK");
                    dbStatus.put("message", "✅ Database connection healthy");
                    dbStatus.put("product", dbProduct);
                    dbStatus.put("version", dbVersion);
                    dbStatus.put("url", maskConnectionUrl(dbUrl));
                    dbStatus.put("responseTime", responseTime + "ms");
                    dbStatus.put("poolSize", getPoolInfo());
                } else {
                    dbStatus.put("status", "ERROR");
                    dbStatus.put("message", "❌ Database connection invalid");
                }
            }
        } catch (Exception e) {
            dbStatus.put("status", "ERROR");
            dbStatus.put("message", "❌ Database connection failed");
            dbStatus.put("error", e.getClass().getSimpleName());
            dbStatus.put("details", e.getMessage());
        }

        return dbStatus;
    }

    // 🌐 Informações do Servidor
    private Map<String, Object> getServerInfo() {
        Map<String, Object> serverInfo = new LinkedHashMap<>();

        serverInfo.put("port", serverPort);
        serverInfo.put("timezone", BRAZIL_ZONE.getId());
        serverInfo.put("javaVersion", System.getProperty("java.version"));
        serverInfo.put("javaVendor", System.getProperty("java.vendor"));
        serverInfo.put("osName", System.getProperty("os.name"));
        serverInfo.put("osVersion", System.getProperty("os.version"));
        serverInfo.put("processors", Runtime.getRuntime().availableProcessors());

        // Memória
        Runtime runtime = Runtime.getRuntime();
        long maxMemory = runtime.maxMemory() / (1024 * 1024); // MB
        long totalMemory = runtime.totalMemory() / (1024 * 1024);
        long freeMemory = runtime.freeMemory() / (1024 * 1024);
        long usedMemory = totalMemory - freeMemory;

        Map<String, String> memory = new LinkedHashMap<>();
        memory.put("max", maxMemory + " MB");
        memory.put("total", totalMemory + " MB");
        memory.put("used", usedMemory + " MB");
        memory.put("free", freeMemory + " MB");

        serverInfo.put("memory", memory);

        return serverInfo;
    }

    // ⏱️ Tempo de Atividade
    private String getUptime() {
        Duration uptime = Duration.between(startTime, Instant.now());

        long days = uptime.toDays();
        long hours = uptime.toHoursPart();
        long minutes = uptime.toMinutesPart();
        long seconds = uptime.toSecondsPart();

        if (days > 0) {
            return String.format("%dd %dh %dm %ds", days, hours, minutes, seconds);
        } else if (hours > 0) {
            return String.format("%dh %dm %ds", hours, minutes, seconds);
        } else if (minutes > 0) {
            return String.format("%dm %ds", minutes, seconds);
        } else {
            return String.format("%ds", seconds);
        }
    }

    // 🔒 Mascara URL de Conexão (remove senha)
    private String maskConnectionUrl(String url) {
        if (url == null)
            return "unknown";
        // Remove possíveis senhas da URL
        return url.replaceAll("password=[^&;]*", "password=****");
    }

    // 🏊 Informações do Pool de Conexões
    private Map<String, String> getPoolInfo() {
        Map<String, String> poolInfo = new LinkedHashMap<>();

        try {
            // Tenta obter informações do HikariCP via reflection
            if (dataSource.getClass().getName().contains("HikariDataSource")) {
                poolInfo.put("type", "HikariCP");
                poolInfo.put("status", "Active");
            } else {
                poolInfo.put("type", dataSource.getClass().getSimpleName());
                poolInfo.put("status", "Active");
            }
        } catch (Exception e) {
            poolInfo.put("status", "Unknown");
        }

        return poolInfo;
    }
}
