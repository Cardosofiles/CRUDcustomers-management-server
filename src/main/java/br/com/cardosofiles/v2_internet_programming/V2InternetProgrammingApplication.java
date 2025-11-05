package br.com.cardosofiles.v2_internet_programming;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;

@SpringBootApplication
@ComponentScan(basePackages = "br.com.cardosofiles.v2_internet_programming")
public class V2InternetProgrammingApplication {

	public static void main(String[] args) {
		SpringApplication.run(V2InternetProgrammingApplication.class, args);
	}
}
