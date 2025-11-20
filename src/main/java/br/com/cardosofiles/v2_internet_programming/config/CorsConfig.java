package br.com.cardosofiles.v2_internet_programming.config;

import java.util.Objects;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.lang.NonNull;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class CorsConfig {

    @Value("${cors.allowed.origins:http://localhost:3000,http://localhost:8080}")
    private String allowedOrigins;

    @Bean
    public WebMvcConfigurer corsConfigurer() {
        return new WebMvcConfigurer() {
            @Override
            public void addCorsMappings(@NonNull CorsRegistry registry) {
                registry.addMapping("/api/**").allowedOriginPatterns(getOrigins())
                        .allowedMethods("GET", "POST", "PUT", "DELETE", "PATCH", "OPTIONS")
                        .allowedHeaders("*").exposedHeaders("Authorization", "Content-Type")
                        .allowCredentials(true).maxAge(3600);
            }
        };
    }

    @NonNull
    private String[] getOrigins() {
        String origins = allowedOrigins != null ? allowedOrigins : "http://localhost:8080";
        return Objects.requireNonNull(origins.split(","));
    }
}
